#import <Cocoa/Cocoa.h>
#include "executor_backend.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *scriptInput;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Create a basic menu bar to enable Cmd+C / Cmd+V
    NSMenu *mainMenu = [[NSMenu alloc] init];
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
    [mainMenu addItem:appMenuItem];
    [NSApp setMainMenu:mainMenu];

    NSMenu *appMenu = [[NSMenu alloc] init];
    NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [appMenu addItem:quitMenuItem];
    [appMenuItem setSubmenu:appMenu];

    NSMenuItem *editMenuItem = [[NSMenuItem alloc] initWithTitle:@"Edit" action:nil keyEquivalent:@""];
    [mainMenu addItem:editMenuItem];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Paste" action:@selector(paste:) keyEquivalent:@"v"]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Select All" action:@selector(selectAll:) keyEquivalent:@"a"]];
    [editMenuItem setSubmenu:editMenu];

    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 400, 150)
                                              styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable)
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    [self.window setTitle:@"Roblox Executor"];

    self.scriptInput = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 60, 360, 30)];
    [self.scriptInput setPlaceholderString:@"Paste script here..."];
    [[self.window contentView] addSubview:self.scriptInput];

    NSButton *executeBtn = [[NSButton alloc] initWithFrame:NSMakeRect(150, 20, 100, 30)];
    [executeBtn setTitle:@"Execute"];
    [executeBtn setBezelStyle:NSBezelStyleRounded];
    [executeBtn setTarget:self];
    [executeBtn setAction:@selector(executeScript:)];
    [[self.window contentView] addSubview:executeBtn];

    [self.window makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)executeScript:(id)sender {
    NSString *input = [self.scriptInput stringValue];
    if (input.length == 0) {
        NSLog(@"Input is empty");
        return;
    }
    std::string script = [input UTF8String];
    runExecutorBackend(script);
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSApplication *app = [NSApplication sharedApplication];
        AppDelegate *delegate = [[AppDelegate alloc] init];
        [app setDelegate:delegate];
        [app run];
    }
    return 0;
}
