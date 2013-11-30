//
//  PopularMedia.m
//  Snapguide
//
//  Created by Bharath G M on 11/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "PopularMedia.h"
#import "UserInfo.h"

@implementation PopularMedia
@synthesize userInfo,lowResolutionImage,highResolutionImage;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.userInfo = [[[UserInfo alloc] init] autorelease];
        self.lowResolutionImage = nil;
        self.highResolutionImage = nil;
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}
@end
