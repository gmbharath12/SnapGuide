//
//  ViewController.m
//  Snapguide
//
//  Created by Bharath G M on 11/12/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "ViewController.h"
#import "PopularMediaViewController.h"
#import "AsyncImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[[UIWebView alloc] initWithFrame:self.view.bounds] autorelease];
    self.webView.delegate = self;
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:
                                  [NSString stringWithFormat:kAuthenticationEndpoint, kClientId, kRedirectUrl]]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    [_webView release];
    self.title = @"My Photos";
    self.view.backgroundColor  = [UIColor whiteColor];

}

#pragma mark - Web view delegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    
    if ([request.URL.absoluteString rangeOfString:@"#"].location != NSNotFound) {
        NSString* params = [[request.URL.absoluteString componentsSeparatedByString:@"#"] objectAtIndex:1];
        self.accessToken = [params stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
        self.webView.hidden = YES;
//        [self requestImages];
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.accessToken forKey:kUserAccessTokenKey];
        [defaults synchronize];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Popular"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(popularPhotos:)];
        NSLog(@"Access Token = %@",[[NSUserDefaults standardUserDefaults] valueForKey:kUserAccessTokenKey]);
        [self myPhotos:self.accessToken];
    }
    
	return YES;
}

-(void)myPhotos:(NSString*)accessToken
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSString *myPhotosEndPoint = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent?access_token=%@",accessToken];
    
    NSLog(@"Token = %@",accessToken);
    NSLog(@"TheWholeUrl: %@", myPhotosEndPoint);
    NSURL *myPhotosUrl = [NSURL URLWithString:myPhotosEndPoint];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:myPhotosUrl];
                       [req setHTTPMethod:@"GET"];
                       
                       NSURLResponse *response;
                       NSError *err;
                       NSData *responseData = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&err];
                       NSDictionary* json = [NSJSONSerialization
                                             JSONObjectWithData:responseData
                                             options:kNilOptions
                                             error:&err];
                       self.myPhotosDictionary = json;
//                       NSLog(@"No of objects: %d", [[json objectForKey:@"data"] count]);
                       
//                       NSString *content = [NSString stringWithUTF8String:[responseData bytes]];
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          [self parseData:self.myPhotosDictionary];
                                          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                      });
                   }
                   
                   );

}


-(void)parseData:(NSDictionary*)myPhotos
{
    NSArray *lArray = [NSArray array];
    lArray = [myPhotos objectForKey:kData];
//    NSLog(@"Name = %@",[[[lArray objectAtIndex:0] objectForKey:@"location"] objectForKey:@"name"]);
    NSMutableArray *arrayOfMyPhotos = [NSMutableArray array];
    
    for (int i = 0; i < [lArray count]; i++)
    {
        self.myPhotos = [[MyPhotos alloc] init];
        self.myPhotos.locationName = [[[lArray objectAtIndex:i] objectForKey:@"location"] objectForKey:@"name"];
        self.myPhotos.likesCount = [[[lArray objectAtIndex:i] objectForKey:@"likes"] objectForKey:@"count"];
        self.myPhotos.imageLowResolution = [[[[lArray objectAtIndex:i] objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
//        NSLog(@"Data Object = %@",self.myPhotos.imageLowResolution);
        [arrayOfMyPhotos addObject:self.myPhotos];
        [self.myPhotos release];
        self.myPhotos = nil;
    }
    self.arrayOfMyPhotos = arrayOfMyPhotos;
    
    [self createTableView];
}


-(void)createTableView
{
    self.myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 475) style:UITableViewStylePlain] autorelease];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     static NSString *cellIdentifier = @"MyPhotos";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    else
    {
        AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    MyPhotos *dataModelObject = [self.arrayOfMyPhotos objectAtIndex:indexPath.row];
//    NSLog(@"imageLowResolution URl = %@",dataModelObject.imageLowResolution);
    cell.contentView.hidden = NO;
    CGRect frame;
    frame.size.width = 75;
    frame.size.height = 65;
    frame.origin.x = 225;
    frame.origin.y = 15;

    AsyncImageView* asyncImage = [[AsyncImageView alloc]
                                  initWithFrame:frame] ;
    asyncImage.tag = 999;
    
    asyncImage.layer.cornerRadius = 2.0;
    asyncImage.layer.borderWidth = 1.2;
    asyncImage.layer.borderColor = [UIColor grayColor].CGColor;
    
    [asyncImage loadImageFromURL:[NSURL URLWithString:dataModelObject.imageLowResolution]];
    
    [cell.contentView addSubview:asyncImage];
    cell.textLabel.text =[[self.arrayOfMyPhotos objectAtIndex:indexPath.row] locationName];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfMyPhotos count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)popularPhotos:(id)sender
{
    PopularMediaViewController *mediaViewController = [[PopularMediaViewController alloc] init];
    mediaViewController.accessToken = self.accessToken;
    [self.navigationController pushViewController:mediaViewController animated:YES];
    [mediaViewController release];
    
}


-(void)dealloc
{
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
