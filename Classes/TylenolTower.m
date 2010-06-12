//
//  TylenolTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TylenolTower.h"
#import "Effects.h"
#import "BaseEffect.h"
#import "CombatManager.h"

@implementation TylenolTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Tylenol;
        towerName = String_TowerName_Tylenol;
        chemicalDescription = String_ChemDescription_Tylenol;
        towerEffects = String_TowerEffect_Tylenol;
        formula = String_TowerFormula_Tylenol;
        targetType = TowerTargetType_Single;
        shotParticleKey = iEffect_SingleTargetWhiteSmoke;
        hitParticleKey = iEffect_SingleTargetWhiteSmoke;
        towerPower = 1;
        towerClass = 5;
        
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
        
        baseRange = TowerBaseRange*7;
        baseMinDamage = 50;
        baseMaxDamage = 150;
        baseInterval = 1.0;
        
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

- (void) UpdateTargets:(double)elapsed
{
    [super UpdateTargets:elapsed];
    
    for (BaseTower * t in gameField.towers)
    {
        if (t != self && t.towerType != TowerType_Base)
        {
            float rangeToTower = [gameField distanceBetweenPointsA:t.towerSprite.position B:towerSprite.position];
            if (rangeToTower < effectRange && ![targetTowers containsObject:t])
            {
                //printf("applying effect to tower\n");
                BaseEffect * effect = [[DamageBoostEffect alloc] initWithTargetTower:t];
                [t addEffect:effect];
                [targetTowers addObject:t];
            }
        }
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
