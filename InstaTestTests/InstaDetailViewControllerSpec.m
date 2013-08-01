#import "Kiwi.h"

#import "InstaDetailViewController.h"
#import "Instagram.h"

#import <SVProgressHUD/SVProgressHUD.h>

//
// Private Class Extension for this test only
// allows us access to private properties for
// testing purposes, generally mirrors the actual
// private class extension found in the .m file
//
@interface InstaDetailViewController ()

- (void)configureView;

@end

SPEC_BEGIN(InstaDetailViewControllerSpec)


describe(@"InstaDetailViewController Storyboard", ^{
    
    __block UIStoryboard* storyboard;
	__block InstaDetailViewController* vc;
	
    beforeAll(^{
        
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        vc = [storyboard instantiateViewControllerWithIdentifier:@"InstaDetailViewController"];
        [vc loadView];
        
    });
    
    afterAll(^{
        
        storyboard = nil;
        vc = nil;
        
    });
    
    context(@"should properly bind IBOutlets, IBActions", ^{
        
        it(@"the controller should exist", ^{
            
            [vc shouldNotBeNil];
            
        });
        
        it(@"the view should exist", ^{
            
            [vc.view shouldNotBeNil];
            
        });
        
        it(@"the pic should exist", ^{
            
            [vc.pic shouldNotBeNil];
            
        });
        
    });
    
    context(@"setInstagram:", ^{
        
        beforeEach(^{
            
            [vc stub:@selector(configureView)];
            
        });
        
        it(@"should call configureView after storing the new Instagram Object", ^{
            
            [[vc should] receive:@selector(configureView)];
            
            [vc setInstagram:[[Instagram alloc] init]];
            
        });
        
        it(@"should not assign the same instagram object twice in row", ^{
            
            Instagram *instagram = [[Instagram alloc] init];
            
            [[vc should] receive:@selector(configureView)];
            [vc setInstagram:instagram];
            [[vc shouldNot] receive:@selector(configureView)];
            [vc setInstagram:instagram];
            
        });
        
    });
    
    context(@"configureView", ^{
        
        beforeEach(^{
            
            [SVProgressHUD stub:@selector(show)];
            Instagram *instagram = [[Instagram alloc] init];
            instagram.thumbPath = @"thumb path";
            instagram.prettyTitle = @"pretty title";
            instagram.caption = @"My Caption";
            
            [vc stub:@selector(instagram) andReturn:instagram];
            
        });
        
        it(@"should set the title to the instagram caption", ^{
            
            [vc configureView];
            [[vc.title should] equal:@"My Caption"];
            
        });
        
        it(@"should set set the image on the pic", ^{
            
            [[vc.pic should] receive:@selector(setImageWithURL:placeholderImage:completed:)];
            [vc configureView];
            
        });
        
    });
    
});


SPEC_END
