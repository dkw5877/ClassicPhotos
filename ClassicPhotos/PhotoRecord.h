//
//  PhotoRecord.h
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoRecord : NSObject

@property(nonatomic)NSString* name;
@property(nonatomic)UIImage* image;
@property(nonatomic)NSURL* url;
@property(nonatomic)BOOL hasImage;
@property(nonatomic, getter=isFiltered)BOOL filtered;
@property(nonatomic, getter=isFailed)BOOL failed;


@end
