    //
//  mainViewController.m
//  backgroundMusic
//
//  Created by maliy on 7/15/10.
//  Copyright 2010 interMobile. All rights reserved.
//

#import "mainViewController.h"


@implementation mainViewController

#pragma mark lifeCycle

- (id) init
{
	if (self = [super init])
	{
		ipod = [MPMusicPlayerController iPodMusicPlayer];
		MPMediaQuery *mq = [MPMediaQuery songsQuery];
		titles = [[NSMutableArray alloc] initWithArray:mq.items];
	}
	return self;
}

- (void) dealloc
{
	[titles release];
	[super dealloc];
}

#pragma mark -
- (UIButton *) createImageButtonWithFrame:(CGRect) frame title:(NSString *) title
								bkgrImage:(UIImage *) bkgr bkgrImageH:(UIImage *) bkgrH
								   target:(id) target selector:(SEL) aSelector
{
	UIButton *rv = [[UIButton alloc] initWithFrame:frame];
	rv.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	rv.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	rv.backgroundColor = [UIColor clearColor];
	[rv setTitle:title forState:UIControlStateNormal];
	[rv addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
	
	[rv setBackgroundImage:bkgr forState:UIControlStateNormal];
	[rv setBackgroundImage:bkgrH forState:UIControlStateHighlighted];
	
	return rv;
}

- (void) checkPlayBtn
{
	if (ipod.playbackState == MPMusicPlaybackStatePlaying)
	{
		[playBtn setBackgroundImage:[UIImage imageNamed:@"stop.png"] forState:UIControlStateNormal];
	}
	else
	{
		[playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	}
}

#pragma mark -

- (void) playbackItemChanged:(id) nobject
{
	NSLog(@"%@", nobject);
}

- (void) playbackStateChanged:(id) nobject
{
	NSLog(@"%@", nobject);
	[self checkPlayBtn];
}

#pragma mark controll buttons events
- (void) rewingBtnPress:(UIButton *) btn
{
	[ipod skipToPreviousItem];
}

- (void) playBtnPress:(UIButton *) btn
{
	if (ipod.playbackState == MPMusicPlaybackStatePlaying)
	{
		[ipod pause];
	}
	else
	{
		[ipod play];
	}
	[self checkPlayBtn];
}

- (void) fforwardBtnPress:(UIButton *) btn
{
	[ipod skipToNextItem];
}


#pragma mark tableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSString *cellID = @"PLAYLIST_TABLE_CELL";
	UITableViewCell *rv = [tableView dequeueReusableCellWithIdentifier:cellID];
	if (!rv)
	{
		rv = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID] autorelease];
	}
	rv.textLabel.text = [[titles objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyTitle];
	return rv;
}

- (void) deselect:(UITableView *) tableView
{
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performSelector:@selector(deselect:) withObject:tableView afterDelay:0.5];

	[ipod setQueueWithItemCollection:
	 [MPMediaItemCollection collectionWithItems:
	  [NSArray arrayWithObject:
	   [titles objectAtIndex:indexPath.row]]]];
	[ipod play];
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger) section
{
	return NSLocalizedString(@"ipod songs", @"");
}


#pragma mark -

- (void) viewWillAppear:(BOOL)animated
{
	[self checkPlayBtn];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
	[super loadView];
	
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	
	UIView *contentView = [[UIView alloc] initWithFrame:screenRect];
	contentView.autoresizesSubviews = YES;
	contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	contentView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
	
	self.view = contentView;
	[contentView release];
	
	// create navigation view
	CGRect rct = self.navigationController.navigationBar.frame;
	rct.origin.y = 0.0;
	UIImageView *tmp_iv = [[UIImageView alloc] initWithFrame:rct];
	tmp_iv.image = [[UIImage imageNamed:@"glassWithBorder.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:2];
	tmp_iv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:tmp_iv];
	[tmp_iv release];

	UITableView *_tv = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
																	 self.view.bounds.origin.y+rct.size.height,
																	 self.view.bounds.size.width,
																	 self.view.bounds.size.height-2*rct.size.height)
													style:UITableViewStyleGrouped];
	_tv.delegate = self;
	_tv.dataSource = self;
	_tv.autoresizesSubviews = YES;
//	_tv.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_tv];
	[_tv release];
	
	CGFloat btnsWidth = rct.size.height-rct.size.height/3;	
	CGFloat tmp_fl = (self.view.bounds.size.width-btnsWidth*3)/4;
	rct = CGRectMake(tmp_fl, rct.size.height/6, btnsWidth, btnsWidth);
	rewindBtn = [self createImageButtonWithFrame:rct
										   title:nil
									   bkgrImage:[UIImage imageNamed:@"rewind.png"] bkgrImageH:nil
										  target:self selector:@selector(rewingBtnPress:)];
	[self.view addSubview:rewindBtn];
	
	rct.origin.x += tmp_fl+btnsWidth;
	playBtn = [self createImageButtonWithFrame:rct
										 title:nil
									 bkgrImage:nil bkgrImageH:nil
										target:self selector:@selector(playBtnPress:)];
	[self.view addSubview:playBtn];
	
	rct.origin.x += tmp_fl+btnsWidth;
	fforwardBtn = [self createImageButtonWithFrame:rct
											 title:nil
										 bkgrImage:[UIImage imageNamed:@"fforward.png"] bkgrImageH:nil
											target:self selector:@selector(fforwardBtnPress:)];
	[self.view addSubview:fforwardBtn];
	
	self.navigationItem.title = NSLocalizedString(@"iPod Access", @"");
	[self checkPlayBtn];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playbackItemChanged:)
												 name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
											   object:ipod];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(playbackStateChanged:)
												 name:MPMusicPlayerControllerPlaybackStateDidChangeNotification
											   object:ipod];
	[ipod beginGeneratingPlaybackNotifications];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
	[ipod endGeneratingPlaybackNotifications];
	
	[rewindBtn release];
	[playBtn release];
	[fforwardBtn release];
	
}



@end
