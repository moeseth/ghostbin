//
//  MSLanguageChooser.h
//  GhostBin
//
//  Created by moeseth on 6/28/13.
//  Copyright (c) 2013 w00ty Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSLanguageChooser : UIView <UITableViewDataSource, UITableViewDelegate> {
    NSDictionary *languages;
    NSArray *keys;
}

@property(strong) void(^ChooserBlock)(NSString *chosen);

- (void) waitForAction:(void(^) (NSString *chosen)) block;

@end
