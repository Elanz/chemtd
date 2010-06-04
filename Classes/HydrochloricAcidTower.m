//
//  HydrochloricAcidTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HydrochloricAcidTower.h"

@implementation HydrochloricAcidTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        target = nil;
        gameField = theGameField;
        
        towerType = TowerType_HydrochloricAcid;
        towerName = String_TowerName_HydrochloricAcid;
        chemicalDescription = String_ChemDescription_HydrochloricAcid;
        towerEffects = String_TowerEffect_HydrochloricAcid;
        formula = String_TowerFormula_HydrochloricAcid;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity1 = 1;
        formulaComponent2 = TOWERTEXTURE_CHLORINE;
        formulaQuantity2 = 1;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_HYDROCHLORICACID]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
