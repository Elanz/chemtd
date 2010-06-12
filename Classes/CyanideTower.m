//
//  CyanideTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CyanideTower.h"
#import "CombatManager.h"

@implementation CyanideTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Cyanide;
        towerName = String_TowerName_Cyanide;
        chemicalDescription = String_ChemDescription_Cyanide;
        towerEffects = String_TowerEffect_Cyanide;
        formula = String_TowerFormula_Cyanide;
        shotParticleKey = iEffect_SingleTargetChlorineShot;
        hitParticleKey = iEffect_SingleTargetChlorineHit;
        targetType = TowerTargetType_Single;
        effectType = TowerEffectType_Poison;
        towerPower = 1;
        towerClass = 2;
        maxTargets = 1;
        switchTargetsAfterHit = YES;
        
        formulaComponent1 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity1 = 1;
        formulaComponent2 = TOWERTEXTURE_CARBON;
        formulaQuantity2 = 1;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 1;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = TowerBaseRange*4;
        baseMinDamage = 11;
        baseMaxDamage = 15;
        baseInterval = 1.0;
        baseDotMin = 6;
        baseDotMax = 8;
        
        dotMin = baseDotMin;
        dotMax = baseDotMax;
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CYANIDE]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
