//
//  ggbgStartGame.m
//  GGop-BGop
//
//  Created by Eugen Waldschmidt on 26.05.14.
//  Copyright (c) 2014 Zeotyn. All rights reserved.
//

#import "ggbgStartGame.h"
#import "ggbgGameScene.h"

@implementation ggbgStartGame

-(id) initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //adding the background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        //background.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:background];
        
        //adding the Logo
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"logo"];
        logo.size = CGSizeMake(315, 220);
        logo.zPosition = 6;
        logo.position = CGPointMake(self.size.width/2, 370);
        [self addChild:logo];
        
        //adding the Startbutton
        SKSpriteNode *startButton = [SKSpriteNode spriteNodeWithImageNamed:@"start"];
        startButton.size = CGSizeMake(200, 66);
        startButton.zPosition = 6;
        startButton.position = CGPointMake(self.size.width/2, 190);
        startButton.name = @"start";
        [self addChild:startButton];
        
        //schedule enemies
        SKAction *wait = [SKAction waitForDuration:1.5];
        SKAction *callGop = [SKAction runBlock:^{
            [self BadGopsAndGoodGops];
        }];
        SKAction *updateGops = [SKAction sequence:@[wait,callGop]];
        [self runAction:[SKAction repeatActionForever:updateGops]];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location]; //1
    
    if ([node.name isEqualToString:@"start"]) { //2
        
        //3
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        ggbgGameScene * scene = [ggbgGameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
}

-(void)BadGopsAndGoodGops{
    //not always come
    int GoOrNot = [self getRandomNumberBetween:0 to:1];
    
    if(GoOrNot == 1){
        
        SKSpriteNode *goodGop;
        SKSpriteNode *badGop;
        
        
        int randomGop = [self getRandomNumberBetween:0 to:100];
        if(randomGop < 50) {
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
        
        int randomPosition = [self getRandomNumberBetween:1 to:2];
        
        switch (randomPosition) {
            case 1:
                _gop.scale = 0.5;
                cgpath = [self topBottom];
                followPath = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:15];
                scale = [SKAction scaleTo:0.1 duration:15];
                break;
                
            case 2:
                _gop.scale = 0.1;
                cgpath = [self bottomTop];
                followPath = [SKAction followPath:cgpath asOffset:NO orientToPath:NO duration:15];
                scale = [SKAction scaleTo:0.5 duration:15];
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

-(CGPathRef)topBottom {
    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(69.5, -50)];
    [bezierPath addCurveToPoint: CGPointMake(69.5, 206.5) controlPoint1: CGPointMake(69.5, -0.5) controlPoint2: CGPointMake(9.5, 177.5)];
    [bezierPath addCurveToPoint: CGPointMake(238.5, 349.5) controlPoint1: CGPointMake(129.5, 235.5) controlPoint2: CGPointMake(259.5, 291.5)];
    [bezierPath addCurveToPoint: CGPointMake(96.5, 610) controlPoint1: CGPointMake(217.5, 407.5) controlPoint2: CGPointMake(96.5, 610)];
    
    return bezierPath.CGPath;
}

-(CGPathRef)bottomTop {
    UIBezierPath *bezierPath =  [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(255.5, 610)];
    [bezierPath addCurveToPoint: CGPointMake(94.5, 366.5) controlPoint1: CGPointMake(255.5, 567.5) controlPoint2: CGPointMake(57.5, 459.5)];
    [bezierPath addCurveToPoint: CGPointMake(218.5, 193.5) controlPoint1: CGPointMake(131.5, 273.5) controlPoint2: CGPointMake(254.5, 249.5)];
    [bezierPath addCurveToPoint: CGPointMake(77.5, -50) controlPoint1: CGPointMake(182.5, 137.5) controlPoint2: CGPointMake(77.5, -50)];
    
    return bezierPath.CGPath;
}


-(int)getRandomNumberBetween:(int)from to:(int)to {
    
    return (int)from + arc4random() % (to-from+1);
}


@end
