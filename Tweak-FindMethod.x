#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook SBSearchPresenter

- (void)presentSearchWithContext:(id)context animated:(BOOL)animated {
    NSLog(@"[AppLibrarySwipe] SBSearchPresenter presentSearchWithContext");
    // Block Spotlight - don't call %orig
}

%end

%hook SBHomeScreenController  

- (void)presentSearchWithContext:(id)context animated:(BOOL)animated {
    NSLog(@"[AppLibrarySwipe] SBHomeScreenController presentSearch");
    // Block Spotlight
}

%end

%hook SBHSearchPresenting

- (void)presentSearchWithContext:(id)context animated:(BOOL)animated {
    NSLog(@"[AppLibrarySwipe] SBHSearchPresenting presentSearch");
    // Block Spotlight
}

%end

%hook SBIconController

- (void)_handleShortcutMenuPeek:(id)arg1 {
    %orig;
}

%end
