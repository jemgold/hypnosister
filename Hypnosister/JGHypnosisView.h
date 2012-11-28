//
//  JGHypnosisView.h
//  Hypnosister
//
//  Created by Jon Gold on 25/11/2012.
//  Copyright (c) 2012 Jon Gold. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface JGHypnosisView : UIView {
    CGPoint center;
    CMMotionManager *motionManager;
}

@property (nonatomic, strong) UIColor *circleColor;

-(UIColor *)generateColorWithHue:(float)hue
                   andBrightness:(float)brightness
                        andAlpha:(float)alpha;

@end
