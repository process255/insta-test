//
//  InstaTableViewController.m
//  UITableViewController displaying list of the most popular Instagram photos.
//
//  Created by Sean on 7/30/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "InstaTableViewController.h"
#import "InstaDetailViewController.h"
#import "Instagram.h"
#import "InstaService.h"

#import <RestKit/RestKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>




@interface InstaTableViewController ()

// storage collection for loaded Instagram objects
// Use private properties instead iVars as private
// properties can be tested, iVars cannot be tested directly.
@property (nonatomic, copy) NSArray *instagrams;
@property (nonatomic, strong) InstaService *service;
@end

@implementation InstaTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // load the popular instagram photos from the Instagram API
	[self loadPopular];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return self.instagrams.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // dequeue a cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // grab loaded Instagram model object from the collection
	Instagram *instagram = self.instagrams[indexPath.row];
    
    // create a UIImageView to set as our accessory view
	UIImageView *thumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    
    // use SDWebImage to asynchronously load and set the instagram thumbnail image
	[thumb setImageWithURL:[NSURL URLWithString:instagram.thumbPath] placeholderImage:nil];
    
    // assign the UIImageView as the cell's accessory view
	cell.accessoryView = thumb;
    
    // assign the text label's text using our helper property 'prettyTitle' on Instagram
	cell.textLabel.text = instagram.prettyTitle;
	
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
	{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // grab the corresponding Instagram object for this row
        Instagram *instagram = self.instagrams[indexPath.row];
        
        // set it on our detail controller
        [[segue destinationViewController] setInstagram:instagram];
    }
}

#pragma mark - Data Loading


//
// load popular instagram photos
//
- (void)loadPopular
{
    
    // show a loader
	[SVProgressHUD show];

    // load the popular feed from Instagram's API
    [self.service loadPopularWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [self popularSuccess:mappingResult.array];
    } failure:nil];
   
}

//
// successfully loaded popular instagram photos
//
- (void)popularSuccess:(NSArray*)array
{
    // hide the loader
    [SVProgressHUD dismiss];
    
    // store the loaded instagram objects
    self.instagrams = array;
    
    // reload the table so we can see them
    [self.tableView reloadData];
}

#pragma mark - Getters/Setters


//
// Lazy instantiate the InstaService the first time it is called
//
- (InstaService*)service
{
    if (_service == nil)
    {
         _service = [[InstaService alloc] init];
    }
    return _service;
}

@end
