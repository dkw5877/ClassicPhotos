//
//  ImageFiltration.h
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoRecord.h"

@protocol ImageFiltrationDelegate;

@interface ImageFiltration : NSOperation

@property(nonatomic, weak)id <ImageFiltrationDelegate> delegate;
@property(nonatomic, readonly)NSIndexPath* indexPath;
@property(nonatomic, readonly)PhotoRecord* photoRecord;

- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate;

@end

@protocol ImageFiltrationDelegate <NSObject>

- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration;

@end
