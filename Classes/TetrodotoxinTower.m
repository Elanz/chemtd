//
//  TetrodotoxinTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TetrodotoxinTower.h"
#import "CombatManager.h"

@implementation TetrodotoxinTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Tetrodotoxin;
        towerName = String_TowerName_Tetrodotoxin;
        chemicalDescription = String_ChemDescription_Tetrodotoxin;
        towerEffects = String_TowerEffect_Tetrodotoxin;
        formula = String_TowerFormula_Tetrodotoxin;
        targetType = TowerTargetType_Single;
        shotParticleFileName = Effect_SingleTargetChlorineShot;
        effectType = TowerEffectType_SlowPoison;
        towerPower = 1;
        towerClass = 5;
        maxTargets = 20;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 11;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 17;
        formulaComponent3 = TOWERTEXTURE_NITROGEN;
        formulaQuantity3 = 3;
        formulaComponent4 = TOWERTEXTURE_OXYGEN;
        formulaQuantity4 = 8;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 250;
        baseMinDamage = 20;
        baseMaxDamage = 25;
        baseInterval = 0.75;
        baseDotMin = 15;
        baseDotMax = 17;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        dotMin = baseDotMin;
        dotMax = baseDotMax;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_TETRODOTOXIN]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
