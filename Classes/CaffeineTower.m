//
//  CaffeineTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CaffeineTower.h"

@implementation CaffeineTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        target = nil;
        gameField = theGameField;
        
        towerType = TowerType_Caffeine;
        towerName = String_TowerName_Caffeine;
        chemicalDescription = String_ChemDescription_Caffeine;
        towerEffects = String_TowerEffect_Caffeine;
        formula = String_TowerFormula_Caffeine;
        targetType = TowerTargetType_Single;
        towerPower = 1;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 8;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 10;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 4;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CAFFEINE]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
