//
//  PopularMedia.h
//  Snapguide
//
//  Created by Bharath G M on 11/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface PopularMedia : NSObject

@property (retain,nonatomic) NSString *lowResolutionImage;
@property (retain,nonatomic) UserInfo *userInfo;
@property (retain,nonatomic) NSString *highResolutionImage;

@end
