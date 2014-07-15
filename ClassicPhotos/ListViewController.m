//
//  ListViewController.m
//  ClassicPhotos
//
//  Created by user on 7/14/14.
//  Copyright (c) 2014 someCompanyNameHere. All rights reserved.
//

#import "ListViewController.h"


@interface ListViewController ()

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

//use lazy instantiation
-(NSDictionary*)photos
{
    if(!_photos)
    {
        //create the URL
        NSURL* dataSourceURL = [NSURL URLWithString:kDatasourceURLString];
        
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


@end
