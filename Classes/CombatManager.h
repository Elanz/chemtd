//
//  CombatManager.h
//  ChemTD
//
//  Created by Eric Lanz on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFieldScene.h"

//#define Effect_None @""
//#define Effect_WaterExplosion @"waterexplosion.plist"
//#define Effect_SingleTargetOxygenShot @"oxygenshot.plist"
//#define Effect_SingleTargetOxygenHit @"oxygenhit.plist"
//#define Effect_SingleTargetSodiumShot @"sodiumshot.plist"
//#define Effect_SingleTargetSodiumHit @"sodiumhit.plist"
//#define Effect_SingleTargetHydrogenShot @"hydrogenshot.plist"
//#define Effect_SingleTargetHydrogenHit @"hydrogenhit.plist"
//#define Effect_SingleTargetNitrogenShot @"nitrogenshot.plist"
//#define Effect_SingleTargetNitrogenHit @"nitrogenhit.plist"
//#define Effect_SingleTargetChlorineShot @"chlorineshot.plist"
//#define Effect_SingleTargetChlorineHit @"chlorinehit.plist"
//#define Effect_SingleTargetCarbonShot @"carbonshot.plist"
//#define Effect_SingleTargetCarbonHit @"carbonhit.plist"
//#define Effect_SingleTargetFireball @"cometshot.plist"
//#define Effect_SingleTargetExplosion @"explosion.plist"
//#define Effect_SingleTargetFireballGreen @"cometshotgreen.plist"
//#define Effect_SingleTargetExplosionGreen @"explosiongreen.plist"
//#define Effect_SingleTargetWhiteSmoke @"whitesmoke.plist"
//#define Effect_SingleTargetBlackSmoke @"blacksmoke.plist"
//#define Effect_GreenBubbles @"greenbubbles.plist"
//#define Effect_SingleTargetFireballPepper @"peppershot.plist"
//#define Effect_SingleTargetExplosionPepper @"pepperexplosion.plist"
//#define Effect_GrayCloud @"graycloud.plist"
//#define Effect_Sleep @"sleep.plist"
//#define Effect_NitrousShot @"nitrousshot.plist"
//#define Effect_NitrousHit @"nitroushit.plist"
//#define Effect_BigExplosionRing @"bigexplosionring.plist"
//#define Effect_BigExplosionDebris @"bigexplosiondebris.plist"
//#define Effect_SingleTargetGreenSmoke @"greensmoke.plist"
//#define Effect_SingleTargetOrangeSmoke @"orangesmoke.plist"

#define iEffect_None 0
#define iEffect_WaterExplosion 1
#define iEffect_SingleTargetOxygenShot 2
#define iEffect_SingleTargetOxygenHit 3
#define iEffect_SingleTargetSodiumShot 4
#define iEffect_SingleTargetSodiumHit 5
#define iEffect_SingleTargetHydrogenShot 6
#define iEffect_SingleTargetHydrogenHit 7
#define iEffect_SingleTargetNitrogenShot 8
#define iEffect_SingleTargetNitrogenHit 9
#define iEffect_SingleTargetChlorineShot 10
#define iEffect_SingleTargetChlorineHit 11
#define iEffect_SingleTargetCarbonShot 12
#define iEffect_SingleTargetCarbonHit 13
#define iEffect_SingleTargetFireball 14
#define iEffect_SingleTargetExplosion 15
#define iEffect_SingleTargetFireballGreen 16
#define iEffect_SingleTargetExplosionGreen 17
#define iEffect_SingleTargetWhiteSmoke 18
#define iEffect_SingleTargetBlackSmoke 19
#define iEffect_GreenBubbles 20
#define iEffect_SingleTargetFireballPepper 21
#define iEffect_SingleTargetExplosionPepper 22
#define iEffect_GrayCloud 23
#define iEffect_Sleep 24
#define iEffect_NitrousShot 25
#define iEffect_NitrousHit 26
#define iEffect_BigExplosionRing 27
#define iEffect_BigExplosionDebris 28
#define iEffect_SingleTargetGreenSmoke 29
#define iEffect_SingleTargetOrangeSmoke 30

@interface ParticleContainer: NSObject {
    CCPointParticleSystem * system;
    BOOL inuse;
    double checkoutTime;
}

@property (nonatomic) double checkoutTime;
@property (nonatomic, retain) CCPointParticleSystem * system;
@property (nonatomic) BOOL inuse;

@end

@class BaseTower;
@class Creep;

@interface ShotContainer: NSObject {

    BaseTower * tower;
    Creep * creep;
    CCParticleSystem * emitter;

}

@property (nonatomic, retain) BaseTower * tower;
@property (nonatomic, retain) Creep * creep;
@property (nonatomic, retain) CCParticleSystem * emitter;

@end

@interface CombatManager : NSObject {

    GameFieldScene *gameField;
    
    NSLock * particleLibraryLock;
    
    NSMutableDictionary * particleLibrary;
    
    double elapsedTime;
}

-(void) tick:(double)elapsed;
-(void) populateParticleLibrary;
-(NSMutableArray*) getParticleArrayForKey:(int)key;
-(CCPointParticleSystem*) getParticleSystemForKey:(int)key;
-(void) releaseParticleSystem:(CCParticleSystem*)system;

-(id) initWithGameField:(GameFieldScene *)theGameField;

-(void) shootWithTower:(BaseTower*)tower creep:(Creep*)creep;

-(void) shotFinishedCallback:(id)sender data:(void*)data;

- (void) handleHugeExplosion:(ShotContainer*)container;
- (void) handleBigExplosion:(ShotContainer*)container;
- (void) handleWaterExplosion:(ShotContainer*)container;

@end
