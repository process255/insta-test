//
//  InstaDetailViewController.m
//  InstaTest
//
//  Created by Sean on 7/30/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "InstaDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Instagram.h"

@interface InstaDetailViewController ()
- (void)configureView;
@end

@implementation InstaDetailViewController

#pragma mark - Managing the detail item

- (void)setInstagram:(Instagram *)instagram
{
    if (_instagram != instagram)
	{
        _instagram = instagram;
        
        [self configureView];
    }
}

- (void)configureView
{
	if (self.instagram)
	{
		self.title = self.instagram.caption;
		[self.pic setImageWithURL:[NSURL URLWithString:self.instagram.regularPath] placeholderImage:nil];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureView];
}

@end
