//
//  MSNavigationBar.m
//  GhostBin
//
//  Created by moeseth on 6/28/13.
//  Copyright (c) 2013 w00ty Lab. All rights reserved.
//

#import "MSNavigationBar.h"

@implementation MSNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIImage *image = [[UIImage imageNamed:@"NavBar"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
