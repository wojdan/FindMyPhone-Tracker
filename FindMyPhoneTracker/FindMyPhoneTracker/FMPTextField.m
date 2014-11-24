//
//  FMPTextField.m
//  FindMyPhoneTracker
//
//  Created by Wojdan on 25.10.2014.
//  Copyright (c) 2014 wojdan. All rights reserved.
//

#import "FMPTextField.h"

@implementation FMPTextField

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 5.f;

        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        self.leftView = leftView;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

@end
