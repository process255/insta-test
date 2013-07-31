//
//  InstaDetailViewController.h
//  InstaTest
//
//  Created by Sean on 7/30/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Instagram;

@interface InstaDetailViewController : UIViewController

@property (nonatomic, strong) Instagram *instagram;
@property (nonatomic, weak) IBOutlet UIImageView *pic;
@end
