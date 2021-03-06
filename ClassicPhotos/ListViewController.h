//
//  ListViewController.h
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworking.h"
#import "PendingOperations.h"

//define constant for data source URL
#define kDatasourceURLString @"http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist"

@interface ListViewController : UITableViewController 
@property(nonatomic)NSMutableArray* photos;
@property(nonatomic)PendingOperations* pendingOperations;

@end
