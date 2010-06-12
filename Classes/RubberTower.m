//
//  RubberTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RubberTower.h"
#import "CombatManager.h"

@implementation RubberTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Rubber;
        towerName = String_TowerName_Rubber;
        chemicalDescription = String_ChemDescription_Rubber;
        towerEffects = String_TowerEffect_Rubber;
        formula = String_TowerFormula_Rubber;
        shotParticleKey = iEffect_SingleTargetCarbonShot;
        targetType = TowerTargetType_Single;
        effectType = TowerEffectType_Rubber;
        towerPower = 1;
        towerClass = 4;
        switchTargetsAfterHit = YES;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 5;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 8;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = TowerBaseRange*6;
        baseMinDamage = 70;
        baseMaxDamage = 80;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_RUBBER]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
