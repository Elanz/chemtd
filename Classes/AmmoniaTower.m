//
//  AmmoniaTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AmmoniaTower.h"
#import "CombatManager.h"

@implementation AmmoniaTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Ammonia;
        towerName = String_TowerName_Ammonia;
        chemicalDescription = String_ChemDescription_Ammonia;
        towerEffects = String_TowerEffect_Ammonia;
        formula = String_TowerFormula_Ammonia;
        targetType = TowerTargetType_Multi;
        shotParticleKey = iEffect_SingleTargetFireballGreen;
        hitParticleKey = iEffect_GreenBubbles;
        effectType = TowerEffectType_AOETrap;
        trapTextureKey = FIELDTEXTURE_BLEACHTRAP;
        maxTargets = 2;
        towerPower = 1;
        towerClass = 3;
        switchTargetsAfterHit = YES;
        
        formulaComponent1 = TOWERTEXTURE_NITROGEN;
        formulaQuantity1 = 1;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 3;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = TowerBaseRange*5;
        baseMinDamage = 15;
        baseMaxDamage = 20;
        baseInterval = 1.0;
        baseDotMin = 7;
        baseDotMax = 13;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        dotMin = baseDotMin;
        dotMax = baseDotMax;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_AMMONIA]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
