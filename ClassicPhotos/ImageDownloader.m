//
//  ImageDownloader.m
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "ImageDownloader.h"
@interface ImageDownloader()

@property(nonatomic, readwrite)NSIndexPath* indexPathInTableView;
@property(nonatomic, readwrite)PhotoRecord* photoRecord;

@end


@implementation ImageDownloader

- (id)initWithPhotoRecord:(PhotoRecord *)photoRecord atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate
{
    self = [super init];
    
    if (self) {
        _photoRecord = photoRecord;
        _indexPathInTableView =  indexPath;
        _delegate = theDelegate;
    }
    return self;

}

//override the main method

- (void)main
{
    //create an autorelease pool
    @autoreleasepool {
        
        //if the operation was canceled before we begin download just return
        if (self.isCancelled) {
            return;
        }
        
        NSData* imageData = [[NSData alloc]initWithContentsOfURL:self.photoRecord.url];
        
        //if the operation is canceled after we begin download, then nil the property and return
        if (self.isCancelled) {
            imageData = nil;
            return;
        }
        
        //if we retrieved the image, set it in the photo record, otherwise indicate failure
        if (imageData) {
            self.photoRecord.image = [UIImage imageWithData:imageData];
        }
        else{
            self.photoRecord.failed = YES;
        }
        
        imageData = nil; //clear the variable since we are done
        
        //once again, check if the operation was canceled, if so just return we are already done
        if (self.isCancelled) {
            return;
        }
        
        //finally, call the delegate method back on the main thread. We also need to cast it to an NSObject to get the performSelectorOnMainThread method
        [(NSObject*)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}

@end
