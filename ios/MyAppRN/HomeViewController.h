//
//  HomeViewController.h
//  MyAppRN
//
//  Created by HanJi Zheng on 2023/1/14.
//

#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController

@property (nonatomic, weak) RCTBridge *bridge;
@property (nonatomic, copy, readonly) void (^onRNCommonBundleLoaded)(void);

@end

NS_ASSUME_NONNULL_END
