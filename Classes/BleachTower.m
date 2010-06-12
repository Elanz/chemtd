//
//  BleachTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "BleachTower.h"
//#import "CombatManager.h"
//
//@implementation BleachTower
//
//- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
//{
//    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
//        // Initialization code
//        
//        gameField = theGameField;
//        
//        towerType = TowerType_Bleach;
//        towerName = String_TowerName_Bleach;
//        chemicalDescription = String_ChemDescription_Bleach;
//        towerEffects = String_TowerEffect_Bleach;
//        trapTextureKey = FIELDTEXTURE_BLEACHTRAP;
//        formula = String_TowerFormula_Bleach;
//        targetType = TowerTargetType_Single;
//        effectType = TowerEffectType_AOETrap;
//        shotParticleFileName = Effect_SingleTargetFireballGreen;
//        hitParticleFileName = Effect_GreenBubbles;
//        towerPower = 1;
//        towerClass = 2;
//        switchTargetsAfterHit = YES;
//        
//        formulaComponent1 = TOWERTEXTURE_SODIUM;
//        formulaQuantity1 = 1;
//        formulaComponent2 = TOWERTEXTURE_OXYGEN;
//        formulaQuantity2 = 1;
//        formulaComponent3 = TOWERTEXTURE_CHLORINE;
//        formulaQuantity3 = 1;
//        formulaComponent4 = -1;
//        formulaQuantity4 = 0;
//        formulaComponent5 = -1;
//        formulaQuantity5 = 0;
//        
//        baseRange = 250;
//        baseMinDamage = 4;
//        baseMaxDamage = 6;
//        baseInterval = 2.0;
//        baseDotMin = 4;
//        baseDotMax = 6;
//        
//        shotRange = baseRange;
//        minDamage = baseMinDamage;
//        maxDamage = baseMaxDamage;
//        dotMin = baseDotMin;
//        dotMax = baseDotMax;
//        shotInterval = baseInterval;
//        
//        [self setPower:towerPower];
//        
//        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
//        library = delegate.textureLibrary;
//        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_BLEACH]];     
//    }
//    return self;
//}
//
//- (void)dealloc {
//    [super dealloc];
//}
//
//@end
