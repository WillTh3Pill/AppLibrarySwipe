#import <UIKit/UIKit.h>

@interface SBHLibraryViewController : UIViewController
- (void)presentSearchAnimated:(BOOL)animated;
@end

@interface SBIconController : UIViewController
- (void)presentLibraryAnimated:(BOOL)animated completion:(id)completion;
@end

// This is the actual method used in iOS 16+
%hook SBSearchPresenter

- (void)presentSearchAnimated:(BOOL)animated {
    // Get the icon controller
    SBIconController *iconController = (SBIconController *)[%c(SBIconController) sharedInstance];
    
    // Present App Library instead of Spotlight
    if ([iconController respondsToSelector:@selector(presentLibraryAnimated:completion:)]) {
        [iconController presentLibraryAnimated:animated completion:nil];
    } else {
        // Fallback to original if method doesn't exist
        %orig;
    }
}

%end
