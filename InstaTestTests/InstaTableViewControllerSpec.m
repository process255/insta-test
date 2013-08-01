#import "Kiwi.h"

#import "InstaTableViewController.h"
#import "InstaService.h"
#import "Instagram.h"

#import <SVProgressHUD/SVProgressHUD.h>

//
// Private Class Extension for this test only
// allows us access to private properties for
// testing purposes, generally mirrors the actual
// private class extension found in the .m file
//
@interface InstaTableViewController ()
@property (nonatomic, copy) NSArray *instagrams;
@property (nonatomic, strong) InstaService *service;

- (void)loadPopular;
- (void)popularSuccess:(NSArray*)array;

@end

SPEC_BEGIN(InstaTableViewControllerSpec)


describe(@"InstaTableViewController Storyboard", ^{
    
    __block UIStoryboard* storyboard;
	__block InstaTableViewController* vc;
	
    beforeAll(^{
        
        storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
        vc = [storyboard instantiateViewControllerWithIdentifier:@"InstaTableViewController"];
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
        
        it(@"the tableView should exist", ^{
            
            [vc.tableView shouldNotBeNil];
            
        });
        
        it(@"the table view's dataSource should be this view controller", ^{
            
            [(id)vc.tableView.dataSource shouldNotBeNil];
            [[(id)vc.tableView.dataSource should] equal:vc];
            
        });

        it(@"the table view's delegate should be this view controller", ^{
            
            [(id)vc.tableView.delegate shouldNotBeNil];
            [[(id)vc.tableView.delegate should] equal:vc];
            
        });
        
    });
    
    context(@"-loadPopular", ^{
        
        __block InstaService *service;
        
        beforeEach(^{
            
            service = [KWMock mockForClass:[InstaService class]];
            
            // example of stubbing and partial mocking
            [vc stub:@selector(service) andReturn:service];
            
            // stub SVProgressHUD since we don't want it to actually execute
            [SVProgressHUD stub:@selector(show)];
            
        });
        
        it(@"should call loadPopularWithSuccess:failure: on it's service", ^{
            
            [[service should] receive:@selector(loadPopularWithSuccess:failure:)];
            [vc loadPopular];
            
        });
        
    });
    
    context(@"-popularSuccess:", ^{
        
        beforeEach(^{
            
            // stub SVProgressHUD since we don't want it to actually execute
            [SVProgressHUD stub:@selector(dismiss)];
            [vc.tableView stub:@selector(reloadData)];
            
        });
        
        it(@"should set the results to be instagrams on the view controller", ^{
            
            NSArray *results = @[@"lorem",@"ipsum"];
            [vc popularSuccess:results];
            [[vc.instagrams should] equal:results];
            
        });
        
    });
    
    context(@"-tableView:numberOfRowsInSection:", ^{
        
        
        it(@"should be 16", ^{
            
            [vc.instagrams stub:@selector(count) andReturn:theValue(16)];
            
            [[theValue([vc tableView:nil numberOfRowsInSection:0]) should] equal:theValue(16)];
            
        });
        
    });
    
    context(@"-tableView:cellForRowAtIndexPath:", ^{
        
        beforeEach(^{
            
            Instagram *instagram = [[Instagram alloc] init];
            instagram.thumbPath = @"thumb path";
            instagram.prettyTitle = @"pretty title";
            
            [vc stub:@selector(instagrams) andReturn:@[instagram]];
            
        });
        
        it(@"should return a valid cell", ^{
            
            UITableViewCell *cell = [vc tableView:vc.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell shouldNotBeNil];
            
        });
        
    });
});



SPEC_END