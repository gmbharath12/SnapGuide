//
//  AsyncImageView.h
//  FBSample
//
//  Created by Bharath G M on 11/19/13.
//  Copyright (c) 2013 Bharath G M. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AsyncImageView : UIView
{
     NSURLConnection* connection; 
     NSMutableData* data; 
}

- (void)loadImageFromURL:(NSURL*)url;
- (UIImage*) image;

@end
