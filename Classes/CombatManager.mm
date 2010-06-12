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

@implementation ParticleContainer

@synthesize system;
@synthesize inuse;
@synthesize checkoutTime;

@end


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
        [self populateParticleLibrary];
    }
    return self;
}

-(void) populateParticleLibrary
{
    particleLibrary = [[NSMutableDictionary alloc] init];
    
    for (int i = 1; i < 31; i++)
    {
        [particleLibrary setObject:[self getParticleArrayForKey:i] forKey:[NSNumber numberWithInt:i]];
        particleLibraryLock = [[NSLock alloc] init];
    }
}

-(NSMutableArray*) getParticleArrayForKey:(int)key
{
    NSMutableArray * output = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
    {
        ParticleContainer * container = [[ParticleContainer alloc] init];
        switch (key) {
            case iEffect_WaterExplosion: container.system = [CCPointParticleSystem particleWithFile:@"waterexplosion.plist"]; break;
            case iEffect_SingleTargetOxygenShot: container.system = [CCPointParticleSystem particleWithFile:@"oxygenshot.plist"]; break;
            case iEffect_SingleTargetOxygenHit: container.system = [CCPointParticleSystem particleWithFile:@"oxygenhit.plist"]; break;
            case iEffect_SingleTargetSodiumShot: container.system = [CCPointParticleSystem particleWithFile:@"sodiumshot.plist"]; break;
            case iEffect_SingleTargetSodiumHit: container.system = [CCPointParticleSystem particleWithFile:@"sodiumhit.plist"]; break;
            case iEffect_SingleTargetHydrogenShot: container.system = [CCPointParticleSystem particleWithFile:@"hydrogenshot.plist"]; break;
            case iEffect_SingleTargetHydrogenHit: container.system = [CCPointParticleSystem particleWithFile:@"hydrogenhit.plist"]; break;
            case iEffect_SingleTargetNitrogenShot: container.system = [CCPointParticleSystem particleWithFile:@"nitrogenshot.plist"]; break;
            case iEffect_SingleTargetNitrogenHit: container.system = [CCPointParticleSystem particleWithFile:@"nitrogenhit.plist"]; break;
            case iEffect_SingleTargetChlorineShot: container.system = [CCPointParticleSystem particleWithFile:@"chlorineshot.plist"]; break;
            case iEffect_SingleTargetChlorineHit: container.system = [CCPointParticleSystem particleWithFile:@"chlorinehit.plist"]; break;
            case iEffect_SingleTargetCarbonShot: container.system = [CCPointParticleSystem particleWithFile:@"carbonshot.plist"]; break;
            case iEffect_SingleTargetCarbonHit: container.system = [CCPointParticleSystem particleWithFile:@"carbonhit.plist"]; break;
            case iEffect_SingleTargetFireball: container.system = [CCPointParticleSystem particleWithFile:@"cometshot.plist"]; break;
            case iEffect_SingleTargetExplosion: container.system = [CCPointParticleSystem particleWithFile:@"explosion.plist"]; break;
            case iEffect_SingleTargetFireballGreen: container.system = [CCPointParticleSystem particleWithFile:@"cometshotgreen.plist"]; break;
            case iEffect_SingleTargetExplosionGreen: container.system = [CCPointParticleSystem particleWithFile:@"explosiongreen.plist"]; break;
            case iEffect_SingleTargetWhiteSmoke: container.system = [CCPointParticleSystem particleWithFile:@"whitesmoke.plist"]; break;
            case iEffect_SingleTargetBlackSmoke: container.system = [CCPointParticleSystem particleWithFile:@"blacksmoke.plist"]; break;
            case iEffect_GreenBubbles: container.system = [CCPointParticleSystem particleWithFile:@"greenbubbles.plist"]; break;
            case iEffect_SingleTargetFireballPepper: container.system = [CCPointParticleSystem particleWithFile:@"peppershot.plist"]; break;
            case iEffect_SingleTargetExplosionPepper: container.system = [CCPointParticleSystem particleWithFile:@"pepperexplosion.plist"]; break;
            case iEffect_GrayCloud: container.system = [CCPointParticleSystem particleWithFile:@"graycloud.plist"]; break;
            case iEffect_Sleep: container.system = [CCPointParticleSystem particleWithFile:@"sleep.plist"]; break;
            case iEffect_NitrousShot: container.system = [CCPointParticleSystem particleWithFile:@"nitrousshot.plist"]; break;
            case iEffect_NitrousHit: container.system = [CCPointParticleSystem particleWithFile:@"nitroushit.plist"]; break;
            case iEffect_BigExplosionRing: container.system = [CCPointParticleSystem particleWithFile:@"bigexplosionring.plist"]; break;
            case iEffect_BigExplosionDebris: container.system = [CCPointParticleSystem particleWithFile:@"bigexplosiondebris.plist"]; break;
            case iEffect_SingleTargetGreenSmoke: container.system = [CCPointParticleSystem particleWithFile:@"greensmoke.plist"]; break;
            case iEffect_SingleTargetOrangeSmoke: container.system = [CCPointParticleSystem particleWithFile:@"orangesmoke.plist"]; break;            
            default:
                break;
        }
        container.system.autoRemoveOnFinish = YES;
        container.inuse = NO;
        [output addObject:container];
    }
    return output;
}

static int checkedout;

- (void) tick:(double)elapsed
{
    elapsedTime += elapsed;
}

-(CCPointParticleSystem*) getParticleSystemForKey:(int)key
{
    CCPointParticleSystem * output = nil;
    printf("particle request: ");
    [particleLibraryLock lock];
    for (ParticleContainer * container in (NSMutableArray*)[particleLibrary objectForKey:[NSNumber numberWithInt:key]])
    {
        if (!container.inuse) {
            container.inuse = YES;
            output = container.system;
            checkedout ++;
            printf("ok checkedout = %d", checkedout);
            break;
        }
    }
    [particleLibraryLock unlock];
    printf("\n");
    return output;
}

-(void) releaseParticleSystem:(CCParticleSystem*)system
{
    printf("particle release = ");
    for (int i = 1; i < 31; i++)
    {
        [particleLibraryLock lock];
        for (ParticleContainer * container in (NSMutableArray*)[particleLibrary objectForKey:[NSNumber numberWithInt:i]])
        {
            if (container.system == system)
            {
                checkedout --;
                printf("checkedout = %d", checkedout);
                [container.system resetSystem];
                [container.system stopSystem];
                container.inuse = NO;
                break;
            }
        }
        [particleLibraryLock unlock];
    }
    printf("\n");
}

-(void) shootWithTower:(BaseTower*)tower creep:(Creep*)creep
{
    if (tower.shotParticleKey == iEffect_None)
    {
        ShotContainer * newContainer = [[ShotContainer alloc] init];
        newContainer.tower = tower;
        newContainer.creep = creep;
        newContainer.emitter = nil;
        [self shotFinishedCallback:nil data:newContainer];
    }
    else 
    {
        CCParticleSystem * emitter = [self getParticleSystemForKey:tower.shotParticleKey];
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
        emitter.duration = .5;
        emitter.autoRemoveOnFinish = YES;
        [gameField addChild:emitter z:5];        
    }
}

- (void) shotFinishedCallback:(id)sender data:(void*)data
{
    ShotContainer * theContainer = reinterpret_cast<ShotContainer *>(data);
    
    int damage = theContainer.tower.minDamage + arc4random() % theContainer.tower.maxDamage;
    [theContainer.creep shoot:damage];
    
    CCParticleSystem * system;
    
    switch (theContainer.tower.effectType) {
        case TowerEffectType_SplashHuge:
            [self handleHugeExplosion:theContainer];
            break;
        case TowerEffectType_SplashBig:
            [self handleBigExplosion:theContainer];
            break;
        case TowerEffectType_WaterSplash:
            [self handleWaterExplosion:theContainer];
            break;
        case TowerEffectType_Burn:
            [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            break;
        case TowerEffectType_Rubber:
            [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            break;
        case TowerEffectType_SlowPoison:
            [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            break;
        case TowerEffectType_Poison:
            [theContainer.creep addEffect:theContainer.tower.effectType sourceTower:theContainer.tower];
            break;
        case TowerEffectType_Ethanol:
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
            system = [self getParticleSystemForKey:theContainer.tower.hitParticleKey];
            system.position = ccp(creepSize/2, -(creepSize/2));
            system.autoRemoveOnFinish = YES;
            [theContainer.creep.hpbar addChild:system z:1];
        default:
            break;
    }
}

- (void) handleWaterExplosion:(ShotContainer*)container
{
    CCPointParticleSystem * system = [self getParticleSystemForKey:iEffect_WaterExplosion];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    for (Creep * foundCreep in gameField.mainSpawner.creeps)
    {
        float thisdistance = [gameField distanceBetweenPointsA:container.creep.creepSprite.position B:foundCreep.creepSprite.position];
        if (thisdistance < 100.0)
        {
            CCPointParticleSystem * explodeSystem = [self getParticleSystemForKey:iEffect_SingleTargetOxygenHit];
            explodeSystem.position = foundCreep.creepSprite.position;
            explodeSystem.autoRemoveOnFinish = YES;
            [gameField addChild:explodeSystem z:5];
            int damage = container.tower.minDamage + arc4random() % container.tower.maxDamage;
            [foundCreep shoot:damage];
        }
    }
}

- (void) handleBigExplosion:(ShotContainer*)container
{
    CCPointParticleSystem * system = [self getParticleSystemForKey:iEffect_BigExplosionRing];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    for (Creep * foundCreep in gameField.mainSpawner.creeps)
    {
        float thisdistance = [gameField distanceBetweenPointsA:container.creep.creepSprite.position B:foundCreep.creepSprite.position];
        if (thisdistance < 150.0)
        {
            CCPointParticleSystem * explodeSystem = [self getParticleSystemForKey:iEffect_SingleTargetExplosion];
            explodeSystem.position = foundCreep.creepSprite.position;
            explodeSystem.autoRemoveOnFinish = YES;
            [gameField addChild:explodeSystem z:5];
            int damage = container.tower.minDamage + arc4random() % container.tower.maxDamage;
            [foundCreep shoot:damage];
        }
    }
}

- (void) handleHugeExplosion:(ShotContainer*)container
{
    CCPointParticleSystem * system = [self getParticleSystemForKey:iEffect_BigExplosionRing];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    system = [self getParticleSystemForKey:iEffect_BigExplosionDebris];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    for (Creep * foundCreep in gameField.mainSpawner.creeps)
    {
        float thisdistance = [gameField distanceBetweenPointsA:container.creep.creepSprite.position B:foundCreep.creepSprite.position];
        if (thisdistance < 200.0)
        {
            CCPointParticleSystem * explodeSystem = [self getParticleSystemForKey:iEffect_SingleTargetExplosionPepper];
            explodeSystem.position = foundCreep.creepSprite.position;
            explodeSystem.autoRemoveOnFinish = YES;
            [gameField addChild:explodeSystem z:5];
            int damage = container.tower.minDamage + arc4random() % container.tower.maxDamage;
            [foundCreep shoot:damage];
        }
    }
}

@end
