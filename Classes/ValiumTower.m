//
//  ValiumTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ValiumTower.h"
#import "CombatManager.h"

@implementation ValiumTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Valium;
        towerName = String_TowerName_Valium;
        chemicalDescription = String_ChemDescription_Valium;
        towerEffects = String_TowerEffect_Valium;
        formula = String_TowerFormula_Valium;
        targetType = TowerTargetType_Multi;
        shotParticleFileName = Effect_SingleTargetChlorineShot;
        effectType = TowerEffectType_Sleep;
        towerPower = 1;
        towerClass = 5;
        maxTargets = 20;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 16;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 13;
        formulaComponent3 = TOWERTEXTURE_CHLORINE;
        formulaQuantity3 = 1;
        formulaComponent4 = TOWERTEXTURE_NITROGEN;
        formulaQuantity4 = 2;
        formulaComponent5 = TOWERTEXTURE_OXYGEN;
        formulaQuantity5 = 1;
        
        baseRange = 200;
        baseMinDamage = 60;
        baseMaxDamage = 75;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_VALIUM]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
