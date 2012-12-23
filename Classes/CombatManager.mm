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
        //[self populateParticleLibrary];
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
            case iEffect_WaterExplosion: container.system = [CCParticleSystemQuad particleWithFile:@"waterexplosion.plist"]; break;
            case iEffect_SingleTargetOxygenShot: container.system = [CCParticleSystemQuad particleWithFile:@"oxygenshot.plist"]; break;
            case iEffect_SingleTargetOxygenHit: container.system = [CCParticleSystemQuad particleWithFile:@"oxygenhit.plist"]; break;
            case iEffect_SingleTargetSodiumShot: container.system = [CCParticleSystemQuad particleWithFile:@"sodiumshot.plist"]; break;
            case iEffect_SingleTargetSodiumHit: container.system = [CCParticleSystemQuad particleWithFile:@"sodiumhit.plist"]; break;
            case iEffect_SingleTargetHydrogenShot: container.system = [CCParticleSystemQuad particleWithFile:@"hydrogenshot.plist"]; break;
            case iEffect_SingleTargetHydrogenHit: container.system = [CCParticleSystemQuad particleWithFile:@"hydrogenhit.plist"]; break;
            case iEffect_SingleTargetNitrogenShot: container.system = [CCParticleSystemQuad particleWithFile:@"nitrogenshot.plist"]; break;
            case iEffect_SingleTargetNitrogenHit: container.system = [CCParticleSystemQuad particleWithFile:@"nitrogenhit.plist"]; break;
            case iEffect_SingleTargetChlorineShot: container.system = [CCParticleSystemQuad particleWithFile:@"chlorineshot.plist"]; break;
            case iEffect_SingleTargetChlorineHit: container.system = [CCParticleSystemQuad particleWithFile:@"chlorinehit.plist"]; break;
            case iEffect_SingleTargetCarbonShot: container.system = [CCParticleSystemQuad particleWithFile:@"carbonshot.plist"]; break;
            case iEffect_SingleTargetCarbonHit: container.system = [CCParticleSystemQuad particleWithFile:@"carbonhit.plist"]; break;
            case iEffect_SingleTargetFireball: container.system = [CCParticleSystemQuad particleWithFile:@"cometshot.plist"]; break;
            case iEffect_SingleTargetExplosion: container.system = [CCParticleSystemQuad particleWithFile:@"explosion.plist"]; break;
            case iEffect_SingleTargetFireballGreen: container.system = [CCParticleSystemQuad particleWithFile:@"cometshotgreen.plist"]; break;
            case iEffect_SingleTargetExplosionGreen: container.system = [CCParticleSystemQuad particleWithFile:@"explosiongreen.plist"]; break;
            case iEffect_SingleTargetWhiteSmoke: container.system = [CCParticleSystemQuad particleWithFile:@"whitesmoke.plist"]; break;
            case iEffect_SingleTargetBlackSmoke: container.system = [CCParticleSystemQuad particleWithFile:@"blacksmoke.plist"]; break;
            case iEffect_GreenBubbles: container.system = [CCParticleSystemQuad particleWithFile:@"greenbubbles.plist"]; break;
            case iEffect_SingleTargetFireballPepper: container.system = [CCParticleSystemQuad particleWithFile:@"peppershot.plist"]; break;
            case iEffect_SingleTargetExplosionPepper: container.system = [CCParticleSystemQuad particleWithFile:@"pepperexplosion.plist"]; break;
            case iEffect_GrayCloud: container.system = [CCParticleSystemQuad particleWithFile:@"graycloud.plist"]; break;
            case iEffect_Sleep: container.system = [CCParticleSystemQuad particleWithFile:@"sleep.plist"]; break;
            case iEffect_NitrousShot: container.system = [CCParticleSystemQuad particleWithFile:@"nitrousshot.plist"]; break;
            case iEffect_NitrousHit: container.system = [CCParticleSystemQuad particleWithFile:@"nitroushit.plist"]; break;
            case iEffect_BigExplosionRing: container.system = [CCParticleSystemQuad particleWithFile:@"bigexplosionring.plist"]; break;
            case iEffect_BigExplosionDebris: container.system = [CCParticleSystemQuad particleWithFile:@"bigexplosiondebris.plist"]; break;
            case iEffect_SingleTargetGreenSmoke: container.system = [CCParticleSystemQuad particleWithFile:@"greensmoke.plist"]; break;
            case iEffect_SingleTargetOrangeSmoke: container.system = [CCParticleSystemQuad particleWithFile:@"orangesmoke.plist"]; break;            
            default:
                break;
        }
        container.system.autoRemoveOnFinish = YES;
        [container.system resetSystem];
        [container.system stopSystem];
        container.inuse = NO;
        [output addObject:container];
    }
    return output;
}

//static int checkedout;

- (void) tick:(double)elapsed
{
   // elapsedTime += elapsed;
//    expirationCheckTimer += elapsed;
//    if (expirationCheckTimer < 1.0)
//    {
//        for (int i = 1; i < 31; i++)
//        {
//            [particleLibraryLock lock];
//            for (ParticleContainer * container in (NSMutableArray*)[particleLibrary objectForKey:[NSNumber numberWithInt:i]])
//            {
//                if (container.inuse)
//                {
//                    if (elapsedTime - container.checkoutTime > 2.0)
//                    {
//                        checkedout --;
//                        printf("autorelease checkedout = %d\n", checkedout);
//                        [container.system resetSystem];
//                        [container.system stopSystem];
//                        [container.system.parent removeChild:container.system cleanup:NO];
//                        container.checkoutTime = elapsedTime;
//                        container.inuse = NO;
//                    }
//                }
//            }
//            [particleLibraryLock unlock];
//        }
//        expirationCheckTimer = 0.0;
//    }
}

-(CCParticleSystemQuad*) getParticleSystemForKey:(int)key
{
    CCParticleSystemQuad * system = nil;
    switch (key) {
        case iEffect_WaterExplosion: system = [CCParticleSystemQuad particleWithFile:@"waterexplosion.plist"]; break;
        case iEffect_SingleTargetOxygenShot: system = [CCParticleSystemQuad particleWithFile:@"oxygenshot.plist"]; break;
        case iEffect_SingleTargetOxygenHit: system = [CCParticleSystemQuad particleWithFile:@"oxygenhit.plist"]; break;
        case iEffect_SingleTargetSodiumShot: system = [CCParticleSystemQuad particleWithFile:@"sodiumshot.plist"]; break;
        case iEffect_SingleTargetSodiumHit: system = [CCParticleSystemQuad particleWithFile:@"sodiumhit.plist"]; break;
        case iEffect_SingleTargetHydrogenShot:system = [CCParticleSystemQuad particleWithFile:@"hydrogenshot.plist"]; break;
        case iEffect_SingleTargetHydrogenHit: system = [CCParticleSystemQuad particleWithFile:@"hydrogenhit.plist"]; break;
        case iEffect_SingleTargetNitrogenShot: system = [CCParticleSystemQuad particleWithFile:@"nitrogenshot.plist"]; break;
        case iEffect_SingleTargetNitrogenHit: system = [CCParticleSystemQuad particleWithFile:@"nitrogenhit.plist"]; break;
        case iEffect_SingleTargetChlorineShot: system = [CCParticleSystemQuad particleWithFile:@"chlorineshot.plist"]; break;
        case iEffect_SingleTargetChlorineHit: system = [CCParticleSystemQuad particleWithFile:@"chlorinehit.plist"]; break;
        case iEffect_SingleTargetCarbonShot: system = [CCParticleSystemQuad particleWithFile:@"carbonshot.plist"]; break;
        case iEffect_SingleTargetCarbonHit: system = [CCParticleSystemQuad particleWithFile:@"carbonhit.plist"]; break;
        case iEffect_SingleTargetFireball: system = [CCParticleSystemQuad particleWithFile:@"cometshot.plist"]; break;
        case iEffect_SingleTargetExplosion: system = [CCParticleSystemQuad particleWithFile:@"explosion.plist"]; break;
        case iEffect_SingleTargetFireballGreen: system = [CCParticleSystemQuad particleWithFile:@"cometshotgreen.plist"]; break;
        case iEffect_SingleTargetExplosionGreen: system = [CCParticleSystemQuad particleWithFile:@"explosiongreen.plist"]; break;
        case iEffect_SingleTargetWhiteSmoke: system = [CCParticleSystemQuad particleWithFile:@"whitesmoke.plist"]; break;
        case iEffect_SingleTargetBlackSmoke: system = [CCParticleSystemQuad particleWithFile:@"blacksmoke.plist"]; break;
        case iEffect_GreenBubbles: system = [CCParticleSystemQuad particleWithFile:@"greenbubbles.plist"]; break;
        case iEffect_SingleTargetFireballPepper: system = [CCParticleSystemQuad particleWithFile:@"peppershot.plist"]; break;
        case iEffect_SingleTargetExplosionPepper: system = [CCParticleSystemQuad particleWithFile:@"pepperexplosion.plist"]; break;
        case iEffect_GrayCloud: system = [CCParticleSystemQuad particleWithFile:@"graycloud.plist"]; break;
        case iEffect_Sleep: system = [CCParticleSystemQuad particleWithFile:@"sleep.plist"]; break;
        case iEffect_NitrousShot: system = [CCParticleSystemQuad particleWithFile:@"nitrousshot.plist"]; break;
        case iEffect_NitrousHit: system = [CCParticleSystemQuad particleWithFile:@"nitroushit.plist"]; break;
        case iEffect_BigExplosionRing: system = [CCParticleSystemQuad particleWithFile:@"bigexplosionring.plist"]; break;
        case iEffect_BigExplosionDebris: system = [CCParticleSystemQuad particleWithFile:@"bigexplosiondebris.plist"]; break;
        case iEffect_SingleTargetGreenSmoke: system = [CCParticleSystemQuad particleWithFile:@"greensmoke.plist"]; break;
        case iEffect_SingleTargetOrangeSmoke: system = [CCParticleSystemQuad particleWithFile:@"orangesmoke.plist"]; break;            
        default:
            break;
    }
    
    return system;
//    CCParticleSystemQuad * output = nil;
//    [particleLibraryLock lock];
//    for (ParticleContainer * container in (NSMutableArray*)[particleLibrary objectForKey:[NSNumber numberWithInt:key]])
//    {
//        if (!container.inuse) {
//            container.inuse = YES;
//            container.checkoutTime = elapsedTime; 
//            output = container.system;
//            container.system.visible = true;
//            [container.system resetSystem];
//            checkedout ++;
//            if (output == nil)
//                printf("particle request: bad checkedout = %d\n", checkedout);
//            else
//                printf("particle request: ok checkedout = %d\n", checkedout);
//            break;
//        }
//    }
//    [particleLibraryLock unlock];
//    if (output == nil)
//        printf("particle request: bad checkedout = %d\n", checkedout);
//
//    return output;
}

-(void) releaseParticleSystem:(CCParticleSystem*)system
{
//    printf("particle release = ");
//    for (int i = 1; i < 31; i++)
//    {
//        [particleLibraryLock lock];
//        for (ParticleContainer * container in (NSMutableArray*)[particleLibrary objectForKey:[NSNumber numberWithInt:i]])
//        {
//            if (container.system == system)
//            {
//                checkedout --;
//                printf("checkedout = %d", checkedout);
//                [container.system resetSystem];
//                [container.system stopSystem];
//                container.inuse = NO;
//                break;
//            }
//        }
//        [particleLibraryLock unlock];
//    }
//    printf("\n");
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
        CCParticleSystemQuad * emitter = [self getParticleSystemForKey:tower.shotParticleKey];
        if (!emitter)
        {
            printf("zomg emitter is null\n");
        }
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
    
    CCParticleSystemQuad * system;
    
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
    CCParticleSystemQuad * system = [self getParticleSystemForKey:iEffect_WaterExplosion];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    NSMutableArray * toShoot = [NSMutableArray array];
    for (Creep * foundCreep in gameField.mainSpawner.creeps)
    {
        float thisdistance = [gameField distanceBetweenPointsA:container.creep.creepSprite.position B:foundCreep.creepSprite.position];
        if (thisdistance < 100.0)
        {
            [toShoot addObject:foundCreep];
        }
    }
    for (Creep * foundCreep in toShoot)
    {
        CCParticleSystemQuad * explodeSystem = [self getParticleSystemForKey:iEffect_SingleTargetOxygenHit];
        explodeSystem.position = foundCreep.creepSprite.position;
        explodeSystem.autoRemoveOnFinish = YES;
        [gameField addChild:explodeSystem z:5];
        int damage = container.tower.minDamage + arc4random() % container.tower.maxDamage;
        [foundCreep shoot:damage];
    }
}

- (void) handleBigExplosion:(ShotContainer*)container
{
    CCParticleSystemQuad * system = [self getParticleSystemForKey:iEffect_BigExplosionRing];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    NSMutableArray * toShoot = [NSMutableArray array];
    for (Creep * foundCreep in gameField.mainSpawner.creeps)
    {
        float thisdistance = [gameField distanceBetweenPointsA:container.creep.creepSprite.position B:foundCreep.creepSprite.position];
        if (thisdistance < 150.0)
        {
            [toShoot addObject:foundCreep];
        }
    }
    for (Creep * foundCreep in toShoot)
    {
        CCParticleSystemQuad * explodeSystem = [self getParticleSystemForKey:iEffect_SingleTargetExplosion];
        explodeSystem.position = foundCreep.creepSprite.position;
        explodeSystem.autoRemoveOnFinish = YES;
        [gameField addChild:explodeSystem z:5];
        int damage = container.tower.minDamage + arc4random() % container.tower.maxDamage;
        [foundCreep shoot:damage];
    }
}

- (void) handleHugeExplosion:(ShotContainer*)container
{
    CCParticleSystemQuad * system = [self getParticleSystemForKey:iEffect_BigExplosionRing];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    system = [self getParticleSystemForKey:iEffect_BigExplosionDebris];
    system.position = container.creep.creepSprite.position;
    system.autoRemoveOnFinish = YES;
    [gameField addChild:system z:5];
    
    NSMutableArray * toShoot = [NSMutableArray array];
    for (Creep * foundCreep in gameField.mainSpawner.creeps)
    {
        float thisdistance = [gameField distanceBetweenPointsA:container.creep.creepSprite.position B:foundCreep.creepSprite.position];
        if (thisdistance < 200.0)
        {
            [toShoot addObject:foundCreep];
        }
    }
    for (Creep * foundCreep in toShoot)
    {
        CCParticleSystemQuad * explodeSystem = [self getParticleSystemForKey:iEffect_SingleTargetExplosionPepper];
        explodeSystem.position = foundCreep.creepSprite.position;
        explodeSystem.autoRemoveOnFinish = YES;
        [gameField addChild:explodeSystem z:5];
        int damage = container.tower.minDamage + arc4random() % container.tower.maxDamage;
        [foundCreep shoot:damage];
    }
}

@end
