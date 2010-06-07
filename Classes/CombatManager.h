//
//  CombatManager.h
//  ChemTD
//
//  Created by Eric Lanz on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFieldScene.h"

#define Effect_None @""
#define Effect_SingleTargetChlorineShot @"chlorineshot.plist"
#define Effect_SingleTargetChlorineHit @"chlorinehit.plist"
#define Effect_SingleTargetCarbonShot @"carbonshot.plist"
#define Effect_SingleTargetCarbonHit @"carbonhit.plist"
#define Effect_SingleTargetFireball @"cometshot.plist"
#define Effect_SingleTargetExplosion @"explosion.plist"
#define Effect_SingleTargetFireballGreen @"cometshotgreen.plist"
#define Effect_SingleTargetExplosionGreen @"explosiongreen.plist"
#define Effect_SingleTargetWhiteSmoke @"whitesmoke.plist"
#define Effect_SingleTargetBlackSmoke @"blacksmoke.plist"
#define Effect_GreenBubbles @"greenbubbles.plist"
#define Effect_SingleTargetFireballPepper @"peppershot.plist"
#define Effect_SingleTargetExplosionPepper @"pepperexplosion.plist"
#define Effect_GrayCloud @"graycloud.plist"
#define Effect_Sleep @"sleep.plist"
#define Effect_NitrousShot @"nitrousshot.plist"
#define Effect_NitrousHit @"nitroushit.plist"
#define Effect_BigExplosionRing @"bigexplosionring.plist"
#define Effect_BigExplosionDebris @"bigexplosiondebris.plist"

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
    
}

-(id) initWithGameField:(GameFieldScene *)theGameField;

-(void) shootWithTower:(BaseTower*)tower creep:(Creep*)creep;

-(void) shotFinishedCallback:(id)sender data:(void*)data;

- (void) handleHugeExplosion:(ShotContainer*)container;

@end
