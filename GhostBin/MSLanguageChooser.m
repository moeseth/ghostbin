//
//  MSLanguageChooser.m
//  GhostBin
//
//  Created by moeseth on 6/28/13.
//  Copyright (c) 2013 w00ty Lab. All rights reserved.
//

#import "MSLanguageChooser.h"

@implementation MSLanguageChooser
@synthesize ChooserBlock;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 140, 30, 280, 300)];
        imageView.image = [UIImage imageNamed:@"Popup"];
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(30, 40, imageView.frame.size.width - 60, imageView.frame.size.height - 53)];
        tableView.delegate = self;
        tableView.rowHeight = 50.0f;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = FALSE;
        tableView.backgroundColor = [UIColor clearColor];
        [imageView addSubview:tableView];
        
        keys = [NSArray arrayWithObjects:@"Logos + Objective-C", @"Objective-C", @"Plain Text", @"C", @"C++", @"IRC log", @"Perl", @"Go", @"HTML", @"ANSI", nil];
        languages = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"logos", @"objective-c", @"text", @"c", @"c++", @"irc", @"perl", @"go", @"html", @"ansi", nil] forKeys:keys];
    }
    return self;
}

- (void) waitForAction:(void(^) (NSString *chosen)) block {
    ChooserBlock = block;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    ChooserBlock(NULL);
}

#pragma UITableView methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [keys count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:@"Cell"];
	
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor clearColor];
    }

    cell.textLabel.text = [keys objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:18];
	return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
    ChooserBlock([languages objectForKey:[keys objectAtIndex:indexPath.row]]);
}

@end
