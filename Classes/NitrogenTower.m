//
//  NitrogenTower.m
//  tdtest
//
//  Created by Eric Lanz on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NitrogenTower.h"
#import "CombatManager.h"

@implementation NitrogenTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Nitrogen;
        towerName = String_TowerName_Nitrogen;
        chemicalDescription = String_ChemDescription_Nitrogen;
        towerEffects = String_TowerEffect_Nitrogen;
        formula = String_TowerFormula_Nitrogen;
        targetType = TowerTargetType_Single;
        shotParticleFileName = Effect_SingleTargetNitrogenShot;
        hitParticleFileName = Effect_SingleTargetNitrogenHit;
        towerPower = 1;
        maxPower = 30;
        towerClass = 1;
        
        formulaComponent1 = TOWERTEXTURE_NITROGEN;
        formulaQuantity1 = 1;
        formulaComponent2 = -1;
        formulaQuantity2 = 0;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_NITROGEN]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end

