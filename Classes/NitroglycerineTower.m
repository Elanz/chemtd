//
//  Nitroglycerine.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NitroglycerineTower.h"
#import "CombatManager.h"

@implementation NitroglycerineTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Nitroglycerine;
        towerName = String_TowerName_Nitroglycerine;
        chemicalDescription = String_ChemDescription_Nitroglycerine;
        towerEffects = String_TowerEffect_Nitroglycerine;
        formula = String_TowerFormula_Nitroglycerine;
        targetType = TowerTargetType_Single;
        effectType = TowerEffectType_SplashHuge;
        towerPower = 1;
        towerClass = 4;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 3;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 5;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 3;
        formulaComponent4 = TOWERTEXTURE_OXYGEN;
        formulaQuantity4 = 9;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 300;
        baseMinDamage = 60;
        baseMaxDamage = 75;
        baseInterval = 2.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_NITROGLYCERINE]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
