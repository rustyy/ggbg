//
//  ggbgStartGame.h
//  GGop-BGop
//
//  Created by Eugen Waldschmidt on 26.05.14.
//  Copyright (c) 2014 Zeotyn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//static const uint8_t crosshairCategory = 1;
//static const uint8_t gopCategory = 2;
@interface ggbgStartGame : SKScene {
    CGRect screenRect;
    CGFloat screenHeight;
}
@property SKSpriteNode *gop;
@end
