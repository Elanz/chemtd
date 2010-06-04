//
//  Acetylene.m
//  ChemTD
//
//  Created by Eric Lanz on 5/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AcetyleneTower.h"

@implementation AcetyleneTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        target = nil;
        gameField = theGameField;
        
        towerType = TowerType_Acetylene;
        towerName = String_TowerName_Acetylene;
        chemicalDescription = String_ChemDescription_Acetylene;
        towerEffects = String_TowerEffect_Acetylene;
        formula = String_TowerFormula_Acetylene;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 2;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 2;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 2;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 240;
        baseMinDamage = 20;
        baseMaxDamage = 25;
        baseInterval = 0.60;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_ACETYLENE]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end