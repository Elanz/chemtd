//
//  WaterTower.m
//  tdtest
//
//  Created by Eric Lanz on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WaterTower.h"
#import "CombatManager.h"

@implementation WaterTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Water;
        towerName = String_TowerName_Water;
        chemicalDescription = String_ChemDescription_Water;
        towerEffects = String_TowerEffect_Water;
        formula = String_TowerFormula_Water;
        targetType = TowerTargetType_Single;
        shotParticleFileName = Effect_SingleTargetOxygenShot;
        effectType = TowerEffectType_WaterSplash;
        towerPower = 1;
        towerClass = 2;
        
        formulaComponent1 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity1 = 2;
        formulaComponent2 = TOWERTEXTURE_OXYGEN;
        formulaQuantity2 = 1;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 220;
        baseMinDamage = 40;
        baseMaxDamage = 45;
        baseInterval = 0.75;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_WATER]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

