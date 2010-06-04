//
//  EthanolTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EthanolTower.h"

@implementation EthanolTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        target = nil;
        gameField = theGameField;
        
        towerType = TowerType_Ethanol;
        towerName = String_TowerName_Ethanol;
        chemicalDescription = String_ChemDescription_Ethanol;
        towerEffects = String_TowerEffect_Ethanol;
        formula = String_TowerFormula_Ethanol;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 2;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 6;
        formulaComponent3 = TOWERTEXTURE_OXYGEN;
        formulaQuantity3 = 1;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 140;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_ETHANOL]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
