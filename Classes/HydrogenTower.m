//
//  HydrogenTower.m
//  tdtest
//
//  Created by Eric Lanz on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HydrogenTower.h"
#import "CombatManager.h"

@implementation HydrogenTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Hydrogen;
        towerName = String_TowerName_Hydrogen;
        chemicalDescription = String_ChemDescription_Hydrogen;
        towerEffects = String_TowerEffect_Hydrogen;
        formula = String_TowerFormula_Hydrogen;
        targetType = TowerTargetType_Single;
        shotParticleKey = iEffect_SingleTargetHydrogenShot;
        hitParticleKey = iEffect_SingleTargetHydrogenHit;
        towerPower = 1;
        maxPower = 30;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity1 = 1;
        formulaComponent2 = -1;
        formulaQuantity2 = 0;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 150;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_HYDROGEN]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

