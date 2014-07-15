//
//  ImageDownloader.h
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoRecord.h" 

@protocol ImageDownloaderDelegate;

@interface ImageDownloader : NSOperation

@property(nonatomic, assign)id <ImageDownloaderDelegate> delegate;

@property(nonatomic, readonly)NSIndexPath* indexPath;
@property(nonatomic, readonly)PhotoRecord* photoRecord;

-(id)initWithPhotoRecord:(PhotoRecord*)photoRecord atIndexPath:(NSIndexPath*)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate;

@end


//declare the delegate protocol
@protocol ImageDownloaderDelegate <NSObject>

-(void)imageDownloaderDidFinish:(ImageDownloader*)downloader;

@end

