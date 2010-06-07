//
//  NitrousTower.m
//  ChemTD
//
//  Created by Eric Lanz on 6/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NitrousTower.h"
#import "CombatManager.h"

@implementation NitrousTower

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [super initWithGameField:theGameField addToField:addToField])) {
        // Initialization code
        
        gameField = theGameField;
        
        towerType = TowerType_Nitrous;
        towerName = String_TowerName_Nitrous;
        chemicalDescription = String_ChemDescription_Nitrous;
        towerEffects = String_TowerEffect_Nitrous;
        formula = String_TowerFormula_Nitrous;
        shotParticleFileName = Effect_NitrousShot;
        targetType = TowerTargetType_Single;
        effectType = TowerEffectType_Nitrous;
        towerPower = 1;
        towerClass = 2;
        switchTargetsAfterHit = YES;
        
        formulaComponent1 = TOWERTEXTURE_NITROGEN;
        formulaQuantity1 = 2;
        formulaComponent2 = TOWERTEXTURE_OXYGEN;
        formulaQuantity2 = 1;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 160;
        baseMinDamage = 10;
        baseMaxDamage = 12;
        baseInterval = 1.0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        [towerSprite setTexture:[library GetTextureWithKey:TOWERTEXTURE_NITROUS]];     
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
