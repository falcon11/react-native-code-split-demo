#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <React/RCTAppSetupUtils.h>

#import "HomeViewController.h"

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTCxxBridgeDelegate.h>
#import <React/RCTFabricSurfaceHostingProxyRootView.h>
#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <ReactCommon/RCTTurboModuleManager.h>

#import <react/config/ReactNativeConfig.h>

static NSString *const kRNConcurrentRoot = @"concurrentRoot";

@interface AppDelegate () <RCTCxxBridgeDelegate, RCTTurboModuleManagerDelegate> {
  RCTTurboModuleManager *_turboModuleManager;
  RCTSurfacePresenterBridgeAdapter *_bridgeAdapter;
  std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
  facebook::react::ContextContainer::Shared _contextContainer;
}
@end
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCommonLoaded) name:RCTJavaScriptDidLoadNotification object:nil];
  RCTAppSetupPrepareApp(application);

  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  self.bridge = bridge;

#if RCT_NEW_ARCH_ENABLED
  _contextContainer = std::make_shared<facebook::react::ContextContainer const>();
  _reactNativeConfig = std::make_shared<facebook::react::EmptyReactNativeConfig const>();
  _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
  _bridgeAdapter = [[RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:bridge contextContainer:_contextContainer];
  bridge.surfacePresenter = _bridgeAdapter.surfacePresenter;
#endif

//  NSDictionary *initProps = [self prepareInitialProps];
//  UIView *rootView = RCTAppSetupDefaultRootView(bridge, @"MyAppRN", initProps);
//
//  if (@available(iOS 13.0, *)) {
//    rootView.backgroundColor = [UIColor systemBackgroundColor];
//  } else {
//    rootView.backgroundColor = [UIColor whiteColor];
//  }
//
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//  UIViewController *rootViewController = [UIViewController new];
  HomeViewController *homeVC = [HomeViewController new];
  homeVC.bridge = bridge;
  UINavigationController *navViewController = [[UINavigationController alloc] initWithRootViewController:homeVC];
//  rootViewController.view = rootView;
  
  self.window.rootViewController = navViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)onCommonLoaded {
  [[NSNotificationCenter defaultCenter]  removeObserver:self name:RCTJavaScriptDidLoadNotification object:nil];
//  NSURL *businessBundleURI = [[NSBundle mainBundle] URLForResource:@"bundle/main.ios" withExtension:@"jsbundle"];// 业务包 URI
//  NSError *error = nil;
//  NSData *sourceData = [NSData dataWithContentsOfURL:businessBundleURI options:NSDataReadingMappedIfSafe error:&error];
//  if (error) { return; }
////  [self.bridge.batchedBridge executeSourceCode:sourceData sync:NO];
//  [[self.bridge performSelector:@selector(batchedBridge)] performSelector:@selector(executeSourceCode:sync:) withObject:sourceData withObject:nil];
//  NSDictionary *initProps = [self prepareInitialProps];
//  UIView *rootView = RCTAppSetupDefaultRootView(self.bridge, @"MyAppRN", initProps);
//
//  if (@available(iOS 13.0, *)) {
//    rootView.backgroundColor = [UIColor systemBackgroundColor];
//  } else {
//    rootView.backgroundColor = [UIColor whiteColor];
//  }
//
//  self.window.rootViewController.view = rootView;
//
//
//  self.bridge = nil;
  HomeViewController *homeVC = (HomeViewController *)[(UINavigationController *)self.window.rootViewController topViewController];
  homeVC.onRNCommonBundleLoaded();
}

/// This method controls whether the `concurrentRoot`feature of React18 is turned on or off.
///
/// @see: https://reactjs.org/blog/2022/03/29/react-v18.html
/// @note: This requires to be rendering on Fabric (i.e. on the New Architecture).
/// @return: `true` if the `concurrentRoot` feture is enabled. Otherwise, it returns `false`.
- (BOOL)concurrentRootEnabled
{
  // Switch this bool to turn on and off the concurrent root
  return true;
}

- (NSDictionary *)prepareInitialProps
{
  NSMutableDictionary *initProps = [NSMutableDictionary new];

#ifdef RCT_NEW_ARCH_ENABLED
  initProps[kRNConcurrentRoot] = @([self concurrentRootEnabled]);
#endif

  return initProps;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  NSURL *url = [[NSBundle mainBundle] URLForResource:@"bundle/common.ios" withExtension:@"jsbundle"];
  return url;
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index"];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

#if RCT_NEW_ARCH_ENABLED

#pragma mark - RCTCxxBridgeDelegate

- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
  _turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge
                                                             delegate:self
                                                            jsInvoker:bridge.jsCallInvoker];
  return RCTAppSetupDefaultJsExecutorFactory(bridge, _turboModuleManager);
}

#pragma mark RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker
{
  return nullptr;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                     initParams:
                                                         (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  return RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#endif

@end

