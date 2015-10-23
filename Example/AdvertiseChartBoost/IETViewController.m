//
//  IETViewController.m
//  AdvertiseChartBoost
//
//  Created by gaoyang on 10/22/2015.
//  Copyright (c) 2015 gaoyang. All rights reserved.
//

#import "IETViewController.h"
#import "CBAdvertiseHelper.h"

@interface IETViewController ()

@end

@implementation IETViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showSpotAd:(id)sender {
    BOOL result = [[CBAdvertiseHelper getInstance] showSpotAd:^(BOOL result) {
        NSLog(@"SpotAd Click: %@", result?@"YES":@"NO");
    }];
    NSLog(@"SpotAd Show: %@", result?@"YES":@"NO");
}

- (IBAction)isVedioReady:(id)sender {
    BOOL result = [[CBAdvertiseHelper getInstance] isVedioAdReady];
    NSLog(@"VedioAd Ready: %@", result?@"YES":@"NO");
}

- (IBAction)showVedioAd:(id)sender {
    BOOL result = [[CBAdvertiseHelper getInstance] showVedioAd:^(BOOL result) {
        NSLog(@"VedioAd Valid: %@", result?@"YES":@"NO");
    } :^(BOOL result) {
        NSLog(@"VedioAd Click: %@", result?@"YES":@"NO");
    }];
    NSLog(@"VedioAd Show: %@", result?@"YES":@"NO");
}

- (IBAction)getName:(id)sender {
    NSLog(@"Ad Name: %@", [[CBAdvertiseHelper getInstance] getName]);
}
@end
