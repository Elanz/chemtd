//
//  CaffeineTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CaffeineTower.h"
#import "Effects.h"
#import "BaseEffect.h"
#import "CombatManager.h"

@implementation CaffeineTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Caffeine;
        towerName = String_TowerName_Caffeine;
        chemicalDescription = String_ChemDescription_Caffeine;
        towerEffects = String_TowerEffect_Caffeine;
        formula = String_TowerFormula_Caffeine;
        targetType = TowerTargetType_Single;
        shotParticleKey = iEffect_SingleTargetOrangeSmoke;
        hitParticleKey = iEffect_SingleTargetOrangeSmoke;
        towerPower = 1;
        towerClass = 6;
        
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
        
        baseRange = TowerBaseRange*8;
        baseMinDamage = 100;
        baseMaxDamage = 200;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CAFFEINE]];   
        
        targetTowers = [[NSMutableArray alloc] init];
        effectRange = 400;
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
                BaseEffect * effect = [[RangeBoostEffect alloc] initWithTargetTower:t];
                [t addEffect:effect];
                [targetTowers addObject:t];
                effect = [[DamageBoostEffect alloc] initWithTargetTower:t];
                [t addEffect:effect];
                [targetTowers addObject:t];
                effect = [[SpeedBoostEffect alloc] initWithTargetTower:t];
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
