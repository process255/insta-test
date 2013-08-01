//
//  InstaService.m
//  InstaTest
//
//  Created by Sean Dougherty on 7/31/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "InstaService.h"
#import <RestKit/RestKit.h>
#import "Instagram.h"

#define kInstagramPopularURL @"https://api.instagram.com/v1/media/popular?client_id=40e75f2f1cf14261957f652849fc4ce5"

@implementation InstaService

//
// load popular instagram photos
//
- (void)loadPopularWithSuccess:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                       failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure
{
    // RestKit response descriptors are use to map a response to a mapping used for creating custom model objects
	RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:[Instagram mapping]
                                                 method:RKRequestMethodAny
                                            pathPattern:nil
                                                keyPath:@"data"
                                            statusCodes:nil];
	
    // create a url and request object
	NSURL *url = [NSURL URLWithString:kInstagramPopularURL];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
    // RestKit's network operations are sub classes NSOperation which is used by AFNetworking under the hood
    // RKObjectRequestOperation is used for non-core data RestKit requests, we create one with the request and
    // response descriptor created above.
	RKObjectRequestOperation *operation =
    [[RKObjectRequestOperation alloc] initWithRequest:request
                                  responseDescriptors:@[responseDescriptor]];
	
    // set the completion block for a successful response. In production you'll want to provide
    // failure handling. It is much easier to test blocks if you have them call single methods
    // rather than executing lots of code in the block directly.
	[operation setCompletionBlockWithSuccess:success failure:failure];
	
    // start the operation so that it executes
	[operation start];
}

@end
