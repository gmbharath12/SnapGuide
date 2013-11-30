//
//  PopularMediaViewController.m
//  Snapguide
//
//  Created by Bharath G M on 11/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "PopularMediaViewController.h"
#import "PopularMedia.h"
#import "AsyncImageView.h"

@interface PopularMediaViewController ()

@end

@implementation PopularMediaViewController
@synthesize accessToken,popularPhotosDictionary,poularPhotosArray;
@synthesize popularMedia;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Popular Photos";
    [self downloadPopularImages];
}

-(void)downloadPopularImages
{
[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

NSString *myPhotosEndPoint = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/popular?access_token=%@",accessToken];

//NSLog(@"Token = %@",accessToken);
//NSLog(@"TheWholeUrl: %@", myPhotosEndPoint);
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
                   self.popularPhotosDictionary = json;
//                   NSLog(@"No of objects: %d", [[json objectForKey:@"data"] count]);
                   
                   
                   dispatch_async(dispatch_get_main_queue(),
                                  ^{
                                      [self parseData:self.popularPhotosDictionary];
                                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                  });
               }
               
               );
}

-(void)parseData:(NSDictionary*)photoDictionary
{
//    NSLog(@"%@",photoDictionary);
    NSArray *lArray = [NSArray array];
    lArray = [photoDictionary objectForKey:kData];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < [lArray count]; i++)
    {
        NSString *str = [[lArray objectAtIndex:i] valueForKey:@"type"];
//                         NSLog(@"str = %@",str);
     
        if ([str isEqualToString:@"image"])
        {
            self.popularMedia = [[PopularMedia alloc] init];
            self.popularMedia.lowResolutionImage = [[[[lArray objectAtIndex:i] objectForKey:@"images"] objectForKey:@"low_resolution"] valueForKey:@"url"];
            self.popularMedia.highResolutionImage = [[[[lArray objectAtIndex:i] objectForKey:@"images"] objectForKey:@"standard_resolution"] valueForKey:@"url"];

            self.popularMedia.userInfo.userName = [[[lArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"username"];
            NSLog(@"Username = %@",self.popularMedia.userInfo.userName);
            self.popularMedia.userInfo.userFullName = [[[lArray objectAtIndex:i] objectForKey:@"user"] objectForKey:@"full_name"];
            self.popularMedia.userInfo.userProfilePic = [[[lArray objectAtIndex:i] objectForKey:@"user"] valueForKey:@"profile_picture"];
            [mutableArray addObject:self.popularMedia];
        }
        [self.popularMedia release];
        self.popularMedia = nil;
    }

    self.poularPhotosArray = mutableArray;
//    NSLog(@"Popular photos array count = %d",[poularPhotosArray count]);
    [self createTableView];

    
}

-(void)createTableView
{
    self.myTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 475) style:UITableViewStylePlain] autorelease];
    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.userInteractionEnabled = YES;
    [self.view addSubview:self.myTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyPhotos";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier] autorelease];
    }
    else
    {
        AsyncImageView* oldImage = (AsyncImageView*)[cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    PopularMedia *dataModelObject = [self.poularPhotosArray objectAtIndex:indexPath.row];
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
    
    [asyncImage loadImageFromURL:[NSURL URLWithString:dataModelObject.lowResolutionImage]];
    
    [cell.contentView addSubview:asyncImage];
    PopularMedia *userInformation =(PopularMedia*)[self.poularPhotosArray objectAtIndex:indexPath.row];
    cell.textLabel.text = userInformation.userInfo.userName;
    cell.detailTextLabel.text = userInformation.userInfo.userFullName;
//    NSLog(@"userInformation.userInfo.userName = %@",dataModelObject.userInfo);
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.poularPhotosArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
//    NSLog(@"standardResolution =%@",standardResolution);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
