//
//  AppDelegate.m
//  MapAnimation
//
//  Created by Dimitar Haralanov on 8/28/14.
//  Copyright (c) 2014 Dimitar Haralanov. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

- (void)didTapMapIcon:(id)sender;

@property BOOL mapShowing;

@property (strong, nonatomic) UIImageView *appBackground;
@property (strong, nonatomic) UIImageView *mapView;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    self.appBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.window.bounds.size.width, 548)];
    self.appBackground.image = [UIImage imageNamed:@"app-bg"];
    [self.window addSubview:self.appBackground];

    self.mapView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 62, self.window.bounds.size.width, 458)];
    self.mapView.image = [UIImage imageNamed:@"map-arrow"];
    self.mapView.alpha = 0.0f;
    self.mapView.transform = CGAffineTransformMakeTranslation(0, 30);
    self.mapView.transform = CGAffineTransformScale(self.mapView.transform, 1.1, 1.1);
    [self.window addSubview:self.mapView];

    UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon setImage:[UIImage imageNamed:@"map-icon"] forState:UIControlStateNormal];
    [icon addTarget:self action:@selector(didTapMapIcon:) forControlEvents:UIControlEventTouchUpInside];
    [icon setFrame:CGRectMake(self.window.bounds.size.width - 49, 19, 49, 44)];
    [self.window addSubview:icon];

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)didTapMapIcon:(id)sender
{
    if (self.mapShowing) {
        self.mapShowing = NO;

        CGFloat dampingStiffnessOut = 24.0f;

        [UIView animateWithDuration:0.5 delay:0
                            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.appBackground.alpha = 1.0f;
                         } completion:NULL];

        [UIView animateWithDuration:0.3 delay:0
                            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.mapView.alpha = 0.0f;
                         } completion:NULL];

        // Map gets 2 separate animations, one for position and the other for scale.
        JNWSpringAnimation *mapScale = [JNWSpringAnimation animationWithKeyPath:@"transform.scale"];
        mapScale.damping = dampingStiffnessOut;
        mapScale.stiffness = dampingStiffnessOut;
        mapScale.mass = 1;
        mapScale.fromValue = @([[self.mapView.layer.presentationLayer valueForKeyPath:mapScale.keyPath] floatValue]);
        mapScale.toValue = @(1.1);

        [self.mapView.layer addAnimation:mapScale forKey:mapScale.keyPath];
        self.mapView.transform =
        CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);

        JNWSpringAnimation *mapTranslate = [JNWSpringAnimation animationWithKeyPath:@"transform.translation.y"];
        mapTranslate.damping = dampingStiffnessOut;
        mapTranslate.stiffness = dampingStiffnessOut;
        mapTranslate.mass = 1;
        mapTranslate.fromValue = @([[self.mapView.layer.presentationLayer valueForKeyPath:mapTranslate.keyPath] floatValue]);
        mapTranslate.toValue = @(30);

        [self.mapView.layer addAnimation:mapTranslate forKey:mapTranslate.keyPath];
        self.mapView.transform = CGAffineTransformTranslate(self.mapView.transform, 0, 30);

        // Scale animation for the main app background. We animate it back to a 1.0 scale
        JNWSpringAnimation *scale = [JNWSpringAnimation animationWithKeyPath:@"transform.scale"];
        scale.damping = dampingStiffnessOut;
        scale.stiffness = dampingStiffnessOut;
        scale.mass = 1;
        scale.fromValue = @([[self.appBackground.layer.presentationLayer valueForKeyPath:@"transform.scale.x"] floatValue]);
        scale.toValue = @(1.0);
        
        [self.appBackground.layer addAnimation:scale forKey:scale.keyPath];
        self.appBackground.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
    } else {
        self.mapShowing = YES;

        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.appBackground.alpha = 0.3f;
                         }
                         completion:NULL];

        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.mapView.alpha = 1.0f;
                         }
                         completion:NULL];

        CGFloat dampingStiffness = 16.0f;

        // Scale animation for the main background
        JNWSpringAnimation *scale = [JNWSpringAnimation animationWithKeyPath:@"transform.scale"];
        scale.damping = dampingStiffness;
        scale.stiffness = dampingStiffness;
        scale.mass = 1;
        scale.fromValue = @([[self.appBackground.layer.presentationLayer valueForKeyPath:scale.keyPath] floatValue]);
        scale.toValue = @(0.9);

        [self.appBackground.layer addAnimation:scale forKey:scale.keyPath];
        self.appBackground.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);

        // Map gets 2 separate animations, one for position and the other for scale
        JNWSpringAnimation *mapScale = [JNWSpringAnimation animationWithKeyPath:@"transform.scale"];
        mapScale.damping = dampingStiffness;
        mapScale.stiffness = dampingStiffness;
        mapScale.mass = 1;
        mapScale.fromValue = @([[self.mapView.layer.presentationLayer valueForKeyPath:mapScale.keyPath] floatValue]);
        mapScale.toValue = @(1.0);

        [self.mapView.layer addAnimation:mapScale forKey:mapScale.keyPath];
        self.mapView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);

        JNWSpringAnimation *mapTranslate = [JNWSpringAnimation animationWithKeyPath:@"transform.translation.y"];
        mapTranslate.damping = dampingStiffness;
        mapTranslate.stiffness = dampingStiffness;
        mapTranslate.mass = 1;
        mapTranslate.fromValue = @([[self.mapView.layer.presentationLayer valueForKeyPath:mapTranslate.keyPath] floatValue]);
        mapTranslate.toValue = @(0);

        [self.mapView.layer addAnimation:mapTranslate forKey:mapTranslate.keyPath];
        self.mapView.transform = CGAffineTransformTranslate(self.mapView.transform, 0, 0);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
