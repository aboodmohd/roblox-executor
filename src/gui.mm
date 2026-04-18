#import <Cocoa/Cocoa.h>
#include "executor_backend.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextView *scriptInput;
@end

@implementation AppDelegate

- (void)setupMenu {
    NSMenu *menubar = [[NSMenu alloc] init];
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
    [menubar addItem:appMenuItem];
    [NSApp setMainMenu:menubar];

    NSMenu *appMenu = [[NSMenu alloc] init];
    NSString *appName = @"Roblox Executor";
    NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"Quit %@", appName] 
                                                          action:@selector(terminate:) 
                                                   keyEquivalent:@"q"];
    [appMenu addItem:quitMenuItem];
    [appMenuItem setSubmenu:appMenu];

    // Edit Menu - Crucial for Cmd+C / Cmd+V
    NSMenuItem *editMenuItem = [[NSMenuItem alloc] initWithTitle:@"Edit" action:nil keyEquivalent:@""];
    [menubar addItem:editMenuItem];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Undo" action:@selector(undo:) keyEquivalent:@"z"]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Redo" action:@selector(redo:) keyEquivalent:@"Z"]];
    [editMenu addItem:[NSMenuItem separatorItem]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Cut" action:@selector(cut:) keyEquivalent:@"x"]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Copy" action:@selector(copy:) keyEquivalent:@"c"]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Paste" action:@selector(paste:) keyEquivalent:@"v"]];
    [editMenu addItem:[[NSMenuItem alloc] initWithTitle:@"Select All" action:@selector(selectAll:) keyEquivalent:@"a"]];
    [editMenuItem setSubmenu:editMenu];
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification {
    // Force the app to act as a regular macOS app (gets focus, shows in dock)
    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
    [self setupMenu];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect frame = NSMakeRect(0, 0, 600, 400);
    NSUInteger styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskFullSizeContentView;
    
    self.window = [[NSWindow alloc] initWithContentRect:frame 
                                              styleMask:styleMask 
                                                backing:NSBackingStoreBuffered 
                                                  defer:NO];
    [self.window setTitle:@"Roblox Executor"];
    [self.window setTitlebarAppearsTransparent:YES];
    [self.window setMovableByWindowBackground:YES];
    [self.window center];

    NSVisualEffectView *vibrancy = [[NSVisualEffectView alloc] initWithFrame:frame];
    [vibrancy setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [vibrancy setBlendingMode:NSVisualEffectBlendingModeBehindWindow];
    [vibrancy setMaterial:NSVisualEffectMaterialUnderWindowBackground];
    [vibrancy setState:NSVisualEffectStateActive];
    [self.window setContentView:vibrancy];

    NSView *contentView = [self.window contentView];

    NSScrollView *scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(20, 70, 560, 290)];
    [scrollView setHasVerticalScroller:YES];
    [scrollView setHasHorizontalScroller:NO];
    [scrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [scrollView setDrawsBackground:NO];

    NSSize contentSize = [scrollView contentSize];
    self.scriptInput = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 0, contentSize.width, contentSize.height)];
    [self.scriptInput setMinSize:NSMakeSize(0.0, contentSize.height)];
    [self.scriptInput setMaxSize:NSMakeSize(CGFLOAT_MAX, CGFLOAT_MAX)];
    [self.scriptInput setVerticallyResizable:YES];
    [self.scriptInput setHorizontallyResizable:NO];
    [self.scriptInput setAutoresizingMask:NSViewWidthSizable];
    [[self.scriptInput textContainer] setContainerSize:NSMakeSize(contentSize.width, CGFLOAT_MAX)];
    [[self.scriptInput textContainer] setWidthTracksTextView:YES];
    
    [self.scriptInput setFont:[NSFont fontWithName:@"Menlo" size:14.0]];
    [self.scriptInput setTextColor:[NSColor textColor]];
    [self.scriptInput setBackgroundColor:[NSColor textBackgroundColor]];
    [self.scriptInput setRichText:NO];
    [self.scriptInput setAllowsUndo:YES];
    
    [scrollView setDocumentView:self.scriptInput];
    [contentView addSubview:scrollView];

    NSButton *executeBtn = [[NSButton alloc] initWithFrame:NSMakeRect(20, 20, 560, 40)];
    [executeBtn setTitle:@"Inject & Execute Script"];
    [executeBtn setBezelStyle:NSBezelStyleRounded];
    [executeBtn setControlSize:NSControlSizeLarge];
    [executeBtn setAutoresizingMask:NSViewWidthSizable | NSViewMaxYMargin];
    [executeBtn setTarget:self];
    [executeBtn setAction:@selector(executeScript:)];
    [contentView addSubview:executeBtn];

    [self.window makeKeyAndOrderFront:nil];
    
    // Force the app to the front immediately so Cmd+V works here, not in terminal
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeFirstResponder:self.scriptInput];
}

- (void)executeScript:(id)sender {
    NSString *input = [self.scriptInput string];
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
