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
{
	NSMapTable *parentWindowsToCompletionHandlers;
}

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
	aStyle &= ~(NSTitledWindowMask|NSMiniaturizableWindowMask);
	aStyle |= NSClosableWindowMask;
	if ((self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag screen:screen])) {
		parentWindowsToCompletionHandlers = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:1UL];
	}
	return self;
}

- (BOOL) canBecomeKeyWindow {
	return YES;
}

#pragma mark -

- (void) beginOnWindow:(NSWindow *)window completionHandler:(PRHSheetCompletionHandler)handler {
	if (handler)
		[self->parentWindowsToCompletionHandlers setObject:handler forKey:window];

	[NSApp beginSheet:self modalForWindow:window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:(__bridge void *)window];
}

- (void) end {
	[NSApp endSheet:self];
}

- (void) endWithReturnCode:(NSInteger)returnCode {
	[NSApp endSheet:self returnCode:returnCode];
}

- (void) sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	NSLog(@"Sheet ended with return code: %@", PRHSheetDebugStringForReturnCode(returnCode));
	NSWindow *window = (__bridge NSWindow *)contextInfo;
	PRHSheetCompletionHandler handler = [self->parentWindowsToCompletionHandlers objectForKey:window];

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
