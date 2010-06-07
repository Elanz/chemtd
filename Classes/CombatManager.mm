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
#import "CreepSpawner.h"

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
    if ([tower.shotParticleFileName isEqualToString:Effect_None])
    {
        ShotContainer * newContainer = [[ShotContainer alloc] init];
        newContainer.tower = tower;
        newContainer.creep = creep;
        newContainer.emitter = nil;
        [self shotFinishedCallback:nil data:newContainer];
    }
    else 
    {
        CCParticleSystem * emitter = [CCPointParticleSystem particleWithFile:tower.shotParticleFileName];
        emitter.position = [tower getTowerPosition];
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
    }
}

- (void) shotFinishedCallback:(id)sender data:(void*)data
{
    ShotContainer * theContainer = reinterpret_cast<ShotContainer *>(data);
    if (theContainer.emitter)
    {
        [gameField removeChild:theContainer.emitter cleanup:YES];
    }
    //[theContainer.emitter stopSystem];
    
    int damage = theContainer.tower.minDamage + arc4random() % theContainer.tower.maxDamage;
    [theContainer.creep shoot:damage];
    
    CCParticleSystem * system;
    
    switch (theContainer.tower.effectType) {
        case TowerEffectType_SplashHuge:
            [self handleHugeExplosion:theContainer];
            break;
        case TowerEffectType_Burn:
            [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            break;
        case TowerEffectType_Poison:
            [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            break;
        case TowerEffectType_Nitrous:
            [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            break;
        case TowerEffectType_Sleep:
            if (1 + arc4random() % 4 == 1)
            {
                [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            }
            break;
        case TowerEffectType_AOETrap:
            [gameField addEffect:[[AOESpriteTrapEffect alloc] initWithSourceField:theContainer.tower target:gameField position:theContainer.creep.creepSprite.position]];
            break;
        case TowerEffectType_ExplodeOnImpact:
            system = [CCPointParticleSystem particleWithFile:theContainer.tower.hitParticleFileName];
            system.position = ccp(creepSize/2, creepSize/2);
            system.autoRemoveOnFinish = YES;
            [theContainer.creep.creepSprite addChild:system z:1];
        default:
            break;
    }
}

- (void) handleHugeExplosion:(ShotContainer*)container
{
    CCPointParticleSystem * system = [CCPointParticleSystem particleWithFile:Effect_BigExplosionRing];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    system = [CCPointParticleSystem particleWithFile:Effect_BigExplosionDebris];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    for (Creep * foundCreep in gameField.mainSpawner.creeps)
    {
        float thisdistance = [gameField distanceBetweenPointsA:container.creep.creepSprite.position B:foundCreep.creepSprite.position];
        if (thisdistance < 150.0)
        {
            CCPointParticleSystem * explodeSystem = [CCPointParticleSystem particleWithFile:Effect_SingleTargetExplosionPepper];
            explodeSystem.position = foundCreep.creepSprite.position;
            explodeSystem.autoRemoveOnFinish = YES;
            [gameField addChild:explodeSystem z:5];
            int damage = container.tower.minDamage + arc4random() % container.tower.maxDamage;
            [foundCreep shoot:damage];
        }
    }
}

@end
