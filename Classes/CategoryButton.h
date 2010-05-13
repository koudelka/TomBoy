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

#import <Foundation/Foundation.h>
#import "IconButton.h"


@interface CategoryButton : IconButton {

  NSString *directoryPath;
  UIViewController *containerViewController;
  UIViewController *viewController;

}

@property (nonatomic, retain) NSString *directoryPath;
@property (nonatomic, retain) UIViewController *containerViewController;
@property (nonatomic, retain) UIViewController *viewController;

- (void)touchDown:(id)sender;

@end
