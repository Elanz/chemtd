//
//  TNTTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TNTTower.h"
#import "CombatManager.h"

@implementation TNTTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_TNT;
        towerName = String_TowerName_TNT;
        chemicalDescription = String_ChemDescription_TNT;
        towerEffects = String_TowerEffect_TNT;
        formula = String_TowerFormula_TNT;
        targetType = TowerTargetType_Single;
        effectType = TowerEffectType_SplashBig;
        towerPower = 1;
        towerClass = 4;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 7;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 5;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 3;
        formulaComponent4 = TOWERTEXTURE_OXYGEN;
        formulaQuantity4 = 6;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 200;
        baseMinDamage = 20;
        baseMaxDamage = 25;
        baseInterval = 0.75;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_TNT]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
