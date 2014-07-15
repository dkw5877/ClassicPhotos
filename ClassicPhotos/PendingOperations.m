//
//  PendingOperations.m
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations

-(NSMutableDictionary*)downloadsInProgress
{
    if (!_downloadsInProgress) {
        _downloadsInProgress = [[NSMutableDictionary alloc]init];
    }
    
    return _downloadsInProgress;
}


-(NSOperationQueue*)downloadQueue
{
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc]init];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 1;
    }
    
    return _downloadQueue;
}



-(NSMutableDictionary*)filtrationInProgress
{
    if (!_filtrationInProgress) {
        _filtrationInProgress = [[NSMutableDictionary alloc]init];
    }
    
    return _filtrationInProgress;
}

-(NSOperationQueue*)filtrationQueue
{
    if (!_filtrationQueue) {
        _filtrationQueue = [[NSOperationQueue alloc]init];
        _filtrationQueue.name = @"Image Filtration Queue";
        _filtrationQueue.maxConcurrentOperationCount = 1;
        
    }
    
    return _filtrationQueue;
}

@end
