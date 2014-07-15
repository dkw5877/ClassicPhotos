//
//  PhotoRecord.m
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "PhotoRecord.h"

@implementation PhotoRecord

-(BOOL)hasImage
{
    return _image != nil;
}

-(BOOL)isFiltered
{
    return _filtered;
}

-(BOOL)isFailed
{
    return _failed;
}

@end
