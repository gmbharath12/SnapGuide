//
//  PopularMediaViewController.h
//  Snapguide
//
//  Created by Bharath G M on 11/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularMedia.h"

@interface PopularMediaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSString *accessToken;
@property (nonatomic,retain) NSDictionary *popularPhotosDictionary;
@property (nonatomic,retain) NSArray *poularPhotosArray;
@property (nonatomic,retain) PopularMedia *popularMedia;
@property (nonatomic,retain) UITableView *myTableView;
@end
