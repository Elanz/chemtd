//
//  CarbonMonoxideTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CarbonMonoxideTower.h"
#import "CombatManager.h"

@implementation CarbonMonoxideTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_CarbonMonoxide;
        towerName = String_TowerName_CarbonMonoxide;
        chemicalDescription = String_ChemDescription_CarbonMonoxide;
        towerEffects = String_TowerEffect_CarbonMonoxide;
        formula = String_TowerFormula_CarbonMonoxide;
        targetType = TowerTargetType_Single;
        shotParticleFileName = Effect_None;
        hitParticleFileName = Effect_SingleTargetBlackSmoke;
        maxTargets = 2;
        towerPower = 1;
        towerClass = 2;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 1;
        formulaComponent2 = TOWERTEXTURE_OXYGEN;
        formulaQuantity2 = 1;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 160;
        baseMinDamage = 15;
        baseMaxDamage = 20;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CARBONMONOXIDE]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
