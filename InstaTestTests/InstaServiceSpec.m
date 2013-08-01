//
//  InstaSericeSpec.m
//  InstaTest
//
//  Created by Sean Dougherty on 7/31/13.
//  Copyright (c) 2013 Sean Dougherty. All rights reserved.
//

#import "Kiwi.h"
#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "RKMappingTestMatcher.h"
#import "InstaTableViewController.h"
#import "OHHTTPStubs.h"
#import "InstaService.h"
#import "Instagram.h"

SPEC_BEGIN(InstaServiceSpec)

registerMatchers(@"RK");

describe(@"InstaService", ^{
       
    context(@"should load Instagram's popular photos", ^{
        
        __block OHHTTPStubsResponse *response;
        __block InstaService *service;
        __block RKMappingResult *result;
        __block Instagram *instagram;
        
        beforeAll(^{
            
            NSBundle *fixtureBundle = [NSBundle bundleWithIdentifier:@"com.seancdougherty.InstaTestTests"];
            [RKTestFixture setFixtureBundle:fixtureBundle];
            [RKTestFactory setUp];
            
            [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) { return YES; }
                                      withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) { return response; }];
            
            service = [[InstaService alloc] init];
			response = [OHHTTPStubsResponse responseWithFile:@"data.json"
												  statusCode:200
												responseTime:OHHTTPStubsDownloadSpeedWifi
													 headers:@{@"Content-Type" : @"application/json; charset=utf-8"}];
            
            
        });
        
        afterAll(^{
            
            service = nil;
            response = nil;
            [OHHTTPStubs removeAllRequestHandlers];
            [RKTestFactory tearDown];
            
        });
        
        beforeEach(^{
            
            [service loadPopularWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                instagram = mappingResult.array[0];
                result = mappingResult;
            } failure:nil];
            
        });
        
        it(@"should load 16 photos", ^{
            
            [[expectFutureValue([result array]) shouldEventually] haveCountOf:16];
            
		});
        
        it(@"should have a collection with the first photo belonging to GMY Studio", ^{
            
			[[expectFutureValue(instagram.fullName) shouldEventually] equal:@"GMY Studio"];
            
		});
        
    });
    
});


SPEC_END
