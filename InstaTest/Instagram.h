//
//  Instagram.h
//  InstaTest
//
//  Created by Sean on 7/30/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instagram : NSObject

@property (nonatomic, copy) NSString *instagramID;
@property (nonatomic, copy) NSString *thumbPath;
@property (nonatomic, copy) NSString *regularPath;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, strong) NSDate *createdTime;

@end
