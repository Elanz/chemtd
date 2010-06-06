//
//  VitaminCTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "VitaminCTower.h"


@implementation VitaminCTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_VitaminC;
        towerName = String_TowerName_VitaminC;
        chemicalDescription = String_ChemDescription_VitaminC;
        towerEffects = String_TowerEffect_VitaminC;
        formula = String_TowerFormula_VitaminC;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 6;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 8;
        formulaComponent3 = TOWERTEXTURE_OXYGEN;
        formulaQuantity3 = 6;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_VITAMINC]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
