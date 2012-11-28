//
//  JGHypnosisView.m
//  Hypnosister
//
//  Created by Jon Gold on 25/11/2012.
//  Copyright (c) 2012 Jon Gold. All rights reserved.
//

#import "JGHypnosisView.h"
#import <CoreMotion/CoreMotion.h>

@implementation JGHypnosisView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCircleColor:[self generateColorWithHue:0.8 andBrightness:1.0 andAlpha:1.0]];
        [self setBackgroundColor:[self generateColorWithHue:0.8 andBrightness:1.0 andAlpha:0.8]];
        
        [self makeMotion];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - Drawing. I'm a designer. I like this.
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    //    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    float maxRadius = hypot(bounds.size.width, bounds.size.height) / 2.0;
    
    CGContextSetLineWidth(ctx, 10);
    
    [[self circleColor] setStroke];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        CGContextAddArc(ctx, center.x, center.y, currentRadius, 0.0, M_PI * 2.0, YES);
        
        CGContextStrokePath(ctx);
        
    }
    
    //    BNR Tutorial stuff - leave it in for a second
    //
    //    NSString *text = @"You are getting sleepy";
    //    UIFont *font = [UIFont boldSystemFontOfSize:20];
    //    CGRect textRect;
    //    textRect.size = [text sizeWithFont:font];
    //    textRect.origin.x = center.x - textRect.size.width / 2.0;
    //    textRect.origin.y = center.y - textRect.size.height / 2.0;
    //    [[UIColor blackColor] setFill];
    //    CGSize offset = CGSizeMake(0, 1);
    //    CGColorRef color = [[UIColor colorWithWhite:0 alpha:0.5] CGColor];
    //
    //    CGContextSetShadowWithColor(ctx, offset, 2.0, color);
    //
    //    [text drawInRect:textRect withFont:font];
    
}

#pragma mark - moving stuff
- (void)makeMotion
{
    motionManager = [[CMMotionManager alloc] init];
    
    // framerate dies if I go to 30fps, need to diagnose.
    motionManager.deviceMotionUpdateInterval = 1.0/10;
    if (motionManager.isDeviceMotionAvailable) {
        
        // Not really sure how this queue works, going to refactor
        // when I've read more about it.
        [motionManager
         startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
         withHandler:^(CMDeviceMotion *motion, NSError *error) {
             
             CMAttitude *currentAttitude = motion.attitude;
             
             // Clamp them to reasonable thresholds
             float roll = 30 + MAX(-30, MIN(30, RadiansToDegrees(currentAttitude.roll)));
             float pitch = 15 + MAX(-15, MIN(15, RadiansToDegrees(currentAttitude.pitch)));
             
             
             [self setCircleColor:[self generateColorWithHue:roll/60 andBrightness:pitch/30 andAlpha:1.0]];
             [self setBackgroundColor:[self generateColorWithHue:roll/60 andBrightness:pitch/30 andAlpha:0.8]];
             [self setNeedsDisplay];
             
         }];
    } else {
        NSLog(@"No can doosville, babydoll. http://www.youtube.com/watch?v=MAnX98MbfNo");
    }
    
}

// This is unused. Should probably delete it, shouldn't I?
//- (float)positionIn3D:(float)f
//{
//    float position = f;
//    if (position < 0)
//    {
//        position = 360 + position;
//    }
//    
//    return position;
//}

#pragma mark - touchy stuff
// so you can do stuff on the simulator with no gyro.
// if you want to play with it on the device get rid of
// [self makeMotion] in the init ^^^
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    
    float widthPercent = point.x/self.bounds.size.width;
    float heightPercent = point.y/self.bounds.size.height;
    
    [self setCircleColor:[self generateColorWithHue:widthPercent andBrightness:heightPercent andAlpha:1.0]];
    
    [self setBackgroundColor:[self generateColorWithHue:widthPercent andBrightness:heightPercent andAlpha:0.8]];
    
    [self setNeedsDisplay];
}


#pragma mark - WOOO COLOURS SO PRETTY
- (UIColor *)generateColorWithHue:(float)hue
                    andBrightness:(float)brightness
                         andAlpha:(float)alpha
{
    brightness = MAX(0.5, brightness);
    hue = (360*hue)/360;
    
    return [UIColor colorWithHue:hue saturation:0.93 brightness:brightness alpha:alpha];
}


#pragma mark - boring maths stuff
CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
};


@end
