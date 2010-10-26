//
//  mainViewController.h
//  backgroundMusic
//
//  Created by maliy on 7/15/10.
//  Copyright 2010 interMobile. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface mainViewController : UIViewController <AVAudioPlayerDelegate, 
									UITableViewDelegate, UITableViewDataSource>
{
	MPMusicPlayerController *ipod;

	UIButton *rewindBtn;
	UIButton *playBtn;
	UIButton *fforwardBtn;
	
	NSMutableArray *titles;
	
}

@end
