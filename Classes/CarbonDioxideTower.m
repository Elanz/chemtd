//
//  CarbonDioxide.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CarbonDioxideTower.h"
#import "CombatManager.h"

@implementation CarbonDioxideTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_CarbonDioxide;
        towerName = String_TowerName_CarbonDioxide;
        chemicalDescription = String_ChemDescription_CarbonDioxide;
        towerEffects = String_TowerEffect_CarbonDioxide;
        formula = String_TowerFormula_CarbonDioxide;
        targetType = TowerTargetType_Multi;
        shotParticleKey = iEffect_None;
        hitParticleKey = iEffect_SingleTargetBlackSmoke;
        maxTargets = 2;
        towerPower = 1;
        towerClass = 2;
        
        formulaComponent1 = TOWERTEXTURE_CARBON;
        formulaQuantity1 = 1;
        formulaComponent2 = TOWERTEXTURE_OXYGEN;
        formulaQuantity2 = 2;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = TowerBaseRange*4;
        baseMinDamage = 11;
        baseMaxDamage = 15;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CARBONDIOXIDE]];   
    }
    return self;
}

- (void)towerPicked
{
//    CCPointParticleSystem * smokeSystem = [CCPointParticleSystem particleWithFile:Effect_GrayCloud];
//    smokeSystem.position = ccp(towerSize/2, towerSize/2);
//    [towerSprite addChild:smokeSystem z:2];
}

- (void)dealloc {
    [super dealloc];
}

@end
