//
//  ggbgMyScene.h
//  GGop-BGop
//

//  Copyright (c) 2014 Zeotyn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
static const uint8_t crosshairCategory = 1;
static const uint8_t gopCategory = 2;

@interface ggbgGameScene : SKScene<UIAccelerometerDelegate, SKPhysicsContactDelegate> {
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    double currentMaxAccelX;
    double currentMaxAccelY;
    
    float xStart;
    float xEnd;
    float cp1X;
    float cp1Y;
    float cp2X;
    float cp2Y;
    
    int healthPoints;
    
}

@property int timerPoints;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property SKSpriteNode *crosshair;
@property SKSpriteNode *gop;
@property (nonatomic, strong) SKLabelNode *healthPointsLabel;
@property (nonatomic, strong) SKLabelNode *gameTimerPoints;
@property (strong, nonatomic) NSTimer *timer;

@end
