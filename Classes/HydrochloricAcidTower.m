//
//  HydrochloricAcidTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "HydrochloricAcidTower.h"
//#import "CombatManager.h"
//
//@implementation HydrochloricAcidTower
//
//- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
//{
//    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
//        // Initialization code
//        
//        gameField = theGameField;
//        
//        towerType = TowerType_HydrochloricAcid;
//        towerName = String_TowerName_HydrochloricAcid;
//        chemicalDescription = String_ChemDescription_HydrochloricAcid;
//        towerEffects = String_TowerEffect_HydrochloricAcid;
//        formula = String_TowerFormula_HydrochloricAcid;
//        targetType = TowerTargetType_Single;
//        shotParticleFileName = Effect_SingleTargetChlorineShot;
//        hitParticleFileName = Effect_SingleTargetChlorineHit;
//        targetType = TowerTargetType_Multi;
//        effectType = TowerEffectType_Poison;
//        towerPower = 1;
//        towerClass = 2;
//        maxTargets = 1; 
//        
//        switchTargetsAfterHit = YES;
//        formulaComponent1 = TOWERTEXTURE_HYDROGEN;
//        formulaQuantity1 = 1;
//        formulaComponent2 = TOWERTEXTURE_CHLORINE;
//        formulaQuantity2 = 1;
//        formulaComponent3 = -1;
//        formulaQuantity3 = 0;
//        formulaComponent4 = -1;
//        formulaQuantity4 = 0;
//        formulaComponent5 = -1;
//        formulaQuantity5 = 0;
//        
//        baseRange = 200;
//        baseMinDamage = 20;
//        baseMaxDamage = 25;
//        baseInterval = 1.0;
//        baseDotMin = 6;
//        baseDotMax = 9;
//        
//        shotRange = baseRange;
//        minDamage = baseMinDamage;
//        maxDamage = baseMaxDamage;
//        shotInterval = baseInterval;
//        dotMin = baseDotMin;
//        dotMax = baseDotMax;
//        
//        [self setPower:towerPower];
//        
//        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
//        library = delegate.textureLibrary;
//        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_HYDROCHLORICACID]];     
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [super dealloc];
//}
//
//@end
