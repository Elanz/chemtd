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
#import "BaseTower.h"
#import "Effects.h"

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
    //emitter.autoRemoveOnFinish = YES;
    //emitter.duration = 0.5;
    
    ShotContainer * newContainer = [[ShotContainer alloc] init];
    newContainer.tower = tower;
    newContainer.creep = creep;
    newContainer.emitter = emitter;
    
    id action = [CCSequence actions:
                 [CCMoveTo actionWithDuration: .5 position:[creep getNextWaypoint]],
                 [CCCallFuncND actionWithTarget:self selector:@selector(shotFinishedCallback:data:) data:(void*)newContainer],
                 nil];
    
    [emitter runAction:action];
    [gameField addChild:emitter z:5];
    //[creep shoot:damage];
}

- (void) shotFinishedCallback:(id)sender data:(void*)data
{
    ShotContainer * theContainer = reinterpret_cast<ShotContainer *>(data);
    [gameField removeChild:theContainer.emitter cleanup:YES];
    //[theContainer.emitter stopSystem];
    
    int damage = theContainer.tower.minDamage + arc4random() % theContainer.tower.maxDamage;
    [theContainer.creep shoot:damage];
    
    CCParticleSystem * system;
    
    switch (theContainer.tower.effectType) {
        case TowerEffectType_Burn:
            [theContainer.creep addEffect:[[BurnEffect alloc] initWithSource:theContainer.tower target:theContainer.creep]];
            break;
        case TowerEffectType_ExplodeOnImpact:
            system = [CCPointParticleSystem particleWithFile:Effect_SingleTargetExplosion];
            system.position = theContainer.creep.creepSprite.position;
            system.autoRemoveOnFinish = YES;
            [gameField addChild:system z:1];
        default:
            break;
    }
}

@end
