//
//  HomeViewController.m
//  MyAppRN
//
//  Created by HanJi Zheng on 2023/1/14.
//

#import "HomeViewController.h"

#import <React/RCTAppSetupUtils.h>

@interface HomeViewController ()

@property (nonatomic, assign) BOOL isRNCommonBundleLoaded;
@property (nonatomic, copy, readwrite) void (^onRNCommonBundleLoaded)(void);
@property (nonatomic, strong) NSMutableDictionary *bundleLoadedCache;

@end

@implementation HomeViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self _initializer];
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [self _initializer];
  }
  return self;
}

- (void)_initializer {
  HomeViewController * __weak weakSelf = self;
  self.onRNCommonBundleLoaded = ^() {
    weakSelf.isRNCommonBundleLoaded = YES;
  };
  self.bundleLoadedCache = [NSMutableDictionary new];
}

- (void)loadModule:(NSString *)moduleName {
  if ([self.bundleLoadedCache[moduleName] boolValue]) return;
  NSURL *businessBundleURI = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"bundle/%@.ios", moduleName] withExtension:@"jsbundle"];// 业务包 URI
  NSError *error = nil;
  NSData *sourceData = [NSData dataWithContentsOfURL:businessBundleURI options:NSDataReadingMappedIfSafe error:&error];
  if (error) { return; }
//  [self.bridge.batchedBridge executeSourceCode:sourceData sync:NO];
  [[self.bridge performSelector:@selector(batchedBridge)] performSelector:@selector(executeSourceCode:sync:) withObject:sourceData withObject:nil];
  self.bundleLoadedCache[moduleName] = @1;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  UIButton *aBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, self.view.bounds.size.height / 2 - 5 - 44, self.view.bounds.size.width - 80, 44)];
  [aBtn setTitle:@"BusinessA" forState:UIControlStateNormal];
  [self.view addSubview:aBtn];
  
  UIButton *bBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, self.view.bounds.size.height / 2 + 5, self.view.bounds.size.width - 80, 44)];
  [bBtn setTitle:@"BusinessB" forState:UIControlStateNormal];
  [self.view addSubview:bBtn];
  
  [aBtn addTarget:self action:@selector(onABtnClick:) forControlEvents:UIControlEventTouchUpInside];
  [bBtn addTarget:self action:@selector(onBBtnClick:) forControlEvents:UIControlEventTouchUpInside];
  
  if (@available(iOS 13.0, *)) {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [aBtn setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
    [bBtn setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
  } else {
    self.view.backgroundColor = [UIColor whiteColor];
    [aBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [bBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
  }
}

- (void)onABtnClick:(UIButton *)btn {
  [self pushModule:@"businessA"];
}

- (void)onBBtnClick:(UIButton *)btn {
  [self pushModule:@"businessB"];
}

- (void)pushModule:(NSString *)moduleName {
  if (!self.isRNCommonBundleLoaded) return;
//  NSURL *businessBundleURI = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"bundle/%@.ios", moduleName] withExtension:@"jsbundle"];// 业务包 URI
//  NSError *error = nil;
//  NSData *sourceData = [NSData dataWithContentsOfURL:businessBundleURI options:NSDataReadingMappedIfSafe error:&error];
//  if (error) { return; }
////  [self.bridge.batchedBridge executeSourceCode:sourceData sync:NO];
//  [[self.bridge performSelector:@selector(batchedBridge)] performSelector:@selector(executeSourceCode:sync:) withObject:sourceData withObject:@1];
  [self loadModule:moduleName];
  NSDictionary *initProps = @{};
  UIView *rootView = RCTAppSetupDefaultRootView(self.bridge, moduleName, initProps);

  if (@available(iOS 13.0, *)) {
    rootView.backgroundColor = [UIColor systemBackgroundColor];
  } else {
    rootView.backgroundColor = [UIColor whiteColor];
  }
  
  UIViewController *vc = [UIViewController new];
  vc.view = rootView;
  
  [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
