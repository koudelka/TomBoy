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

#import <AVFoundation/AVFoundation.h>
#import "TomBoyAppDelegate.h"
#import "IconButton.h"
#import "CategoryButton.h"

@interface IconViewController : UIViewController {

  NSString *directoryPath;
  NSMutableArray *iconButtons;
  NSMutableArray *categoryButtons;

}

@property (nonatomic, retain) NSString *directoryPath;
@property (nonatomic, retain) NSMutableArray *iconButtons;
@property (nonatomic, retain) NSMutableArray *categoryButtons;

- (IconButton *)createButtonForPath:(NSString *)path isCategory:(BOOL *)isCategory;
- (BOOL)amRootController;
- (UIViewController *)rootController;

- (void)popNavigationToHome:(id)sender;
- (void)prepareButtons;

@end
