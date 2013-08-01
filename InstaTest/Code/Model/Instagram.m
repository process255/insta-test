//
//  Instagram.m
//  InstaTest
//
//  Created by Sean on 7/30/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "Instagram.h"
#import <RestKit/RestKit.h>

@implementation Instagram

//
// returns the likeCount as a string formatted with commas
//
// In production you should not instantiate a new NSNumberFormatter
// for each Instram object. Use one NSNumberFormatter object in
// production code!
//
- (NSString*)prettyLikeCount
{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter stringFromNumber:[NSNumber numberWithInteger:self.likeCount]];
}

//
// returns the instagram user's full name and like count as a string
//
- (NSString*)prettyTitle
{
    return [NSString stringWithFormat:@"%@: %@ likes", self.fullName, [self prettyLikeCount]];
}

//
// used by the RestKit response descriptor to map the response to Instagram model objects
//
+ (RKObjectMapping*)mapping
{
    // create the mapping object for our Instagram
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Instagram class]];
    
    // use KVC to map JSON properties to our Instagram object properties
    [mapping addAttributeMappingsFromDictionary:@{
	 @"id":									@"instagramID",
	 @"user.full_name":						@"fullName",
     @"likes.count":						@"likeCount",
	 @"caption.text":						@"caption",
	 @"images.thumbnail.url":				@"thumbPath",
	 @"images.standard_resolution.url":		@"regularPath"
	 }];
    
	return mapping;
}

@end
