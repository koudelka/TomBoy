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

#import "IconButton.h"


@implementation IconButton

@synthesize soundPath;
@synthesize soundPlayer;

- (void)loadSoundPlayer {
  TomBoyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
  NSString *fullSoundPath = [[appDelegate rootSoundsDirectory] stringByAppendingString:soundPath];

  NSURL *url = [NSURL fileURLWithPath:fullSoundPath isDirectory:NO];
  NSError *error;

  soundPlayer = [AVAudioPlayer alloc];
  AVAudioPlayer *_soundPlayer = [soundPlayer initWithContentsOfURL:url error:&error];

  if (_soundPlayer != nil)
    _soundPlayer.numberOfLoops = 0;
  else
    [soundPlayer release];

  soundPlayer = _soundPlayer;

}

- (void)touchDown:(id)sender {
  if (soundPlayer != nil)
    [soundPlayer play];
  
}

- (void)dealloc {
  [soundPath release];
  if (soundPlayer != nil)
    [soundPlayer release];
  [super dealloc];
}

@end
