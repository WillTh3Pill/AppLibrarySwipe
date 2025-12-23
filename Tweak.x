#import <UIKit/UIKit.h>

@interface SBIconController : UIViewController
- (void)presentLibraryAnimated:(BOOL)animated completion:(id)completion;
+ (id)sharedInstance;
@end

%hook SBSearchPresenter

- (void)presentSearchAnimated:(BOOL)animated {
    // Get icon controller and open App Library instead
    SBIconController *controller = [%c(SBIconController) sharedInstance];
    [controller presentLibraryAnimated:animated completion:nil];
}

%end
