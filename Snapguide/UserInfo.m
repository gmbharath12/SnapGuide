//
//  UserInfo.m
//  Snapguide
//
//  Created by Bharath G M on 11/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize userFullName,userName,userProfilePic;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.userProfilePic = nil;
        self.userName = nil;
        self.userFullName = nil;
    }
    return self;
}
@end
