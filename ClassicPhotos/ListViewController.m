//
//  ListViewController.m
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "ListViewController.h"
#import "PhotoRecord.h"
#import "ImageDownloader.h"
#import "ImageFiltration.h"

@interface ListViewController ()<ImageDownloaderDelegate, ImageFiltrationDelegate>


@end

@implementation ListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(PendingOperations*)pendingOperations
{
    if (!_pendingOperations) {
        _pendingOperations = [[PendingOperations alloc]init];
    }
    
    return _pendingOperations;
}

//use lazy instantiation
-(NSMutableArray*)photos
{
    if(!_photos)
    {
        //create the URL
        NSURL* dataSourceURL = [NSURL URLWithString:kDatasourceURLString];
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:dataSourceURL];
        
        AFHTTPRequestOperation *datasource_download_operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        //set the network indicator
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        
        [datasource_download_operation  setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSData* datasoure_data = (NSData*)responseObject;
            
            CFPropertyListRef plist = CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)datasoure_data, kCFPropertyListImmutable, NULL);
            
            
            //create dictionary
            NSDictionary* datasource_dictionary = (__bridge NSDictionary*)plist;
            
            //create an array to hold the photo records
            NSMutableArray* records = [NSMutableArray array];
            
            //create the photo records and add them to the array
            for (NSString* key in datasource_dictionary) {
                PhotoRecord* record = [[PhotoRecord alloc]init];
                record.url = [NSURL URLWithString:[datasource_dictionary objectForKey:key]];
                record.name = key;
                [records addObject: record];
                record = nil;
            }
            
            self.photos = records;
            CFRelease(plist);
            
            [self.tableView reloadData];
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
        
        //load the photos data soure
        _photos = [[NSDictionary alloc]initWithContentsOfURL:dataSourceURL];
    }
    
    return _photos;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Classic Photos";
    self.tableView.rowHeight = 80;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kCellIdentifier = @"Cell Indentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PhotoRecord* record = self.photos[indexPath.row];
    
    NSString* rowKey = [[self.photos allKeys]objectAtIndex:indexPath.row];
    NSURL* url = [NSURL URLWithString:[self.photos valueForKey:rowKey]];
    NSData* imageData = [NSData dataWithContentsOfURL:url];
    UIImage* image = nil;
    
    if (imageData)
    {
        UIImage* unfilteredImage = [UIImage imageWithData:imageData];
        image = [self applySepiaFilterToImage: unfilteredImage];
    }
    
    cell.textLabel.text = rowKey;
    cell.imageView.image = image;
    return cell;
}

#pragma mark - Image Filtering Methods
-(UIImage*)applySepiaFilterToImage:(UIImage*)image
{
    //convert the UIImage to a CIImage
    CIImage* inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    UIImage* sepiaImage = nil;
    
    //create the Core Image context
    CIContext* context = [CIContext contextWithOptions:nil];
    
    //create the CIFilter
    CIFilter* filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,inputImage,@"inputIntensity",[NSNumber numberWithFloat:0.8], nil];
    
    //get the output image from the filter
    CIImage* outputImage = [filter outputImage];
    
    //create a core graphics image reference
    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //create the UIImage
    sepiaImage = [UIImage imageWithCGImage:outputImageRef];
    
    CGImageRelease(outputImageRef);
    
    return sepiaImage;
}

#pragma mark CustomOperationObjectDelegate Methods
- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader
{
    
}

- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration
{
    
}

@end
