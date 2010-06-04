//
//  TylenolTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TylenolTower.h"

@implementation TylenolTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        target = nil;
        gameField = theGameField;
        
        towerType = TowerType_Tylenol;
        towerName = String_TowerName_Tylenol;
        chemicalDescription = String_ChemDescription_Tylenol;
        towerEffects = String_TowerEffect_Tylenol;
        formula = String_TowerFormula_Tylenol;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 8;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 9;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 1;
        formulaComponent4 = TOWERTEXTURE_OXYGEN;
        formulaQuantity4 = 2;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_TYLENOL]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
