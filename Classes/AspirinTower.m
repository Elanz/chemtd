//
//  AspirinTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AspirinTower.h"

@implementation AspirinTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Aspirin;
        towerName = String_TowerName_Aspirin;
        chemicalDescription = String_ChemDescription_Aspirin;
        towerEffects = String_TowerEffect_Aspirin;
        formula = String_TowerFormula_Aspirin;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 2;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 9;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 8;
        formulaComponent3 = TOWERTEXTURE_OXYGEN;
        formulaQuantity3 = 4;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 240;
        baseMinDamage = 40;
        baseMaxDamage = 45;
        baseInterval = 0.65;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_ASPIRIN]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
