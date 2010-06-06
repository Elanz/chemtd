//
//  Capsaicin.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CapsaicinTower.h"
#import "CombatManager.h"

@implementation CapsaicinTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Capsaicin;
        towerName = String_TowerName_Capsaicin;
        chemicalDescription = String_ChemDescription_Capsaicin;
        towerEffects = String_TowerEffect_Capsaicin;
        formula = String_TowerFormula_Capsaicin;
        targetType = TowerTargetType_Multi;
        shotParticleFileName = Effect_SingleTargetFireballPepper;
        hitParticleFileName = Effect_SingleTargetExplosionPepper;
        maxTargets = 20;
        towerPower = 1;
        towerClass = 5;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 18;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 27;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 1;
        formulaComponent4 = TOWERTEXTURE_OXYGEN;
        formulaQuantity4 = 3;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 300;
        baseMinDamage = 35;
        baseMaxDamage = 50;
        baseInterval = 0.20;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CAPSAICIN]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
