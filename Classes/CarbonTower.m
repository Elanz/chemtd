//
//  Carbon.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CarbonTower.h"
#import "CombatManager.h"

@implementation CarbonTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Carbon;
        towerName = String_TowerName_Carbon;
        chemicalDescription = String_ChemDescription_Carbon;
        towerEffects = String_TowerEffect_Carbon;
        formula = String_TowerFormula_Carbon;
        targetType = TowerTargetType_Single;
        shotParticleFileName = Effect_SingleTargetCarbonShot;
        hitParticleFileName = Effect_SingleTargetCarbonHit;
        towerPower = 1;
        maxPower = 30;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 1;
        formulaComponent2 = -1;
        formulaQuantity2 = 0;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 150;
        baseMinDamage = 8;
        baseMaxDamage = 12;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CARBON]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
