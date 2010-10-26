//
//  backgroundMusicAppDelegate.h
//  backgroundMusic
//
//  Created by maliy on 7/15/10.
//  Copyright interMobile 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface backgroundMusicAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

