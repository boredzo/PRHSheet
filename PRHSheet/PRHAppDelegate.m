//
//  PRHAppDelegate.m
//  PRHSheet
//
//  Created by Peter Hosey on 2011-12-20.
//

#import "PRHAppDelegate.h"

#import "PRHSheet.h"

@implementation PRHAppDelegate

@synthesize window = _window;
@synthesize sheet = _sheet;

- (IBAction)runSheet:(id)sender {
	[self.sheet beginOnWindow:self.window completionHandler:^(NSInteger returnCode) {
		NSLog(@"Sheet ended with return code: %@", PRHSheetDebugStringForReturnCode(returnCode));
	}];
}

@end
