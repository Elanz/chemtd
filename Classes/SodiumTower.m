//
//  SodiumTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "SodiumTower.h"
//#import "CombatManager.h"
//
//@implementation SodiumTower
//
//- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
//{
//    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
//        // Initialization code
//        
//        gameField = theGameField;
//        
//        towerType = TowerType_Sodium;
//        towerName = String_TowerName_Sodium;
//        chemicalDescription = String_ChemDescription_Sodium;
//        towerEffects = String_TowerEffect_Sodium;
//        formula = String_TowerFormula_Sodium;
//        targetType = TowerTargetType_Single;
//        shotParticleFileName = Effect_SingleTargetSodiumShot;
//        hitParticleFileName = Effect_SingleTargetSodiumHit;
//        towerPower = 1;
//        maxPower = 30;
//        towerClass = 1;
//        
//        formulaComponent1 = TOWERTEXTURE_SODIUM;
//        formulaQuantity1 = 1;
//        formulaComponent2 = -1;
//        formulaQuantity2 = 0;
//        formulaComponent3 = -1;
//        formulaQuantity3 = 0;
//        formulaComponent4 = -1;
//        formulaQuantity4 = 0;
//        formulaComponent5 = -1;
//        formulaQuantity5 = 0;
//        
//        baseRange = 140;
//        baseMinDamage = 20;
//        baseMaxDamage = 25;
//        baseInterval = 0.75;
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
//        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_SODIUM]];     
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [super dealloc];
//}
//
//@end
