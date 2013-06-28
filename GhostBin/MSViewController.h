//
//  MSViewController.h
//  GhostBin
//
//  Created by moeseth on 6/27/13.
//  Copyright (c) 2013 w00ty Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

@class MSLanguageChooser;

@interface MSViewController : UIViewController <UITextViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate> {
    IBOutlet UITextView *textView;
    IBOutlet UIButton *button;
    IBOutlet UINavigationBar *navBar;
    IBOutlet UILabel *urlLabel;
    MSLanguageChooser *chooser;
}

- (void)post:(id)sender;
- (IBAction)languageChooser:(id)sender;

@end
