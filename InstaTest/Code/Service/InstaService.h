//
//  InstaService.h
//  InstaTest
//
//  Created by Sean Dougherty on 7/31/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectRequestOperation, RKMappingResult;

@interface InstaService : NSObject

//
// load popular instagram photos
//
- (void)loadPopularWithSuccess:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
                       failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
