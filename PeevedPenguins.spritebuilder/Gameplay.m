//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Macbook White on 24/02/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "CCPhysics+ObjectiveChipmunk.h"

@implementation Gameplay
{
    CCPhysicsNode* _physicsNode;
    CCPhysicsJoint *_mouseJoint;
    CCPhysicsJoint *_penguinCatapultJoint;
    CCNode* _catapultArm;
    CCNode* _levelNode;
    CCNode* _nodeScrol;
    CCNode* _pullbackNode;
    CCNode* _mouseJointNode;
    CCNode *_currentPenguin;
   
    
}



- (void)didLoadFromCCB
{
    
    self.userInteractionEnabled = YES;
    
    CCScene* level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    
   // _physicsNode.debugDraw = YES;
    _pullbackNode.physicsBody.collisionMask = @[];
    _mouseJointNode.physicsBody.collisionMask = @[];
    _physicsNode.collisionDelegate = self;
    
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
        
        // create a penguin from the ccb-file
        _currentPenguin = [CCBReader load:@"Penguins"];
        // initially position it on the scoop. 34,138 is the position in the node space of the _catapultArm
        CGPoint penguinPosition = [_catapultArm convertToWorldSpace:ccp(34, 138)];
        // transform the world position to the node space to which the penguin will be added (_physicsNode)
        _currentPenguin.position = [_physicsNode convertToNodeSpace:penguinPosition];
        // add it to the physics world
        [_physicsNode addChild:_currentPenguin];
        // we don't want the penguin to rotate in the scoop
        _currentPenguin.physicsBody.allowsRotation = FALSE;
        
        // create a joint to keep the penguin fixed to the scoop until the catapult is released
        _penguinCatapultJoint = [CCPhysicsJoint connectedPivotJointWithBodyA:_currentPenguin.physicsBody bodyB:_catapultArm.physicsBody anchorA:_currentPenguin.anchorPointInPoints];
    
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
        
        // releases the joint and lets the penguin fly
        [_penguinCatapultJoint invalidate];
        _penguinCatapultJoint = nil;
        
        // after snapping rotation is fine
        _currentPenguin.physicsBody.allowsRotation = TRUE;
        
        // follow the flying penguin
        CCActionFollow *follow = [CCActionFollow actionWithTarget:_currentPenguin worldBoundary:self.boundingBox];
        [_nodeScrol runAction:follow];
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


-(void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair Seal:(CCNode *)nodeA wildcard:(CCNode *)nodeB
{
    
    float energy = [pair totalKineticEnergy];
    
    // if energy is large enough, remove the seal
    if (energy > 5000.f) {
        [[_physicsNode space] addPostStepBlock:^{
            [self sealRemoved:nodeA];
        } key:nodeA];
    }
    
}


- (void)sealRemoved:(CCNode *)seal {
    
    
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"SealExplode"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion.position = seal.position;
    // add the particle effect to the same node the seal is on
    [seal.parent addChild:explosion];
    
    // finally, remove the destroyed seal
    [seal removeFromParent];
    
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
