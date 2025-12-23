#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

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
    NSLog(@"[AppLibrarySwipe] presentSpotlightAnimated called!");
    
    // Don't call original - we're replacing Spotlight with App Library
    // %orig;
    
    // Present App Library instead
    NSLog(@"[AppLibrarySwipe] Attempting to present App Library");
    [self presentLibraryForIconManager:[self iconManager] animated:animated completion:^{
        NSLog(@"[AppLibrarySwipe] App Library presented, attempting to show search");
        // After App Library is presented, open search
        dispatch_async(dispatch_get_main_queue(), ^{
            // Get the library view controller and trigger search
            SBHLibraryViewController *libraryVC = (SBHLibraryViewController *)[self valueForKey:@"_iconManager"];
            if (libraryVC && [libraryVC respondsToSelector:@selector(presentSearchAnimated:)]) {
                NSLog(@"[AppLibrarySwipe] Presenting search");
                [libraryVC presentSearchAnimated:YES];
            } else {
                NSLog(@"[AppLibrarySwipe] Could not present search");
            }
        });
    }];
}

%end

// Hook to ensure search opens automatically when App Library appears
%hook SBHLibraryViewController

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"[AppLibrarySwipe] Library view appeared");
    %orig;
    
    // Small delay to ensure view is fully loaded
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self respondsToSelector:@selector(presentSearchAnimated:)]) {
            NSLog(@"[AppLibrarySwipe] Auto-presenting search");
            [self presentSearchAnimated:NO];
        } else if ([self respondsToSelector:@selector(_presentSearch)]) {
            NSLog(@"[AppLibrarySwipe] Auto-presenting search (alternate method)");
            [self _presentSearch];
        }
    });
}

%end

// Alternative hook for pod folder controller (used in some iOS 16 versions)
%hook SBHLibraryPodFolderController

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"[AppLibrarySwipe] Pod folder appeared");
    %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self respondsToSelector:@selector(presentSearchAnimated:)]) {
            NSLog(@"[AppLibrarySwipe] Pod folder auto-presenting search");
            [self presentSearchAnimated:NO];
        }
    });
}

%end
