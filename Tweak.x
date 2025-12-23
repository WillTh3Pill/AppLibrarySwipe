@interface SBIconController : UIViewController
- (void)presentSpotlightAnimated:(BOOL)animated;
- (void)dismissSpotlightAnimated:(BOOL)animated completionHandler:(id)completion;
- (void)presentLibraryForIconManager:(id)manager animated:(BOOL)animated completion:(id)completion;
- (id)iconManager;
@end

@interface SBHLibraryViewController : UIViewController
- (void)presentSearchAnimated:(BOOL)animated;
- (void)_presentSearch;
@end

@interface SBHLibraryPodFolderController : UIViewController
- (void)presentSearchAnimated:(BOOL)animated;
@end

@interface SBRootFolderController : UIViewController
@property (nonatomic, retain) id iconManager;
@end

// Hook into SBIconController to intercept the swipe down gesture
%hook SBIconController

// This is called when swiping down on home screen for Spotlight
- (void)presentSpotlightAnimated:(BOOL)animated {
    // Don't call original - we're replacing Spotlight with App Library
    // %orig;
    
    // Present App Library instead
    [self presentLibraryForIconManager:[self iconManager] animated:animated completion:^{
        // After App Library is presented, open search
        dispatch_async(dispatch_get_main_queue(), ^{
            // Get the library view controller and trigger search
            SBHLibraryViewController *libraryVC = (SBHLibraryViewController *)[self _iconManager].libraryViewController;
            if (libraryVC && [libraryVC respondsToSelector:@selector(presentSearchAnimated:)]) {
                [libraryVC presentSearchAnimated:YES];
            }
        });
    }];
}

%end

// Hook to ensure search opens automatically when App Library appears
%hook SBHLibraryViewController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    // Small delay to ensure view is fully loaded
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self respondsToSelector:@selector(presentSearchAnimated:)]) {
            [self presentSearchAnimated:NO];
        } else if ([self respondsToSelector:@selector(_presentSearch)]) {
            [self _presentSearch];
        }
    });
}

%end

// Alternative hook for pod folder controller (used in some iOS 16 versions)
%hook SBHLibraryPodFolderController

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self respondsToSelector:@selector(presentSearchAnimated:)]) {
            [self presentSearchAnimated:NO];
        }
    });
}

%end
