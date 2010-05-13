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

#import "TomBoyAppDelegate.h"
#import "IconViewController.h"

static NSString *RootIconsDirName  = @"icons";
static NSString *RootSoundsDirName = @"sounds";
static NSString *OrigIconsDirName = @"/icons_orig/";

@implementation TomBoyAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize rootIconsDirectory;
@synthesize rootSoundsDirectory;
@synthesize fileManager;


+ (void)initialize {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:TomBoyIconsPerRowKey] == nil)
    [[NSUserDefaults standardUserDefaults] setInteger:4
                                               forKey:TomBoyIconsPerRowKey];
}


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    

  rootIconsDirectory = [NSString stringWithFormat:@"%@/%@/%d",
                                                 [[NSBundle mainBundle] resourcePath],
                                                 RootIconsDirName,
                                                 [[NSUserDefaults standardUserDefaults] integerForKey:TomBoyIconsPerRowKey]];
  [rootIconsDirectory retain];

  rootSoundsDirectory = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], RootSoundsDirName];
  [rootSoundsDirectory retain];

  fileManager = [[NSFileManager alloc] init];
  

 // NSLog(@"%@", rootIconsDirectory);
  [TomBoyAppDelegate generateThumbnailsForDirectory:[[[NSBundle mainBundle] resourcePath] stringByAppendingString:OrigIconsDirName]];
  [window addSubview:[navigationController view]];
  [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
  [rootIconsDirectory release];
  [fileManager release];
  [navigationController release];
  [window release];
  [super dealloc];
}

#pragma mark -
#pragma mark Icon generation

/* This is a function to take a directory hierarchy of icons and generate ahead-of-time thumbnails
 *
 * Obviously, run this in the simulator, not on the phone. 
 * */
+ (void)generateThumbnailsForDirectory:(NSString *)directoryPath {
  NSFileManager *manager = [[NSFileManager alloc] init];


  NSArray *dirItems = [manager contentsOfDirectoryAtPath:directoryPath
                                                   error:NULL];

  for (NSString *item in dirItems) {

    NSString *itemPath = [directoryPath stringByAppendingString:item];
    NSLog(@"%@", itemPath);

    BOOL isDir;
    [manager fileExistsAtPath:itemPath isDirectory:&isDir];

    if (isDir)
      [self generateThumbnailsForDirectory:[itemPath stringByAppendingString:@"/"]];
    else {
      CGRect screenSize = [UIScreen mainScreen].bounds;

      NSString *rsrcPath = [[NSBundle mainBundle] resourcePath];
      NSString *relativePath = [itemPath stringByReplacingCharactersInRange:NSMakeRange(0, [rsrcPath length] + [OrigIconsDirName length])
                                                                 withString:@""];
      for(int i = 1 ; i <= 4 ; i++) {
        NSString *thumbnailPath = [NSString stringWithFormat:@"%@/icons/%d/%@",
                                                             rsrcPath,
                                                             i,
                                                             relativePath];
        [manager createDirectoryAtPath:[thumbnailPath stringByDeletingLastPathComponent]
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];

        float iconSize = (screenSize.size.width - 2*SCREEN_MARGIN - (GRID_WIDTH * (i-1))) / (float)i;
        UIImage *image = [UIImage imageWithContentsOfFile:itemPath];
        CALayer *layer = [CALayer layer];
        layer.contents = (id)image.CGImage;
        layer.frame = CGRectMake(0, 0, iconSize, iconSize);

        UIGraphicsBeginImageContext(CGSizeMake(iconSize, iconSize));
        [layer setBorderColor:[[UIColor blackColor] CGColor]];
        [layer setCornerRadius:8.0f];
        [layer setMasksToBounds:YES];
        [layer setBorderWidth:ICON_BORDER];
        [layer renderInContext:UIGraphicsGetCurrentContext()];

        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
      
        [UIImagePNGRepresentation(newImage) writeToFile:thumbnailPath atomically:YES];
        
        NSLog(@"%@", thumbnailPath);
      }
    }
  }

  [manager release];
}

@end

