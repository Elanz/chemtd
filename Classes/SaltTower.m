//
//  SaltTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SaltTower.h"
#import "CombatManager.h"

@implementation SaltTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Salt;
        towerName = String_TowerName_Salt;
        chemicalDescription = String_ChemDescription_Salt;
        towerEffects = String_TowerEffect_Salt;
        formula = String_TowerFormula_Salt;
        targetType = TowerTargetType_Single;
        targetType = TowerTargetType_Multi;
        shotParticleFileName = Effect_SingleTargetWhiteSmoke;
        hitParticleFileName = Effect_SingleTargetWhiteSmoke;
        towerPower = 1;
        towerClass = 2;
        maxTargets = 3;
        
        formulaComponent1 = TOWERTEXTURE_SODIUM;
        formulaQuantity1 = 1;
        formulaComponent2 = TOWERTEXTURE_CHLORINE;
        formulaQuantity2 = 1;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 180;
        baseMinDamage = 10;
        baseMaxDamage = 15;
        baseInterval = 0.25;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_SALT]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
