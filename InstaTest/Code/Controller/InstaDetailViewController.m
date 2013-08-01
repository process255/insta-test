//
//  InstaDetailViewController.m
//  UIViewController displaying a single Instagram photo.
//
//  Created by Sean on 7/30/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "InstaDetailViewController.h"
#import "Instagram.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface InstaDetailViewController ()
- (void)configureView;
@end

@implementation InstaDetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureView];
}


//
// load and display an Instagram photo
//
- (void)configureView
{
	if (self.instagram)
	{
        // show a loader
        [SVProgressHUD show];
        
        // set the photo's caption ad the title
		self.title = self.instagram.caption;
        
        // use SDWebImage to asynchronously load and set the instagram image
        [self.pic setImageWithURL:[NSURL URLWithString:self.instagram.regularPath]
                 placeholderImage:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                            
                            // hide the loader
                            [SVProgressHUD dismiss];
                            
                        }];
	}
}

//
// Override the setter for the instagram property
// set it and configure the view to display the new data
//
- (void)setInstagram:(Instagram *)instagram
{
    if (_instagram != instagram)
	{
        _instagram = instagram;        
        [self configureView];
    }
}

@end
