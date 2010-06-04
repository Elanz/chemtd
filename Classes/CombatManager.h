//
//  CombatManager.h
//  ChemTD
//
//  Created by Eric Lanz on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFieldScene.h"

#define Effect_SingleTargetFireball @"cometshot.plist"
#define Effect_SingleTargetExplosion @"explosion.plist"

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

@end
