//
//  ggbgMyScene.m
//  GGop-BGop
//
//  Created by Eugen Waldschmidt on 22.05.14.
//  Copyright (c) 2014 Zeotyn. All rights reserved.
//

#import "ggbgGameScene.h"
#import "ggbgGameOverScene.h"

BOOL _touching = NO;
NSInteger *gameTimerScore = 0;
@implementation ggbgGameScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        
        healthPoints = 100;
        _timerPoints = 0;
        [self startTimer];
        
        //CoreMotion
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.accelerometerUpdateInterval = .2;
        
        [_motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error)
                                                 {
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
        

        
        //adding gameTimerPoints
        _gameTimerPoints = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
        _gameTimerPoints.text = [NSString stringWithFormat:@"Score: %d", _timerPoints];
        _gameTimerPoints.fontSize = 35;
        _gameTimerPoints.position = CGPointMake(CGRectGetMidX(self.frame), 500);
        _gameTimerPoints.zPosition = 1;
        
        [self addChild:_gameTimerPoints];
        
        //init several sizes used in all scene
        screenRect = [[UIScreen mainScreen] bounds];
        screenHeight = screenRect.size.height;
        screenWidth = screenRect.size.width;
        
        //adding the crosshair
        _crosshair = [SKSpriteNode spriteNodeWithImageNamed:@"crosshair"];
        _crosshair.size = CGSizeMake(50, 50);
        _crosshair.zPosition = 4;
        _crosshair.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:_crosshair];
        
        //adding the background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:background];
        
        //adding the hp bar
        _hpBar =  [SKSpriteNode spriteNodeWithColor: [UIColor greenColor] size: CGSizeMake(640, 20)];
        _hpBar.zPosition = 6;
        _hpBar.position = CGPointMake(0, 568);
        [self addChild:_hpBar];
        
        //schedule enemies
        SKAction *wait = [SKAction waitForDuration:0.3];
        SKAction *callGop = [SKAction runBlock:^{
            [self BadGopsAndGoodGops];
        }];
        
        SKAction *updateGops = [SKAction sequence:@[wait,callGop]];
        [self runAction:[SKAction repeatActionForever:updateGops]];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    _touching = YES;
    
    _crosshair.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:1.0];
    _crosshair.physicsBody.dynamic = NO;
    _crosshair.physicsBody.categoryBitMask = crosshairCategory;
    _crosshair.physicsBody.contactTestBitMask = gopCategory;
    _crosshair.physicsBody.collisionBitMask = 0;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
        _touching = NO;
}

-(void)didBeginContact:(SKPhysicsContact *)contact{

    if (_touching == YES) {

        SKPhysicsBody *firstBody;
        SKPhysicsBody *secondBody;
        _touching = NO;
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA;
            secondBody = contact.bodyB;
        }
        else
        {
            firstBody = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        if (((firstBody.categoryBitMask & crosshairCategory) != 0))
        {
            
            //SKNode *projectile = (contact.bodyA.categoryBitMask & crosshairCategory) ? contact.bodyA.node : contact.bodyB.node;
            SKNode *enemy = (contact.bodyA.categoryBitMask & crosshairCategory) ? contact.bodyB.node : contact.bodyA.node;
            //[projectile runAction:[SKAction removeFromParent]];
            
            if ([enemy.name isEqualToString:@"badGop"]) {
                [enemy runAction:[SKAction removeFromParent]];
                healthPoints -= 7;

                
            } else {
                [enemy runAction:[SKAction removeFromParent]];
                if (healthPoints <= 90) {
                    healthPoints +=3;
                } else if (healthPoints >= 90 ) {
                    healthPoints = 100;
                }

            }
            

        }
        
    }
}

-(void)update:(CFTimeInterval)currentTime {
    
    float maxY = screenWidth - _crosshair.size.width/2;
    float minY = _crosshair.size.width/2;
    
    
    float maxX = screenHeight - _crosshair.size.height/2;
    float minX = _crosshair.size.height/2;
    
    float newY = 0;
    float newX = 0;
    
    newX = currentMaxAccelX * 15;
    
    newY = currentMaxAccelY * 15;
    
    
    newX = MIN(MAX(newX+_crosshair.position.x,minY),maxY);
    newY = MIN(MAX(newY+_crosshair.position.y,minX),maxX);
    
    _crosshair.position = CGPointMake(newX, newY);
    
    
    
}


- (void)startTimer
{
    // create timer
    _timer = [NSTimer timerWithTimeInterval:1.0
                                         target:self
                                       selector:@selector(updateGameTimer)
                                       userInfo:nil
                                        repeats:YES];
    
    // attach the timer to this thread's run loop
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void) updateGameTimer
{
    _timerPoints++;
    gameTimerScore++;
    healthPoints--;
    
    
    _gameTimerPoints.text = [[NSString alloc] initWithFormat:@"Score: %d", _timerPoints];
    [self hpBarSize];
    if (healthPoints <=0) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        [self.timer invalidate];
        SKScene * gameOverScene = [[ggbgGameOverScene alloc] initWithSize:self.size score:_timerPoints];
        [self.view presentScene:gameOverScene transition: reveal];

    }
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    currentMaxAccelX = 0;
    currentMaxAccelY = 0;
    
    if(fabs(acceleration.x) > fabs(currentMaxAccelX))
    {
        currentMaxAccelX = acceleration.x;
    }
    if(fabs(acceleration.y) > fabs(currentMaxAccelY))
    {
        currentMaxAccelY = acceleration.y;
    }
}

-(void)BadGopsAndGoodGops{
    //not always come
    int GoOrNot = [self getRandomNumberBetween:0 to:1];
    
    _gop.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_gop.size];
    _gop.physicsBody.dynamic = YES;
    _gop.physicsBody.categoryBitMask = gopCategory;
    _gop.physicsBody.contactTestBitMask = crosshairCategory;
    _gop.physicsBody.collisionBitMask = 0;
    
    if(GoOrNot == 1){
        
        SKSpriteNode *goodGop;
        SKSpriteNode *badGop;
        
        
        int randomGop = [self getRandomNumberBetween:0 to:100];
        if(randomGop < 75) {
            badGop = [SKSpriteNode spriteNodeWithImageNamed:@"badgop"];
            badGop.size = CGSizeMake(149, 151);
        }
        else {
            goodGop = [SKSpriteNode spriteNodeWithImageNamed:@"goodgop"];
            goodGop.size = CGSizeMake(149, 151);
        }
        
        
        if (goodGop) {
            _gop = goodGop;
            _gop.name = @"goodGop";
        } else {
            _gop = badGop;
            _gop.name = @"badGop";
        }
        
        _gop.scale = 0.4;
        
        _gop.position = CGPointMake(screenRect.size.width/2, screenRect.size.height/2);
        _gop.zPosition = 1;
        
        
        CGPathRef cgpath;
        SKAction *followPath;
        SKAction *scale;
        
        int randomPosition = [self getRandomNumberBetween:1 to:4];
        
        switch (randomPosition) {
            case 1:
                _gop.scale = 0.5;
                cgpath = [self topBottom];
                followPath = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:6];
                scale = [SKAction scaleTo:0.1 duration:6];
                break;
                
            case 2:
                _gop.scale = 0.1;
                cgpath = [self bottomTop];
                followPath = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:6];
                scale = [SKAction scaleTo:0.5 duration:6];
                break;
                
            case 3:
                _gop.scale = 0.3;
                cgpath = [self leftRightCurveTop];
                followPath = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:6];
                scale = [SKAction scaleTo:0.3 duration:6];
                break;
                
            case 4:
                _gop.scale = 0.3;
                cgpath = [self leftRightCurveBottom];
                followPath = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:6];
                scale = [SKAction scaleTo:0.3 duration:6];
                break;
            default:
                break;
        }
        
     
        [self addChild:_gop];
        SKAction *remove = [SKAction removeFromParent];
        
        SKAction *group = [SKAction group:@[scale, followPath]];
        [_gop runAction:[SKAction sequence:@[group,remove]]];
        
        
    }
    
}

//-(CGPathRef)topBottom {
//    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
//    
//    [bezierPath moveToPoint: CGPointMake(69.5, -0.5)];
//    [bezierPath addCurveToPoint: CGPointMake(69.5, 206.5) controlPoint1: CGPointMake(69.5, -0.5) controlPoint2: CGPointMake(9.5, 177.5)];
//    [bezierPath addCurveToPoint: CGPointMake(238.5, 349.5) controlPoint1: CGPointMake(129.5, 235.5) controlPoint2: CGPointMake(259.5, 291.5)];
//    [bezierPath addCurveToPoint: CGPointMake(96.5, 569.5) controlPoint1: CGPointMake(217.5, 407.5) controlPoint2: CGPointMake(96.5, 569.5)];
//    
//    return bezierPath.CGPath;
//}

-(CGPathRef)topBottom {
    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
    int x = [self getRandomNumberBetween:20 to:300];
    int x_end = [self getRandomNumberBetween:20 to:300];
    [bezierPath moveToPoint: CGPointMake(x, -50.0)];
    [bezierPath addCurveToPoint: CGPointMake(x, 206.5) controlPoint1: CGPointMake(x, -50) controlPoint2: CGPointMake(9.5, 177.5)];
    [bezierPath addCurveToPoint: CGPointMake(238.5, 349.5) controlPoint1: CGPointMake(129.5, 235.5) controlPoint2: CGPointMake(259.5, 291.5)];
    [bezierPath addCurveToPoint: CGPointMake(x_end, 600) controlPoint1: CGPointMake(217.5, 407.5) controlPoint2: CGPointMake(x_end, 600)];
    
    return bezierPath.CGPath;
}


//-(CGPathRef)bottomTop {
//    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
//    
//    [bezierPath moveToPoint: CGPointMake(255.5, 567.5)];
//    [bezierPath addCurveToPoint: CGPointMake(94.5, 366.5) controlPoint1: CGPointMake(255.5, 567.5) controlPoint2: CGPointMake(57.5, 459.5)];
//    [bezierPath addCurveToPoint: CGPointMake(218.5, 193.5) controlPoint1: CGPointMake(131.5, 273.5) controlPoint2: CGPointMake(254.5, 249.5)];
//    [bezierPath addCurveToPoint: CGPointMake(77.5, -0.5) controlPoint1: CGPointMake(182.5, 137.5) controlPoint2: CGPointMake(77.5, -0.5)];
//    
//    return bezierPath.CGPath;
//}

-(CGPathRef)bottomTop {
    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
    
    int x = [self getRandomNumberBetween:20 to:300];
    int x_end = [self getRandomNumberBetween:20 to:300];
    
    [bezierPath moveToPoint: CGPointMake(x, 600)];
    [bezierPath addCurveToPoint: CGPointMake(x, 366.5) controlPoint1: CGPointMake(x, 600) controlPoint2: CGPointMake(x, 459.5)];
    [bezierPath addCurveToPoint: CGPointMake(218.5, 193.5) controlPoint1: CGPointMake(131.5, 273.5) controlPoint2: CGPointMake(254.5, 249.5)];
    [bezierPath addCurveToPoint: CGPointMake(x_end, -50) controlPoint1: CGPointMake(182.5, 137.5) controlPoint2: CGPointMake(x_end, -50)];
    
    return bezierPath.CGPath;
}

//-(CGPathRef)leftRightCurveTop {
//    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
//    
//    [bezierPath moveToPoint: CGPointMake(319.5, 139.5)];
//    [bezierPath addCurveToPoint: CGPointMake(169.5, 442.5) controlPoint1: CGPointMake(319.5, 139.5) controlPoint2: CGPointMake(326.5, 453.5)];
//    [bezierPath addCurveToPoint: CGPointMake(-0.5, 198.5) controlPoint1: CGPointMake(12.5, 431.5) controlPoint2: CGPointMake(-0.5, 198.5)];
//    
//    return bezierPath.CGPath;
//}

-(CGPathRef)leftRightCurveTop {
    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
    
    int y = [self getRandomNumberBetween:20 to:560];
    int y_end = [self getRandomNumberBetween:20 to:560];

    [bezierPath moveToPoint: CGPointMake(370, y)];
    [bezierPath addCurveToPoint: CGPointMake(169.5, y) controlPoint1: CGPointMake(319.5, y) controlPoint2: CGPointMake(326.5, 453.5)];
    [bezierPath addCurveToPoint: CGPointMake(-50, y_end) controlPoint1: CGPointMake(12.5, 431.5) controlPoint2: CGPointMake(-50, y_end)];
    
    return bezierPath.CGPath;
}

//-(CGPathRef)leftRightCurveBottom {
//    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
//    
//    [bezierPath moveToPoint: CGPointMake(320.5, 470.5)];
//    [bezierPath addCurveToPoint: CGPointMake(173.5, 149.5) controlPoint1: CGPointMake(320.5, 470.5) controlPoint2: CGPointMake(257.5, 94.5)];
//    [bezierPath addCurveToPoint: CGPointMake(1.5, 309.5) controlPoint1: CGPointMake(89.5, 204.5) controlPoint2: CGPointMake(1.5, 309.5)];
//    
//    return bezierPath.CGPath;
//}

-(CGPathRef)leftRightCurveBottom {
    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
    
    int y = [self getRandomNumberBetween:20 to:560];
    int y_end = [self getRandomNumberBetween:20 to:560];
    
    [bezierPath moveToPoint: CGPointMake(370, y)];
    [bezierPath addCurveToPoint: CGPointMake(y, 149.5) controlPoint1: CGPointMake(320.5, y) controlPoint2: CGPointMake(257.5, y)];
    [bezierPath addCurveToPoint: CGPointMake(-50, y_end) controlPoint1: CGPointMake(89.5, 204.5) controlPoint2: CGPointMake(-50, y_end)];
    
    return bezierPath.CGPath;
}

- (void) hpBarSize{
    int diff = 100 - healthPoints;
    float newPosition = 0 - (3.2 * diff);
    _hpBar.position = CGPointMake(newPosition, 568);
    
    if (healthPoints >= 75) {
        _hpBar.color = [UIColor greenColor];
    } else if (healthPoints <= 75 && healthPoints >=50) {
        _hpBar.color = [UIColor orangeColor];
    } else {
        _hpBar.color = [UIColor redColor];
    }
}

-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}

@end
