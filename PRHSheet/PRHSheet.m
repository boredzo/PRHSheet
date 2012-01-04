//
//  PRHSheet.m
//  PRHSheet
//
//  Created by Peter Hosey on 2011-12-20.
//

#import "PRHSheet.h"

@interface PRHSheet ()
- (void) sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
@end
@implementation PRHSheet

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
	aStyle &= ~((NSUInteger)NSTitledWindowMask|(NSUInteger)NSMiniaturizableWindowMask);
	aStyle |= (NSUInteger)NSClosableWindowMask;
	return [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen];
}

- (BOOL) canBecomeKeyWindow {
	return YES;
}

#pragma mark -

- (void) beginOnWindow:(NSWindow *)window completionHandler:(PRHSheetCompletionHandler)handler {
	[NSApp beginSheet:self modalForWindow:window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:(__bridge_retained void *)handler];
}

- (void) end {
	[NSApp endSheet:self];
}

- (void) endWithReturnCode:(NSInteger)returnCode {
	[NSApp endSheet:self returnCode:returnCode];
}

- (void) sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	PRHSheetCompletionHandler handler = (__bridge_transfer PRHSheetCompletionHandler)contextInfo;

	if (handler)
		handler(returnCode);

	[self orderOut:nil];
}

#pragma mark Actions

- (IBAction) ok:(id)sender {
	[self endWithReturnCode:NSOKButton];
}
- (IBAction) cancel:(id)sender {
	[self endWithReturnCode:NSCancelButton];
}

@end

NSString *PRHSheetStringForReturnCodeWithDefault(NSInteger returnCode, NSString *defaultString) {
	switch (returnCode) {
		case NSOKButton:
			return @"OK";

		case NSCancelButton:
			return @"Cancel";
			
		default:
			return defaultString;
	}
}
NSString *PRHSheetStringForReturnCode(NSInteger returnCode) {
	return PRHSheetStringForReturnCodeWithDefault(returnCode, nil);
}
NSString *PRHSheetDebugStringForReturnCode(NSInteger returnCode) {
	return PRHSheetStringForReturnCodeWithDefault(returnCode, @"???");
}
