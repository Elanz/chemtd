//
//  Chloroform.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "ChloroformTower.h"
//#import "CombatManager.h"
//
//@implementation ChloroformTower
//
//- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
//{
//    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
//        // Initialization code
//        
//        gameField = theGameField;
//        
//        towerType = TowerType_Chloroform;
//        towerName = String_TowerName_Chloroform;
//        chemicalDescription = String_ChemDescription_Chloroform;
//        towerEffects = String_TowerEffect_Chloroform;
//        formula = String_TowerFormula_Chloroform;
//        targetType = TowerTargetType_Single;
//        shotParticleFileName = Effect_SingleTargetChlorineShot;
//        effectType = TowerEffectType_Sleep;
//        towerPower = 1;
//        towerClass = 3;
//        switchTargetsAfterHit = YES;
//        
//        formulaComponent1 = TOWERTEXTURE_CARBON;
//        formulaQuantity1 = 1;
//        formulaComponent2 = TOWERTEXTURE_HYDROGEN;
//        formulaQuantity2 = 1;
//        formulaComponent3 = TOWERTEXTURE_CHLORINE;
//        formulaQuantity3 = 3;
//        formulaComponent4 = -1;
//        formulaQuantity4 = 0;
//        formulaComponent5 = -1;
//        formulaQuantity5 = 0;
//        
//        baseRange = 200;
//        baseMinDamage = 4;
//        baseMaxDamage = 6;
//        baseInterval = 2.0;
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
//        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_CHLOROFORM]];     
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [super dealloc];
//}
//
//@end
