//
//  CombatManager.m
//  ChemTD
//
//  Created by Eric Lanz on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CombatManager.h"
#import "Towers.h"
#import "Creep.h"



@implementation ShotContainer

@synthesize tower;
@synthesize creep;
@synthesize emitter;

@end


@implementation CombatManager

-(id) initWithGameField:(GameFieldScene *)theGameField
{
	if( (self=[super init] )) 
    {
        gameField = theGameField;
    }
    return self;
}

-(void) shootWithTower:(BaseTower*)tower creep:(Creep*)creep
{
    CCParticleSystem * emitter = [CCPointParticleSystem particleWithFile:Effect_SingleTargetFireball];
    emitter.position = [tower getTowerPosition];
    emitter.autoRemoveOnFinish = YES;
    
    ShotContainer * newContainer = [[ShotContainer alloc] init];
    newContainer.tower = tower;
    newContainer.creep = creep;
    newContainer.emitter = emitter;
    
    id action = [CCSequence actions:
                 [CCMoveTo actionWithDuration: .5 position:[creep getNextWaypoint]],
                 [CCCallFuncND actionWithTarget:self selector:@selector(shotFinishedCallback:data:) data:(void*)newContainer],
                 nil];
    
    [emitter runAction:action];
    [gameField addChild:emitter z:2];
    //[creep shoot:damage];
}

- (void) shotFinishedCallback:(id)sender data:(void*)data
{
    ShotContainer * theContainer = reinterpret_cast<ShotContainer *>(data);
    [gameField removeChild:theContainer.emitter cleanup:NO];
    //[theContainer.emitter stopSystem];
    
    int damage = theContainer.tower.minDamage + arc4random() % theContainer.tower.maxDamage;
    [gameField updateDPS:damage];
    [theContainer.creep shoot:damage];
    
    CCParticleSystem * explosion = [CCPointParticleSystem particleWithFile:Effect_SingleTargetExplosion];
    explosion.position = theContainer.creep.creepSprite.position;
    explosion.autoRemoveOnFinish = YES;
    [gameField addChild:explosion z:1];
}

@end
