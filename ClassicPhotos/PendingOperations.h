//
//  PendingOperations.h
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject

@property(nonatomic)NSMutableDictionary* downloadsInProgress;
@property(nonatomic)NSOperationQueue* downloadQueue;

@property(nonatomic)NSMutableDictionary* filtrationInProgress;
@property(nonatomic)NSOperationQueue* filtrationQueue;

@end
