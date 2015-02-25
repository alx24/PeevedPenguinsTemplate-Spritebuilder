//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Macbook White on 24/02/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay
{
    CCPhysicsNode* _physicsNode;
    CCNode* _catapultArm;
    
}

- (void)didLoadFromCCB
{
    
    self.userInteractionEnabled = YES;
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    [self luachPenguin];
    
}

// metado para lanca peguin da cataputa
-(void)luachPenguin
{
    // carregando peguin definido no spritebuilde
    CCNode* penguin = [CCBReader load:@"Pinguim"];
    
    penguin.position = ccpAdd(_catapultArm.position, ccp(16,50));
    
    [_physicsNode addChild:penguin];
    
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
}




@end
