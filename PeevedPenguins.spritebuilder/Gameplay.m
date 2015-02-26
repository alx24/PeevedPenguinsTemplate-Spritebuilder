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
    CCPhysicsJoint *_mouseJoint;
    CCNode* _catapultArm;
    CCNode* _levelNode;
    CCNode* _nodeScrol;
    CCNode* _pullbackNode;
    CCNode* _mouseJointNode;
    
}

- (void)didLoadFromCCB
{
    
    self.userInteractionEnabled = YES;
    
    CCScene* level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    
    _physicsNode.debugDraw = YES;
    _pullbackNode.physicsBody.collisionMask = @[];
    _mouseJointNode.physicsBody.collisionMask = @[];
}

-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:_nodeScrol];
    
    // start catapult dragging when a touch inside of the catapult arm occurs
    if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation))
    {
        // move the mouseJointNode to the touch position
        _mouseJointNode.position = touchLocation;
        
        // setup a spring joint between the mouseJointNode and the catapultArm
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:
                       _mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0)
                        anchorB:ccp(34, 138) restLength:0.f stiffness:3000.f damping:150.f];
    
   }

}

-(void)touchMoved:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    // whenever touches move, update the position of the mouseJointNode to the touch position
    CGPoint touchLocation = [touch locationInNode: _nodeScrol];
    _mouseJointNode.position = touchLocation;
}


-(void)releaseCatapult
{
    if (_mouseJoint != nil);
    {
        [_mouseJoint invalidate];
        _mouseJoint = nil;
    }
    
    
}


-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches end, meaning the user releases their finger, release the catapult
    [self releaseCatapult];
}

-(void) touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    // when touches are cancelled, meaning the user drags their finger off the screen or onto something else, release the catapult
    [self releaseCatapult];
}

// metado para lanca peguin da cataputa
//-(void)luachPenguin
//{
//    // carregando peguin definido no spritebuilde
//    CCNode* penguin = [CCBReader load:@"Penguins"];
//    
//    penguin.position = ccpAdd(_catapultArm.position, ccp(16,50));
//    
//    [_physicsNode addChild:penguin];
//    
//    CGPoint launchDirection = ccp(1, 0);
//    CGPoint force = ccpMult(launchDirection, 8000);
//    [penguin.physicsBody applyForce:force];
//    self.position = ccp(0,0);
//    CCActionFollow *folow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
//    [_nodeScrol runAction:folow];
//    
//}

-(void)retry
{
    [[CCDirector sharedDirector ] replaceScene:[CCBReader loadAsScene:@"GamePlay"]];
}



@end
