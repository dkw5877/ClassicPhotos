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
            
            //update the table
            [self.tableView reloadData];
            
            //stop activity indicator
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            alert = nil;
            
            //stop activity indicator in event of error
            [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
            
        }];

        //add the download operation to the download queue
        [self.pendingOperations.downloadQueue addOperation:datasource_download_operation];
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

    
    //create an activity indicator view
    UIActivityIndicatorView* activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //set the cell's accessory view to the new activity indicator view
    cell.accessoryView = activityIndicatorView;
    
    PhotoRecord* record = self.photos[indexPath.row];
    
    //check if the record already has the image
    if (record.hasImage) {
        
        [(UIActivityIndicatorView*) cell.accessoryView stopAnimating];
        cell.imageView.image = record.image;
        cell.textLabel.text = record.name;
    }
    else if (record.failed){
        [(UIActivityIndicatorView*) cell.accessoryView stopAnimating];
        cell.textLabel.text = @"Failed to load";
    }
    else{//download the image
        [(UIActivityIndicatorView*) cell.accessoryView stopAnimating];
        cell.textLabel.text = @"loading";
        [self startOperationsForPhotoRecord:record atIndexPath:indexPath];
    }
    

    return cell;
}

#pragma mark - Image Filtering Methods
-(void)startOperationsForPhotoRecord:(PhotoRecord*)record atIndexPath:(NSIndexPath*)indexPath
{
    if (!record.hasImage) {
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
    }
    
    if (!record.filtered) {
        [self startImageFiltrationForRecord:record atIndexPath:indexPath];
    }
}

-(void)startImageDownloadingForRecord:(PhotoRecord*)record atIndexPath:(NSIndexPath*)indexPath
{
    
}


-(void)startImageFiltrationForRecord:(PhotoRecord*)record atIndexPath:(NSIndexPath*)indexPath
{
    
}


#pragma mark CustomOperationObjectDelegate Methods
- (void)imageDownloaderDidFinish:(ImageDownloader *)downloader
{
    
}

- (void)imageFiltrationDidFinish:(ImageFiltration *)filtration
{
    
}

@end
