//
//  ImageFiltration.m
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "ImageFiltration.h"
@interface ImageFiltration()

@property(nonatomic, readwrite)NSIndexPath* indexPathInTableView;
@property(nonatomic, readwrite)PhotoRecord* photoRecord;

@end


@implementation ImageFiltration

- (id)initWithPhotoRecord:(PhotoRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate
{
    self = [super init];
    
    if (self) {
        _photoRecord = record;
        _indexPathInTableView = indexPath;
        _delegate = theDelegate;
    }
    
    return self;
}

- (void)main
{
    @autoreleasepool {
        
        //check if operation is canceled, if so just return
        if (self.isCancelled) {
            return;
        }
        
        //if there is is no image assigned return, nothing to filter
        if (!self.photoRecord.hasImage) {
            return;
        }
        
        //get the downloaded image before we apply the filter
        UIImage* rawImage = self.photoRecord.image;
        UIImage* processedImage = [self applySepiaFilterToImage:rawImage];
        
        //check if operation is canceled, if so just return
        if (self.isCancelled) {
            return;
        }
        
        if (processedImage) {
            self.photoRecord.image =  processedImage;
            self.photoRecord.filtered = YES;
            
            //call the delegate method on the main thread
            [(NSObject*)self.delegate performSelectorOnMainThread:@selector(imageFiltrationDidFinish:) withObject:self waitUntilDone:YES];
        }
    }
}

#pragma mark
-(UIImage*)applySepiaFilterToImage:(UIImage*)image
{
    //convert the UIImage to a CIImage
    CIImage* inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    
    //check if the operation has been canceled before applying the filter
    //good practice is to call isCancelled  before and after any expensive method call
    if (self.isCancelled) {
        return nil;
    }
    
    UIImage* sepiaImage = nil;
    
    //create the Core Image context
    CIContext* context = [CIContext contextWithOptions:nil];
    
    //create the CIFilter
    CIFilter* filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,inputImage,@"inputIntensity",[NSNumber numberWithFloat:0.8], nil];
    
    //get the output image from the filter
    CIImage* outputImage = [filter outputImage];
    
    //check if the operation has been canceled after applying the filter
    if (self.isCancelled) {
        return nil;
    }
    
    //create a core graphics image reference
    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //check again if the operation has been canceled, release ref if so
    if (self.isCancelled) {
        CGImageRelease(outputImageRef);
        return nil;
    }
    
    
    //create the UIImage
    sepiaImage = [UIImage imageWithCGImage:outputImageRef];
    
    CGImageRelease(outputImageRef);
    
    return sepiaImage;
}

@end


