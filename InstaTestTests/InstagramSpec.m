#import "Kiwi.h"

#import "InstaTableViewController.h"
#import "InstaService.h"
#import "Instagram.h"

#import <RestKit/RestKit.h>
#import <RestKit/Testing.h>
#import "RKMappingTestMatcher.h"

//
// Private Class Extension for this test only
// allows us access to private properties for
// testing purposes, generally mirrors the actual
// private class extension found in the .m file
//
@interface Instagram()
- (NSString*)prettyLikeCount;
@end

SPEC_BEGIN(InstagramSpec)

registerMatchers(@"RK");

describe(@"Instagram", ^{
    
	__block Instagram* instagram;
    
    beforeAll(^{
        
        instagram = [[Instagram alloc] init];
        instagram.fullName = @"Sean Dougherty";
        instagram.likeCount = 1000000;
        
        [RKTestFactory setUp];
    });
    
    afterAll(^{
        
        instagram = nil;
        [RKTestFactory tearDown];
        
    });
    
    context(@"should properly map objects", ^{
        
        __block RKTestFixture *fixtureData;
		__block RKMappingTest *mappingTest;
		
		beforeEach(^{
			fixtureData = [RKTestFixture parsedObjectWithContentsOfFixture:@"instagram.json"];
			mappingTest = [RKMappingTest testForMapping:[Instagram mapping] sourceObject:fixtureData destinationObject:nil];
		});
		
		afterEach(^{
			fixtureData = nil;
			mappingTest = nil;
		});
		
		// Attributes
		specify(^{ [[mappingTest should] mapKeyPath:@"id" toKeyPath:@"instagramID" withValue:@"512214900429776080_5619568"];
        });
		specify(^{ [[mappingTest should] mapKeyPath:@"user.full_name" toKeyPath:@"fullName" withValue:@"GMY Studio"]; });
		specify(^{ [[mappingTest should] mapKeyPath:@"likes.count" toKeyPath:@"likeCount" withValue:@9081]; });
        specify(^{ [[mappingTest should] mapKeyPath:@"caption.text" toKeyPath:@"caption" withValue:@"Last weekend"]; });
        specify(^{ [[mappingTest should] mapKeyPath:@"images.thumbnail.url" toKeyPath:@"thumbPath" withValue:@"http://thumb.jpg"]; });
        specify(^{ [[mappingTest should] mapKeyPath:@"images.standard_resolution.url" toKeyPath:@"regularPath" withValue:@"http://reg.jpg"]; });
        
    });
    
    context(@"-prettyLikeCount", ^{
        
        it(@"should return '1,000,000'", ^{
            
            [[[instagram prettyLikeCount] should] equal:@"1,000,000"];
            
        });
        
    });
    
    context(@"-prettyTitle", ^{
        
        it(@"should return 'Sean Dougherty: 1,000,000 likes", ^{
            
            [[instagram.prettyTitle should] equal:@"Sean Dougherty: 1,000,000 likes"];
            
        });
    });

});


SPEC_END