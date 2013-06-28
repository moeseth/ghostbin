//
//  MSViewController.m
//  GhostBin
//
//  Created by moeseth on 6/27/13.
//  Copyright (c) 2013 w00ty Lab. All rights reserved.
//

#import "MSViewController.h"
#import "MSLanguageChooser.h"

@interface MSViewController ()

@end

#define kHeaderBoundary @"eb0e82e3786d"

@implementation MSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *originalImage = [UIImage imageNamed:@"NavBtn"];
    UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 40, 1)];
    [button setBackgroundImage:stretchableImage forState:UIControlStateNormal];
    
    NSString *initial = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
    if (initial == NULL) {
        [button setTitle:@"text" forState:UIControlStateNormal];
    } else {
        [button setTitle:initial forState:UIControlStateNormal];
    }
    
    UIButton *tempBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn1.frame = CGRectMake(0, 0, 50, 30);
    [tempBtn1 setBackgroundImage:[UIImage imageNamed:@"BarBtn"] forState:UIControlStateNormal];
    [tempBtn1 setTitle:@"^" forState:UIControlStateNormal];
    [tempBtn1 addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *actionBtn = [[UIBarButtonItem alloc] initWithCustomView:tempBtn1];
    navBar.topItem.leftBarButtonItem = actionBtn;
    
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = CGRectMake(0, 0, 50, 30);
    [tempBtn setBackgroundImage:[UIImage imageNamed:@"BarBtn"] forState:UIControlStateNormal];
    [tempBtn setTitle:@"Post" forState:UIControlStateNormal];
    tempBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    [tempBtn addTarget:self action:@selector(post:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *postBtn = [[UIBarButtonItem alloc] initWithCustomView:tempBtn];
    navBar.topItem.rightBarButtonItem = postBtn;
    
    textView.text = [[UIPasteboard generalPasteboard] string];
    [textView becomeFirstResponder];
    
    [textView selectAll:self];
}

- (IBAction)languageChooser:(id)sender {
    [textView resignFirstResponder];
    CGRect rect;
    
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationPortrait) {
        rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    } else {
        rect = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
    }
    
    chooser = [[MSLanguageChooser alloc] initWithFrame:rect];
    
    chooser.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [chooser waitForAction:^(NSString *chosen) {
        if (chosen != NULL) {
            [button setTitle:chosen forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:chosen forKey:@"type"];
        }

        [UIView animateWithDuration:0.4f animations:^{
            chooser.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
            chooser.alpha = 0.0f;
        }];
        
        [textView becomeFirstResponder];
    }];
    
    [self.view addSubview:chooser];
}

- (void) share:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Email", nil];
    [actionSheet showInView:self.view];
}

- (void) post:(id)sender {
    if (textView.text.length < 1) {
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

	NSMutableDictionary *post_dict = [NSMutableDictionary dictionary];
	[post_dict setObject:textView.text forKey:@"text"];
    [post_dict setObject:button.titleLabel.text forKey:@"lang"];
	
	NSMutableData *post_data = [NSMutableData data];
	for (NSString *key in [post_dict allKeys]) {
		[post_data appendData:[[NSString stringWithFormat:@"--%@\r\n", kHeaderBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[post_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
		[post_data appendData:[[post_dict valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
		[post_data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
    
	[post_data appendData:[[NSString stringWithFormat:@"--%@--\r\n", kHeaderBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://ghostbin.com/paste/new"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:15.0f];
	[request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kHeaderBoundary] forHTTPHeaderField:@"Content-Type"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:post_data];
	
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)res;
        if ([httpResponse statusCode] == 200) {            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cool" message:@"Copied to your pasteboard" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
            
            urlLabel.text = [[httpResponse URL] absoluteString];
            [[UIPasteboard generalPasteboard] setString:urlLabel.text];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Failed" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [textView selectAll:self];
    }];
}

- (BOOL) textView:(UITextView *)tV shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ((text.length <= 0)) {
        textView.text = @"";
        urlLabel.text = @"";
    }
    
    return YES;
}

- (void) textViewDidBeginEditing:(UITextView *)tv {
    tv.frame = CGRectMake(0, 44, 320, 167);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (urlLabel.text.length < 1) {
        return;
    }
    
    if (buttonIndex == 0) {
        TWTweetComposeViewController *Tcomposer  = [[TWTweetComposeViewController alloc] init];
        [Tcomposer setInitialText:[NSString stringWithFormat:@"%@ ", urlLabel.text]];
        Tcomposer.completionHandler = ^(TWTweetComposeViewControllerResult r) {
            [textView becomeFirstResponder];
        };
        [self presentViewController:Tcomposer animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        composer.mailComposeDelegate = self;
        
        if ([MFMailComposeViewController canSendMail]) {
            [composer setToRecipients:[NSArray arrayWithObjects:nil]];
            [composer setSubject:@"Hey, I posted a link to ghostbin"];
            [composer setMessageBody:[NSString stringWithFormat:@"%@ ", urlLabel.text] isHTML:YES];
            [self presentViewController:composer animated:YES completion:NULL];
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    textView.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if (chooser != NULL) {
            chooser.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
        }
    } else {
        if (chooser != NULL) {
            chooser.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}

@end


