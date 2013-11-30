//
//  MyPhotos.m
//  Snapguide
//
//  Created by Bharath G M on 11/15/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import "MyPhotos.h"

@implementation MyPhotos
@synthesize likesCount,locationName,imageLowResolution;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.likesCount = nil;
        self.locationName = nil;
        self.imageLowResolution = nil;
    }
    return self;
}
@end
