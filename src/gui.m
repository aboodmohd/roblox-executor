#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
@property (strong) NSWindow *window;
@property (strong) NSTextField *scriptInput;
@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.window = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 400, 150)
                                              styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable)
                                                backing:NSBackingStoreBuffered
                                                  defer:NO];
    [self.window setTitle:@"Roblox Executor"];

    // Script Input
    self.scriptInput = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 60, 360, 30)];
    [self.scriptInput setPlaceholderString:@"Paste script URL here..."];
    [[self.window contentView] addSubview:self.scriptInput];

    // Execute Button
    NSButton *executeBtn = [[NSButton alloc] initWithFrame:NSMakeRect(150, 20, 100, 30)];
    [executeBtn setTitle:@"Execute"];
    [executeBtn setBezelStyle:NSBezelStyleRounded];
    [executeBtn setTarget:self];
    [executeBtn setAction:@selector(executeScript:)];
    [[self.window contentView] addSubview:executeBtn];

    [self.window makeKeyAndOrderFront:nil];
}

- (void)executeScript:(id)sender {
    NSString *input = [self.scriptInput stringValue];
    NSLog(@"Executing script from: %@", input);
    // Logic to call the C++ execution backend would go here
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
