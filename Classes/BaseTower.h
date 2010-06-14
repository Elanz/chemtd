//
//  Tower.h
//  tdtest
//
//  Created by Eric Lanz on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "USEnglishStrings.h"
#import "GameFieldScene.h"
#import "TextureLibrary.h"

#define CardHeight 184
#define CardWidth 170

#define TowerBaseRange 50

#define TowerType_Base 0

#define TowerType_Acetylene 1
#define TowerType_Ammonia 2
#define TowerType_Aspirin 3
//#define TowerType_BakingSoda 4
//#define TowerType_Bleach 5
#define TowerType_Caffeine 6
#define TowerType_Capsaicin 7
#define TowerType_Carbon 8
#define TowerType_CarbonDioxide 9
#define TowerType_CarbonMonoxide 10
//#define TowerType_Chlorine 11
//#define TowerType_Chloroform 12
#define TowerType_Cyanide 13
#define TowerType_Ethanol 14
//#define TowerType_HydrochloricAcid 15
#define TowerType_Hydrogen 16
#define TowerType_Methane 17
#define TowerType_NitricAcid 18
#define TowerType_Nitrogen 19
#define TowerType_Nitroglycerine 20
#define TowerType_Nitrous 21
#define TowerType_Oxygen 22
#define TowerType_RDX 23
#define TowerType_Rubber 24
//#define TowerType_Salt 25
//#define TowerType_Sodium 26
#define TowerType_Tetrodotoxin 27
#define TowerType_TNT 28
#define TowerType_Tylenol 29
//#define TowerType_Valium 30
#define TowerType_VitaminC 31
#define TowerType_Water 32

#define NumberOfTowerTypes 32

#define TowerTargetType_None 0
#define TowerTargetType_Single 1 
#define TowerTargetType_Multi 2
#define TowerTargetType_Splash 3
#define TowerTargetType_Trap 4
#define TowerTargetType_Cloud 5 

#define TowerEffectType_ExplodeOnImpact 0
#define TowerEffectType_Burn 1
#define TowerEffectType_AOETrap 2
#define TowerEffectType_Sleep 3
#define TowerEffectType_Poison 4
#define TowerEffectType_Nitrous 5
#define TowerEffectType_SplashHuge 6
#define TowerEffectType_Ethanol 7
#define TowerEffectType_SplashBig 8
#define TowerEffectType_SlowPoison 9
#define TowerEffectType_Rubber 10
#define TowerEffectType_WaterSplash 11

@class Creep;
@class CreepSpawner;

@interface BaseTower : NSObject {
    
    CreepSpawner * currentSpawner;
    
    CCSprite * towerSprite;
    CCBitmapFontAtlas * powerDisplay;
    
    GameFieldScene * gameField;
    TextureLibrary * library;
    
    NSMutableArray * targets;
    NSMutableArray * effects;
    int maxTargets;
    float shotTimer;
    float shotInterval;
    
    int baseRange;
    int baseMinDamage;
    int baseMaxDamage;
    int baseDotMin;
    int baseDotMax;
    float baseInterval;
    
    int towerClass;
    int shotRange;
    int minDamage;
    int maxDamage;
    int dotMin;
    int dotMax;
    int towerType;
    int towerPower;
    int maxPower;
    int targetType;
    
    BOOL usedByMixer;
    BOOL switchTargetsAfterHit;
    
    int effectType;
    int trapTextureKey;
    
    int shotParticleKey;
    int hitParticleKey;
    
    NSString * towerName;
    NSString * chemicalDescription;
    NSString * towerEffects;
    NSString * formula;
    
    int formulaComponent1;
    int formulaQuantity1;
    int formulaComponent2;
    int formulaQuantity2;
    int formulaComponent3;
    int formulaQuantity3;
    int formulaComponent4;
    int formulaQuantity4;
    int formulaComponent5;
    int formulaQuantity5;
}

@property (nonatomic) int trapTextureKey;
@property (nonatomic) int shotParticleKey;
@property (nonatomic) int hitParticleKey;
@property (nonatomic) int effectType;
@property (nonatomic) BOOL switchTargetsAfterHit;
@property (nonatomic) int dotMin;
@property (nonatomic) int dotMax;
@property (nonatomic) int baseDotMin;
@property (nonatomic) int baseDotMax;
@property (nonatomic) int towerType;
@property (nonatomic, retain) CreepSpawner * currentSpawner;
@property (nonatomic, retain) NSString * towerName;
@property (nonatomic) int baseMinDamage;
@property (nonatomic) int baseMaxDamage;
@property (nonatomic) float baseInterval;
@property (nonatomic) float shotInterval;
@property (nonatomic) int shotRange;
@property (nonatomic) int baseRange;
@property (nonatomic) int minDamage;
@property (nonatomic) int maxDamage;
@property (nonatomic) int targetType;
@property (nonatomic) int towerPower;
@property (nonatomic) BOOL usedByMixer;
@property (nonatomic, retain) CCSprite * towerSprite;

- (void)towerPicked;
- (void)addEffect:(BaseEffect*)effect;
- (void)makeLabelWithPosition:(CGPoint)position scale:(float)scale string:(NSString*)string towerCard:(CCSprite*)towerCard;
- (void)prepareCard:(CCSprite*)towerCard baseX:(int)baseX baseY:(int)baseY;
- (void)addIcon:(CCSprite*)towerCard baseX:(int)baseX baseY:(int)baseY;
- (void)addName:(CCSprite*)towerCard baseX:(int)baseX baseY:(int)baseY;
- (void)addClass:(CCSprite*)towerCard baseX:(int)baseX baseY:(int)baseY;
- (void)addStats:(CCSprite*)towerCard baseX:(int)baseX baseY:(int)baseY;
- (void)addDescription:(CCSprite*)towerCard baseX:(int)baseX baseY:(int)baseY;
- (void)addFormula:(CCSprite*)towerCard baseX:(int)baseX baseY:(int)baseY;

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField;

- (void) UpdateTargets:(double)elapsed;

- (void) show;
- (void) hide;
- (void) removeFromLayer;
- (void) removeFromLayerWithCleanup;

- (void) upgrade;

- (int) getPower;
- (void) setPower:(int)newPower;

- (void) setPositionWithX:(int)x Y:(int)y;
- (void) setColor:(ccColor3B)newColor;
- (CGPoint) getTowerPosition;
- (CGSize) getTowerSize;
- (CCTexture2D*) getTexture;
- (void) setTexture:(CCTexture2D*)newTexture;
- (void) setScale:(float)newScale;

- (void) tick:(double)elapsed;

- (void) creepGone:(Creep*)creep;

@end
