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
        
        
        NSString * playerscoremsg = [NSString stringWithFormat:@"Player Score: %ld",(long)player_score];
        
        SKLabelNode *playerscore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        playerscore.text = playerscoremsg;
        playerscore.fontColor = [SKColor blackColor];
        playerscore.position = CGPointMake(self.size.width/2, 250);
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
            
            SKLabelNode *highscore = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"]; //Displaying highest score label
            highscore.text = highscoremsg;
            highscore.fontColor = [SKColor greenColor];
            highscore.position = CGPointMake(self.size.width/2, 200);
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
