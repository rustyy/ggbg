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

-(id)initWithSize:(CGSize)size score:(NSInteger)player_score {
    if (self = [super initWithSize:size]) {
        //self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        //adding the background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:background];
        
        //adding the Logo
        SKSpriteNode *logo = [SKSpriteNode spriteNodeWithImageNamed:@"gameover"];
        logo.size = CGSizeMake(315, 300);
        logo.zPosition = 6;
        logo.position = CGPointMake(self.size.width/2, 370);
        [self addChild:logo];
        
        SKSpriteNode *retryButton = [SKSpriteNode spriteNodeWithImageNamed:@"replay"];
        retryButton.size = CGSizeMake(200, 66);
        retryButton.zPosition = 6;
        retryButton.position = CGPointMake(self.size.width/2, 130);
        retryButton.name = @"retry";
        [self addChild:retryButton];
        
        //adding the Startbutton
        SKSpriteNode *homeButton = [SKSpriteNode spriteNodeWithImageNamed:@"home"];
        homeButton.size = CGSizeMake(200, 66);
        homeButton.zPosition = 6;
        homeButton.position = CGPointMake(self.size.width/2, 60);
        homeButton.name = @"home";
        [self addChild:homeButton];
        
        
        NSString * playerscoremsg = [NSString stringWithFormat:@"Player Score: %ld",(long)player_score];
        
        SKLabelNode *playerscore = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
        playerscore.text = playerscoremsg;
        playerscore.fontColor = [SKColor blackColor];
        playerscore.position = CGPointMake(self.size.width/2, 180);
        playerscore.name = @"Player Score";
        [playerscore setScale:.5];
        
        [self addChild:playerscore];
        
        UIDevice * currentDevice = [UIDevice currentDevice];
        NSString *deviceIDString = [currentDevice.identifierForVendor UUIDString]; //getting unique id for the user
        
        NSNumber *playerScoreNum = [NSNumber numberWithInt:player_score]; //converting score into NSNumber format in which Parse expect the score
        
        PFQuery *query = [PFQuery queryWithClassName:@"PlayerScore"]; //creating query for Parse
        [query whereKey:@"user_id" equalTo:deviceIDString];
        [query orderByDescending:@"score"]; //Sorting the score so we have highest score on the top
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *scoreArray, NSError *error) {
            
            NSNumber* hightestScore = [scoreArray.firstObject objectForKey:@"score"]; //highest score is first object
            NSLog(@"highest score %@ devise %@",hightestScore, deviceIDString);
            
            if (hightestScore < playerScoreNum){
                hightestScore = playerScoreNum; //if highest score so far is smaller than current score, display current score
            }
            NSString * highscoremsg = [NSString stringWithFormat:@"Highest Score: %@",hightestScore];
            
            SKLabelNode *highscore = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"]; //Displaying highest score label
            highscore.text = highscoremsg;
            highscore.fontColor = [SKColor greenColor];
            highscore.position = CGPointMake(self.size.width/2, 205);
            [highscore setScale:.5];
            [self addChild:highscore];
            
        }];
        
        PFObject *scoreObject = [PFObject objectWithClassName:@"PlayerScore"];
        [scoreObject setObject:deviceIDString forKey:@"user_id"]; //user's unique id
        
        [scoreObject setObject:playerScoreNum forKey:@"score"]; //user's score
        
        [scoreObject saveInBackground]; //saving in background, so our application is not halted while saving the score.
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
