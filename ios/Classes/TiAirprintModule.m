/**
 * Ti.Airprint Module
 * Copyright (c) 2010-present by Appcelerator, Inc. All Rights Reserved.
 * Please see the LICENSE included with this distribution for details.
 */

#import "TiAirprintModule.h"
#import "TiApp.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation TiAirprintModule

#pragma mark Internal

- (id)moduleGUID
{
  return @"ebd45fea-93b5-4ab7-bb03-b6d462aab32f";
}

- (NSString *)moduleId
{
  return @"ti.airprint";
}

#pragma mark Lifecycle

- (void)startup
{
  [super startup];
  NSLog(@"[DEBUG] %@ loaded", self);
}

#pragma Public APIs

- (NSNumber *)canPrint:(id)unused
{
  return @([UIPrintInteractionController isPrintingAvailable]);
}

- (void)print:(id)args
{
  ENSURE_UI_THREAD(print, args);
  ENSURE_SINGLE_ARG(args, NSDictionary);

  NSURL *url = [TiUtils toURL:[args objectForKey:@"url"] proxy:self];
  if (url == nil) {
    NSLog(@"[ERROR] Print called without passing in a url property!");
    return;
  }

  UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
  if (!controller) {
    NSLog(@"[ERROR] Unable to create a print interaction controller.");
    return;
  }

  if ([args objectForKey:@"showsPageRange"] != nil) {
    NSLog(@"[WARN] The \"showsPageRange\" property has been deprecated by Apple and always behaves as `true`.");
  }

  controller.showsPageRange = [TiUtils boolValue:[args objectForKey:@"showsPageRange"] def:YES];
  controller.showsNumberOfCopies = [TiUtils boolValue:[args objectForKey:@"showsNumberOfCopies"] def:YES];
  controller.showsPaperSelectionForLoadedPapers = [TiUtils boolValue:[args objectForKey:@"showsPaperSelectionForLoadedPapers"] def:YES];
  controller.printingItem = url;
  controller.delegate = self;

  UIPrintInteractionCompletionHandler completionHandler = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
    if (!completed && error) {
      NSLog(@"[ERROR] Printing failed due to error in domain %@ with error code %u", error.domain, error.code);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
  };

  if ([TiUtils isIPad] == NO) {
    [controller presentAnimated:YES completionHandler:completionHandler];
  } else {
    UIView *poView = [[TiApp app] controller].view;
    TiViewProxy *popoverViewProxy = [args objectForKey:@"view"];
    if (popoverViewProxy != nil) {
      poView = [popoverViewProxy view];
    }

    [controller presentFromRect:poView.bounds inView:poView animated:YES completionHandler:completionHandler];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePopover:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
  }
}

- (void)updatePopover:(NSNotification *)notification;
{
  [[UIPrintInteractionController sharedPrintController] performSelector:@selector(dismissAnimated:)
                                                             withObject:NO
                                                             afterDelay:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]
                                                                inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

#pragma mark Delegate

- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
  if ([self _hasListeners:@"close"]) {
    [self fireEvent:@"close" withObject:nil];
  }
}

- (void)printInteractionControllerDidPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
  if ([self _hasListeners:@"open"]) {
    [self fireEvent:@"open" withObject:nil];
  }
}

@end
