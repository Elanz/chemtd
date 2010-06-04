//
//  NitricAcidTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NitricAcidTower.h"

@implementation NitricAcidTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        target = nil;
        gameField = theGameField;
        
        towerType = TowerType_NitricAcid;
        towerName = String_TowerName_NitricAcid;
        chemicalDescription = String_ChemDescription_NitricAcid;
        towerEffects = String_TowerEffect_NitricAcid;
        formula = String_TowerFormula_NitricAcid;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity1 = 1;
        formulaComponent2 = TOWERTEXTURE_NITROGEN;
        formulaQuantity2 = 1;
        formulaComponent3 = TOWERTEXTURE_OXYGEN;
        formulaQuantity3 = 3;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_NITRICACID]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
