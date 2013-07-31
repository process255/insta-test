//
//  InstaTableViewController.m
//  InstaTest
//
//  Created by Sean on 7/30/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "InstaTableViewController.h"
#import "InstaDetailViewController.h"
#import <RestKit/RestKit.h>
#import "Instagram.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

#define kInstagramPopularURL @"https://api.instagram.com/v1/media/popular?client_id=40e75f2f1cf14261957f652849fc4ce5"


@interface InstaTableViewController ()
{
    NSArray *_objects;
}
@end

@implementation InstaTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self loadPopular];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

	Instagram *instagram = _objects[indexPath.row];
	UIImageView *thumb = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
	[thumb setImageWithURL:[NSURL URLWithString:instagram.thumbPath] placeholderImage:nil];
	cell.accessoryView = thumb;
	cell.textLabel.text = instagram.caption;
	
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
	{
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Instagram *instagram = _objects[indexPath.row];
        [[segue destinationViewController] setInstagram:instagram];
    }
}

#pragma mark - Data Loading

- (void)loadPopular
{
	[SVProgressHUD show];
	
	RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[self mapping]
																							method:RKRequestMethodAny
																					   pathPattern:nil
																						   keyPath:@"data"
																					   statusCodes:nil];
	
	NSURL *url = [NSURL URLWithString:kInstagramPopularURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request
																		responseDescriptors:@[responseDescriptor]];
	
	[operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
		[SVProgressHUD dismiss];
		_objects = result.array;
		[self.tableView reloadData];
	} failure:nil];
	
	[operation start];
}

- (RKObjectMapping*)mapping
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Instagram class]];
	[mapping addAttributeMappingsFromDictionary:@{
	 @"id":									@"instagramID",
	 @"created_time":						@"createdTime",
	 @"caption.text":						@"caption",
	 @"images.thumbnail.url":				@"thumbPath",
	 @"images.standard_resolution.url":		@"regularPath"
	 }];
	return mapping;
}

@end
