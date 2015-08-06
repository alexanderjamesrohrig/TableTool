//
//  TTFormatViewController.m
//  Table Tool
//
//  Created by Andreas Aigner on 24.07.15.
//  Copyright (c) 2015 Egger Apps. All rights reserved.
//

#import "TTFormatViewController.h"

@interface TTFormatViewController ()
@end

@implementation TTFormatViewController

-(instancetype) initAsInputController:(BOOL)inputController {
    self = [super initWithNibName:@"TTFormatViewController" bundle:nil];
    if(self) {
        _config = [[CSVConfiguration alloc]init];
        _isInputController = inputController;
    }
    return self;
}

- (void)viewDidLoad {
    if(_isInputController){
        _confirmBox.hidden = NO;
        _useFirstRowAsHeaderCheckbox.hidden = NO;
    }else{
        _bottomConstraint.active = NO;
    }
    [super viewDidLoad];
}

- (IBAction)updateConfiguration:(id)sender {
    _config.encoding = [self.encodingMenu selectedTag];
    if([self.separatorControl selectedSegment] == 2) {
        _config.columnSeparator = @"\t";
    }else{
        _config.columnSeparator = [self.separatorControl labelForSegment:[self.separatorControl selectedSegment] ];
    }
    _config.decimalMark = [self.decimalControl labelForSegment:[self.decimalControl selectedSegment]];
    if([self.quoteCheckbox state] == 1){
        _config.quoteCharacter = @"\"";
        self.escapeControl.enabled = YES;
    }else{
        _config.quoteCharacter = @"";
        self.escapeControl.enabled = NO;
    }
    _config.escapeCharacter = [self.escapeControl labelForSegment:[self.escapeControl selectedSegment]];
    
    [self.delegate configurationChangedForFormatViewController:self];
}

- (IBAction)useFirstRowAsHeaderClicked:(id)sender {
    [self useFirstRowAsHeader];
}

-(void)useFirstRowAsHeader{
    if(!_firstRowAsHeader){
        _firstRowAsHeader = YES;
    }else{
        _firstRowAsHeader = NO;
    }
    [self.delegate useFirstRowAsHeader:self];
}

-(IBAction)confirmConfiguration:(id)sender{
    [self.delegate confirmFormat:self];
}

-(void)uncheckCheckbox{
    [[_useFirstRowAsHeaderCheckbox cell] setState:0];
    [self useFirstRowAsHeader];
}

-(void)unableFormatting{
    _encodingMenu.enabled = NO;
    _escapeControl.enabled = NO;
    _separatorControl.enabled = NO;
    _decimalControl.enabled = NO;
    _quoteCheckbox.enabled = NO;
    _useFirstRowAsHeaderCheckbox.enabled = NO;
}

-(void)enableFormatting{
    _encodingMenu.enabled = YES;
    _separatorControl.enabled = YES;
    _decimalControl.enabled = YES;
    _quoteCheckbox.enabled = YES;
    if([_quoteCheckbox state]) {
    _escapeControl.enabled = YES;
    }
    _useFirstRowAsHeaderCheckbox.enabled = YES;
}
-(void)useLocale{
    _config.decimalMark = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    if([_config.decimalMark isEqualToString:@"."]){
        _config.columnSeparator = @",";
    }else{
        _config.columnSeparator = @";";
    }
    [self selectFormatByConfig];
}

-(void)selectFormatByConfig{
    [_encodingMenu selectItemWithTag:_config.encoding];
    if([_config.columnSeparator isEqualToString:@","]){
        [_separatorControl selectSegmentWithTag:0];
    }else if([_config.columnSeparator isEqualToString:@";"]){
        [_separatorControl selectSegmentWithTag:1];
    }else {
        [_separatorControl selectSegmentWithTag:2];
    }
    
    if([_config.decimalMark isEqualToString:@"."]){
        [_decimalControl selectSegmentWithTag:0];
    }else{
        [_decimalControl selectSegmentWithTag:1];
    }
    
    if([_config.quoteCharacter isEqualToString:@"\""]){
        [_quoteCheckbox setState:1];
    }else{
        [_quoteCheckbox setState:0];
    }
    
    if([_config.escapeCharacter isEqualToString:@"\""]){
        [_escapeControl selectSegmentWithTag:0];
    }else{
        [_escapeControl selectSegmentWithTag:1];
    }
    
    if([_quoteCheckbox state]){
        _escapeControl.enabled = YES;
    } else {
        _escapeControl.enabled = NO;
    }
}

@end