/*
  Copyright 2010 Michael Shapiro. All rights reserved.

  This file is part of TomBoy.

  TomBoy is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  TomBoy is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with TomBoy.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "IconViewController.h"

static NSString *CategoryImageName = @"_category.png";

@implementation IconViewController

@synthesize directoryPath;
@synthesize iconButtons;
@synthesize categoryButtons;

- (IconButton *)createButtonForPath:(NSString *)path isCategory:(BOOL *)isCategory {
    TomBoyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSString *fullItemPath = [[appDelegate rootIconsDirectory] stringByAppendingString:path];

    [[appDelegate fileManager] fileExistsAtPath:fullItemPath isDirectory:isCategory];

    NSString *imagePath = (*isCategory ? [NSString stringWithFormat:@"%@/%@", fullItemPath, CategoryImageName] : fullItemPath);

    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

    IconButton *button;

    if (*isCategory) {
      button = [CategoryButton buttonWithType:UIButtonTypeCustom];
      /* setDirectoryPath also sets a category's sound path, since it's a known file name */
      [(CategoryButton *)button setDirectoryPath:[path stringByAppendingString:@"/"]];
      [(CategoryButton *)button setContainerViewController:self];
    } else {
      button = [IconButton buttonWithType:UIButtonTypeCustom];
      [button setSoundPath:[[path stringByDeletingPathExtension] stringByAppendingPathExtension:@"caf"]];
    }

    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button addTarget:button action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
  
    return button;
}

- (void)prepareButtons {
  DEBUGLOG(@"preparing %@", self.title);
  iconButtons = [[NSMutableArray alloc] init];
  categoryButtons = [[NSMutableArray alloc] init];

  TomBoyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  NSFileManager *manager = [appDelegate fileManager];
  NSString *iconDirPath = [[appDelegate rootIconsDirectory] stringByAppendingString:directoryPath];
  NSArray *iconDirItems = [manager contentsOfDirectoryAtPath:iconDirPath error:NULL];

  for (NSString *item in iconDirItems) {
    if ([item isEqualToString:CategoryImageName])
      continue;

    BOOL isCategory;
    IconButton *button = [self createButtonForPath:[directoryPath stringByAppendingString:item] isCategory:&isCategory];
    [button loadSoundPlayer];

    if (isCategory)
      [categoryButtons addObject:button];
    else
      [iconButtons addObject:button];
  }

}

- (void)viewDidLoad {
  [super viewDidLoad];
  DEBUGLOG(@"loaded: %@", self.title);

  if ([self amRootController]) {
    directoryPath = @"/";
    self.title = @"Home";
    [self.navigationController setNavigationBarHidden:YES
                                             animated:NO];
  }

  /* we're either the root controller, or our buttons were dumped due to low memory, regenerate */
  if (iconButtons == nil)
    [self prepareButtons];
  
  [self.navigationItem setRightBarButtonItem:[self rootController].navigationItem.rightBarButtonItem
                                    animated:YES];

  /* move to applicationDidFinishLaunching? */
  [self rootController].navigationItem.rightBarButtonItem.target = self;
  [self rootController].navigationItem.rightBarButtonItem.action = @selector(popNavigationToHome:);

  CGRect screenSize = [UIScreen mainScreen].bounds;

  int iconsPerRow = [[NSUserDefaults standardUserDefaults] integerForKey:TomBoyIconsPerRowKey];

  /* lay out buttons */
  NSArray *buttons = [categoryButtons arrayByAddingObjectsFromArray:iconButtons];

  int iconsInRow = iconsPerRow;
  int rowNum = -1;
  for (UIButton *button in buttons) {
    
    if (iconsInRow == iconsPerRow) {
      iconsInRow = 0;
      rowNum++;
    }

    UIImage *backgroundImage = [button backgroundImageForState:UIControlStateNormal];

    button.frame = CGRectMake(SCREEN_MARGIN + (backgroundImage.size.width  + GRID_WIDTH) * iconsInRow,
                              SCREEN_MARGIN + (backgroundImage.size.height + GRID_WIDTH) * rowNum,
                              backgroundImage.size.width,
                              backgroundImage.size.height);

    [self.view addSubview:button];

    iconsInRow++;
  }

  int icon_height = [[buttons objectAtIndex:0] frame].size.height;
  [(UIScrollView *)self.view setContentSize:CGSizeMake(screenSize.size.width,
                                                       (SCREEN_MARGIN * 2) + (icon_height + GRID_WIDTH) * (rowNum + 1) ) ];

  /*
   * eliminates the delay between first button touch and sound play.
   * fairly sure this works by initializing the sound system ahead of time 
   */ 
  if ([self amRootController]) {
    AVAudioPlayer *firstPlayer = [[buttons objectAtIndex:0] soundPlayer];
    if (firstPlayer != nil)
      [firstPlayer prepareToPlay]; 
  }

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)popNavigationToHome:(id)sender {
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (BOOL)amRootController {
  return self == [self rootController];
}

- (UIViewController *)rootController {
  return [self.navigationController.viewControllers objectAtIndex:0];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.navigationController setNavigationBarHidden:[self amRootController]
                             animated:YES];

  //[self.navigationController setToolbarHidden:![self amRootController]
  //                           animated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  /* when we appear, prepare all child category views in anticipation of a click */
  for (CategoryButton *button in categoryButtons) {
    if (button.viewController == nil) {
      IconViewController *controller = [[IconViewController alloc] initWithNibName:@"IconViewController" bundle:nil];

      controller.directoryPath = [button directoryPath];
      controller.title = [[[button directoryPath] lastPathComponent] capitalizedString];
      [controller prepareButtons];
      button.viewController = controller;

      [controller release];
    }
  }
}

/*
- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations.
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  DEBUGLOG(@"low mem: %@", self.title);
 
  /* release all of our buttons */
  [iconButtons release];
  iconButtons = nil;
  [categoryButtons release];
  categoryButtons = nil;

  //[self.view release];
}

- (void)dealloc {
  [iconButtons release];
  [categoryButtons release];
  [directoryPath release];
  [super dealloc];
}


@end

