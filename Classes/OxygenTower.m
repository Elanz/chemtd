//
//  OxygenTower.m
//  tdtest
//
//  Created by Eric Lanz on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OxygenTower.h"
#import "CombatManager.h"

@implementation OxygenTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Oxygen;
        towerName = String_TowerName_Oxygen;
        chemicalDescription = String_ChemDescription_Oxygen;
        towerEffects = String_TowerEffect_Oxygen;
        formula = String_TowerFormula_Oxygen;
        targetType = TowerTargetType_Single;
        shotParticleKey = iEffect_SingleTargetOxygenShot;
        hitParticleKey = iEffect_SingleTargetOxygenHit;
        towerPower = 1;
        maxPower = 30;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_OXYGEN;
        formulaQuantity1 = 1;
        formulaComponent2 = -1;
        formulaQuantity2 = 0;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = TowerBaseRange*3;
        baseMinDamage = 8;
        baseMaxDamage = 12;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_OXYGEN]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

