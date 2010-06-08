//
//  RDXTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RDXTower.h"

@implementation RDXTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_RDX;
        towerName = String_TowerName_RDX;
        chemicalDescription = String_ChemDescription_RDX;
        towerEffects = String_TowerEffect_RDX;
        formula = String_TowerFormula_RDX;
        targetType = TowerTargetType_Single;
        effectType = TowerEffectType_SplashBig;
        towerPower = 1;
        towerClass = 4;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 3;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 6;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 6;
        formulaComponent4 = TOWERTEXTURE_OXYGEN;
        formulaQuantity4 = 6;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 250;
        baseMinDamage = 50;
        baseMaxDamage = 60;
        baseInterval = 2.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_RDX]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
