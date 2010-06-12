//
//  GameField.h
//  ChemTD
//
//  Created by Eric Lanz on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "ChemTDAppDelegate.h"

#define mapHeight 24
#define mapWidth 32

//#define cellSizeZoomed 32
#define halfCellSize 24
#define cellSize 48
#define towerSize 48
#define creepSize 48

#define towersPerRound 5

#define GamePhase_Build 0
#define GamePhase_Creeps 1
#define GamePhase_Pick 2
#define GamePhase_Place 3

#define Initial_Lives 5
#define Initial_Multiplier 1.0
#define Initial_Energy 10

#define field_width 1536.0
#define field_height 1152.0

#define device_width 1024
#define device_height 768

#define max_zoom 1.0
#define min_zoom 0.7

@class PathFinding;
@class BaseTower;
@class CreepSpawner;
@class Creep;
@class TowerMixer;
@class TowerManager;
@class CombatManager;
@class TextureLibrary;
@class TouchHandler;
@class LevelManager;
@class UserManager;
@class LevelStat;
@class BaseEffect;

@interface GameFieldScene : CCLayer {

    PathFinding * pathFinder;
    CreepSpawner * mainSpawner;
    TowerMixer * towerMixer;
    TowerManager * towerManager;
    CombatManager * combatManager;
    TextureLibrary * textureLibrary;
    TouchHandler * touchHandler;
    LevelManager * levelManager;
    UserManager * userManager;
    
    CGPoint startPosition;
    NSMutableDictionary * goalpoints;
    NSMutableArray * towers;
    NSMutableArray * pendingTowers;
    NSMutableArray * fieldEffects;
    
    float field_offsetX;
    float field_offsetY;
   
    BOOL zoomed;
    
    CCSprite *sprite_bottomright;
    CCSprite *sprite_bottomleft;
    CCSprite *sprite_topleft;
    CCSprite *sprite_topright;
    CCSprite *rangeIndicatorSprite;
    
    CCLayer * UILayer;
    
    BaseTower * currentTower;
    
    int currentGamePhase;
    
    int towerForThisRound;
    
    double lastStablegameTimer;
    int lastStablecurrentRound;
    int lastStablelives;
    int lastStableenergy;
    int lastStablescore;
    int lastStabledamage;
    int lastStablekills;
    unsigned char lastStablelevels[mapWidth][mapHeight];
    unsigned char lastStabletileMap[mapWidth][mapHeight];
    
    int currentRound;
    int lives;
    int energy;
    int score;
    int scoreForLevel;
    int damageThisRound;
    int killedThisRound;
    float multiplier;
    double roundTimer;
    
    CCSprite * pauseBtn;
    CCMenuItemSprite * menuItemPause;
    CCMenu * pauseMenu;
    
    CCLayer * highscoreLayer;
    
    CCLayer * minimenuLayer;
    CCSprite * miniMenuBackground;
    CCSprite * mainMenuBtn;
    CCMenuItemSprite * menuItemMainMenu;
    CCSprite * resumeBtn;
    CCMenuItemSprite * menuItemResume;
    CCMenu * miniMenu;
    
    CCBitmapFontAtlas * phaseDisplay;
    CCBitmapFontAtlas * levelDisplay;
    CCBitmapFontAtlas * livesDisplay;
    CCBitmapFontAtlas * scoreDisplay;
    CCBitmapFontAtlas * energyDisplay;
    CCBitmapFontAtlas * DPSDisplay;
    CCBitmapFontAtlas * MultiplierDisplay;

    unsigned char levels[mapWidth][mapHeight];
    unsigned char tileMap[mapWidth][mapHeight];
    
    LevelStat * timeStat;
    LevelStat * scoreStat;
    LevelStat * damageStat;
}

@property (nonatomic,retain) UserManager * userManager;
@property (nonatomic) double lastStablegameTimer;
@property (nonatomic) int lastStablecurrentRound;
@property (nonatomic) int lastStablelives;
@property (nonatomic) int lastStableenergy;
@property (nonatomic) int lastStablescore;
@property (nonatomic) int lastStabledamage;
@property (nonatomic) int lastStablekills;
@property (nonatomic) int killedThisRound;
@property (nonatomic) int currentRound;
@property (nonatomic) int lives;
@property (nonatomic) int energy;
@property (nonatomic) int score;
@property (nonatomic, retain) CCLayer * UILayer;
@property (nonatomic) int towerForThisRound;
@property (nonatomic) int currentGamePhase;
@property (nonatomic) float field_offsetX;
@property (nonatomic) float field_offsetY;
@property (nonatomic) BOOL zoomed;
@property (nonatomic, retain) NSMutableDictionary * goalpoints;
@property (nonatomic, retain) PathFinding * pathFinder;
@property (nonatomic, retain) CreepSpawner * mainSpawner;
@property (nonatomic, retain) CombatManager * combatManager;
@property (nonatomic, retain) TowerMixer * towerMixer;
@property (nonatomic, retain) TowerManager * towerManager;
@property (nonatomic, retain) TextureLibrary * textureLibrary;
@property (nonatomic, retain) CCSprite * rangeIndicatorSprite;
@property (nonatomic, retain) CCBitmapFontAtlas * phaseDisplay;
@property (nonatomic, retain) CCBitmapFontAtlas * levelDisplay;
@property (nonatomic, retain) CCBitmapFontAtlas * livesDisplay;
@property (nonatomic, retain) CCBitmapFontAtlas * scoreDisplay;
@property (nonatomic, retain) CCBitmapFontAtlas * DPSDisplay;
@property (nonatomic, retain) CCBitmapFontAtlas * energyDisplay;
@property (nonatomic, retain) CCBitmapFontAtlas * MultiplierDisplay;
@property (nonatomic, retain) TouchHandler * touchHandler;
@property (nonatomic, retain) BaseTower * currentTower;
@property (nonatomic, retain) NSMutableArray * towers;
@property (nonatomic, retain) NSMutableArray * pendingTowers;
@property (nonatomic, retain) LevelManager * levelManager;

+(id) scene;
+(id) sceneWithLoad;

- (void)addEffect:(BaseEffect*)effect;
- (void)removeEffect:(BaseEffect*)effect;
- (void)onContinue:(id)sender;
- (void)onScore:(id)sender;
- (void)onTime:(id)sender;
- (void)onDamage:(id)sender;
- (void)showHighScoreForStatType:(int)statType stat:(LevelStat*)stat;
- (void)createLevelUpdateLabel:(int)x y:(int)y layer:(CCLayer*)layer string:(NSString*)string;
- (void)midLevelUpdate:(int)backgroundid;
- (void)loadGame:(NSString*)towerData levelData:(NSString*)levelData gameString:(NSString*)gameString;
- (NSString*)levelsToData;
- (NSString*)mapToData;
- (void)onMainMenu:(id)sender;
- (void)onResume:(id)sender;
- (void)onPause:(id)sender;
- (void)initUILayer;
- (void)updateDPS:(int)damage;
- (void)awardPoints:(int)points;
- (void)decrementLives;
- (CGPoint)getScaledPosition;
- (void)initField;
- (void)updateScaleAnimated:(float)duration newScale:(float)newScale;
- (void)updateScrollOffsetWithDeltaX:(float)DeltaX DeltaY:(float)DeltaY;
- (void)removeTower:(BaseTower*)tower;
- (void)showRangeIndicatorForTower:(BaseTower*)tower;
- (float)distanceBetweenPointsA:(CGPoint)a B:(CGPoint)b;
- (float)clampFloatInclusive:(float)value highValue:(float)highValue lowValue:(float)lowValue;
- (void)StartPlacePhase:(BaseTower*)tower;
- (void)removeCreep:(Creep*)creep;
- (void)addCreep:(Creep*)creep;
- (CGPoint)parseMap;
//- (BOOL)checkAny2x2SpaceStatus:(int)x :(int)y :(int)Status;
//- (BOOL)check2x2SpaceStatus:(int)x :(int)y :(int)Status;
//- (void)set2x2SpaceStatus:(int)x :(int)y :(int)newStatus;
//- (void)set2x2SpaceLevel:(int)x :(int)y :(int)newLevel;
- (BOOL)check1x1SpaceStatus:(int)x :(int)y :(int)Status;
- (void)set1x1SpaceStatus:(int)x :(int)y :(int)newStatus;
- (void)set1x1SpaceLevel:(int)x :(int)y :(int)newLevel;
- (BOOL)check1x1SpaceWalkable:(int)x :(int)y;
- (void)StartBuildPhase;
- (void)StartCreepsPhase;
- (void)StartPickPhase;
- (void)tick:(ccTime)elapsed;
- (BaseTower*)GenerateRandomTowerAtPosition:(CGPoint)position;

@end
