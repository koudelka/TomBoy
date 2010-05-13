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

#import <QuartzCore/QuartzCore.h>

/* if you change any of these settings, you'll need to regenerate the icons */
#define SCREEN_MARGIN 4
#define GRID_WIDTH 4
#define ICON_BORDER 1

#ifdef DEBUG
#define DEBUGLOG(...) NSLog(__VA_ARGS__)
#else
#define DEBUGLOG(...) ((void)0)
#endif

static NSString *TomBoyIconsPerRowKey = @"TomBoyIconsPerRowKey";

@interface TomBoyAppDelegate : NSObject <UIApplicationDelegate> {
    
  UIWindow *window;
  UINavigationController *navigationController;

  NSString *rootIconsDirectory;
  NSString *rootSoundsDirectory;
  NSFileManager *fileManager;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain, readonly) NSString *rootIconsDirectory;
@property (nonatomic, retain, readonly) NSString *rootSoundsDirectory;
@property (nonatomic, retain, readonly) NSFileManager *fileManager;


+ (void)generateThumbnailsForDirectory:(NSString *)directoryPath;

@end

