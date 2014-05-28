//
//  ggbgGameOverScene.m
//  GGop-BGop
//
//  Created by Eugen Waldschmidt on 23.05.14.
//  Copyright (c) 2014 Zeotyn. All rights reserved.
//

#import "ggbgGameOverScene.h"
#import "ggbgGameScene.h"
#import "ggbgStartGame.h"

@implementation ggbgGameOverScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //adding the background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:background];
        
        NSString * message = @"Game Over";
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        NSString * retrymessage = @"Replay Game";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blackColor];
        retryButton.position = CGPointMake(self.size.width/2, 50);
        retryButton.name = @"retry";
        [self addChild:retryButton];
        
        NSString * homeMessage = @"Home";
        SKLabelNode *homeButtom = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        homeButtom.text = homeMessage;
        homeButtom.fontColor = [SKColor blackColor];
        homeButtom.position = CGPointMake(self.size.width/2, 150);
        homeButtom.name = @"home";
        [self addChild:homeButtom];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location]; //1
    
    if ([node.name isEqualToString:@"retry"]) { //2
        
        //3
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        ggbgGameScene * scene = [ggbgGameScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
    
    if ([node.name isEqualToString:@"home"]) { //2
        
        //3
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        ggbgStartGame * scene = [ggbgStartGame sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
}

@end
