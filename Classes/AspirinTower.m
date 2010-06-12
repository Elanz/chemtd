//
//  AspirinTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AspirinTower.h"
#import "Effects.h"
#import "BaseEffect.h"
#import "CombatManager.h"

@implementation AspirinTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Aspirin;
        towerName = String_TowerName_Aspirin;
        chemicalDescription = String_ChemDescription_Aspirin;
        towerEffects = String_TowerEffect_Aspirin;
        formula = String_TowerFormula_Aspirin;
        targetType = TowerTargetType_Single;
        shotParticleKey = iEffect_SingleTargetWhiteSmoke;
        hitParticleKey = iEffect_SingleTargetWhiteSmoke;
        towerPower = 1;
        towerClass = 5;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 9;
        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
        formulaQuantity2 = 8;
        formulaComponent3 = TOWERTEXTURE_OXYGEN;
        formulaQuantity3 = 4;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
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
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_ASPIRIN]];  
        
        targetTowers = [[NSMutableArray alloc] init];
        effectRange = 300;
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
            }
        }
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
