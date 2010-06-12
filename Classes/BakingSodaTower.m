//
//  BakingSodaTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "BakingSodaTower.h"
//#import "CombatManager.h"
//
//@implementation BakingSodaTower
//
//- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
//{
//    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
//        // Initialization code
//        
//        gameField = theGameField;
//        
//        towerType = TowerType_BakingSoda;
//        towerName = String_TowerName_BakingSoda;
//        chemicalDescription = String_ChemDescription_BakingSoda;
//        towerEffects = String_TowerEffect_BakingSoda;
//        formula = String_TowerFormula_BakingSoda;
//        targetType = TowerTargetType_Multi;
//        shotParticleFileName = Effect_None;
//        hitParticleFileName = Effect_SingleTargetWhiteSmoke;
//        maxTargets = 30;
//        towerPower = 1;
//        towerClass = 3;
//        
//        formulaComponent1 = TOWERTEXTURE_CARBON;
//        formulaQuantity1 = 1;
//        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
//        formulaQuantity2 = 1;
//        formulaComponent3 = TOWERTEXTURE_SODIUM;
//        formulaQuantity3 = 1;
//        formulaComponent4 = TOWERTEXTURE_OXYGEN;
//        formulaQuantity4 = 3;
//        formulaComponent5 = -1;
//        formulaQuantity5 = 0;
//        
//        baseRange = 200;
//        baseMinDamage = 4;
//        baseMaxDamage = 6;
//        baseInterval = 0.5;
//        
//        shotRange = baseRange;
//        minDamage = baseMinDamage;
//        maxDamage = baseMaxDamage;
//        shotInterval = baseInterval;
//        
//        [self setPower:towerPower];
//        
//        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
//        library = delegate.textureLibrary;
//        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_BAKINGSODA]];     
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [super dealloc];
//}
//
//@end
