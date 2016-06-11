//
//  CBAdvertiseHelper.m
//  Pods
//
//  Created by geekgy on 15/10/23.
//
//

#import "CBAdvertiseHelper.h"
#import "IOSSystemUtil.h"
#import <Chartboost/Chartboost.h>

@interface CBAdvertiseHelper() <ChartboostDelegate>

@end

@implementation CBAdvertiseHelper
{
    BOOL _spotClicked;
    void(^_spotFunc)(BOOL);
    BOOL _vedioCompleted;
    void(^_vedioViewFunc)(BOOL);
    BOOL _vedioClicked;
    void(^_vedioClickFunc)(BOOL);
}

SINGLETON_DEFINITION(CBAdvertiseHelper)

- (void)preloadSpotAd {
    [Chartboost cacheInterstitial:CBLocationDefault];
}

- (void)preloadVideoAd {
    [Chartboost cacheRewardedVideo:CBLocationDefault];
}

#pragma mark - AdvertiseDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%@ : %@", ChartBoost_Name, [Chartboost getSDKVersion]);
    NSString* appId = [[IOSSystemUtil getInstance] getConfigValueWithKey:ChartBoost_AppId];
    NSString* appSignature = [[IOSSystemUtil getInstance] getConfigValueWithKey:ChartBoost_AppSignature];
    [Chartboost startWithAppId:appId
                  appSignature:appSignature
                      delegate:self];
    [Chartboost setAutoCacheAds:NO];
    [self preloadSpotAd];
    [self preloadVideoAd];
    return YES;
}

- (int)showBannerAd:(BOOL)portrait :(BOOL)bottom {
    NSLog(@"did not support");
    return 0;
}

- (void)hideBannerAd {
    NSLog(@"did not support");
}

- (BOOL)showSpotAd:(void (^)(BOOL))func {
    if ([Chartboost hasInterstitial:CBLocationDefault]) {
        _spotClicked = NO;
        _spotFunc = func;
        [Chartboost showInterstitial:CBLocationDefault];
        return YES;
    }
    return NO;
}

- (BOOL)isVedioAdReady {
    return [Chartboost hasRewardedVideo:CBLocationDefault];
}

- (BOOL)showVedioAd:(void (^)(BOOL))viewFunc :(void (^)(BOOL))clickFunc {
    if ([self isVedioAdReady]) {
        _vedioCompleted = NO;
        _vedioClicked = NO;
        _vedioViewFunc = viewFunc;
        _vedioClickFunc = clickFunc;
        [Chartboost showRewardedVideo:CBLocationDefault];
        return YES;
    }
    return NO;
}

- (void)showMoreGames {
    [Chartboost showMoreApps:CBLocationDefault];
}

- (NSString *)getName {
    return ChartBoost_Name;
}

#pragma mark - ChartboostDelegate

- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error {
//    NSLog(@"didFailToLoadInterstitial: %ld", error);
    [self preloadSpotAd];
}

- (void)didDismissInterstitial:(CBLocation)location {
//    NSLog(@"didDismissInterstitial");
    _spotFunc(_spotClicked);
    [self preloadSpotAd];
}

- (void)didClickInterstitial:(CBLocation)location {
//    NSLog(@"didClickInterstitial");
    _spotClicked = YES;
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error {
//    NSLog(@"didFailToLoadRewardedVideo: %ld", error);
    [self preloadVideoAd];
}

- (void)didDismissRewardedVideo:(CBLocation)location {
//    NSLog(@"didDismissRewardedVideo");
    _vedioViewFunc(_vedioCompleted);
    _vedioClickFunc(_vedioClicked);
    [self preloadVideoAd];
}

- (void)didClickRewardedVideo:(CBLocation)location {
//    NSLog(@"didClickRewardedVideo");
    _vedioClicked = YES;
}

- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward {
//    NSLog(@"didCompleteRewardedVideo");
    _vedioCompleted = YES;
}

@end
