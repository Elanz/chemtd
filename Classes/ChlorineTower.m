//
//  ChlorineTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "ChlorineTower.h"
//#import "CombatManager.h"
//
//@implementation ChlorineTower
//
//- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
//{
//    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
//        // Initialization code
//        
//        gameField = theGameField;
//        
//        towerType = TowerType_Chlorine;
//        towerName = String_TowerName_Chlorine;
//        chemicalDescription = String_ChemDescription_Chlorine;
//        towerEffects = String_TowerEffect_Chlorine;
//        formula = String_TowerFormula_Chlorine;
//        targetType = TowerTargetType_Single;
//        shotParticleFileName = Effect_SingleTargetChlorineShot;
//        hitParticleFileName = Effect_SingleTargetChlorineHit;
//        towerPower = 1;
//        maxPower = 30;
//        towerClass = 1;
//        
//        formulaComponent1 = TOWERTEXTURE_CHLORINE;
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
//        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CHLORINE]];     
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [super dealloc];
//}
//
//@end
