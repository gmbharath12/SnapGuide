//
//  ViewController.h
//  Snapguide
//
//  Created by Bharath G M on 11/12/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPhotos.h"

@interface ViewController : UIViewController<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDictionary *myPhotosDictionary;
@property (nonatomic, strong) MyPhotos *myPhotos;
@property (nonatomic, retain) NSArray *arrayOfMyPhotos;
@property (nonatomic, retain) UITableView *myTableView;
@end
