//
//  GameField.m
//  ChemTD
//
//  Created by Eric Lanz on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameFieldScene.h"
#import "PathFinding.h"
#import "BaseTower.h"
#import "Colors.h"
#import "CreepSpawner.h"
#import "Creep.h"
#import "CCTouchDispatcher.h"
#import "TowerMixer.h"
#import "TowerManager.h"
#import "CombatManager.h"
#import "TextureLibrary.h"
#import "TouchHandler.h"
#import "LevelManager.h"
#import "USEnglishStrings.h"
#import "ChemTDAppDelegate.h"
#import "MainMenuScene.h"
#import "UserManager.h"
#import "BaseEffect.h"
#import "TutorialManager.h"

@implementation GameFieldScene

@synthesize tutorialManager;

@synthesize lastStablegameTimer;
@synthesize lastStablecurrentRound;
@synthesize lastStablelives;
@synthesize lastStableenergy;
@synthesize lastStablescore;

@synthesize lives;
@synthesize energy;
@synthesize score;
@synthesize pathFinder;
@synthesize goalpoints;
@synthesize mainSpawner;
@synthesize currentRound;
@synthesize combatManager;
@synthesize towerMixer;
@synthesize towerManager;
@synthesize textureLibrary;
@synthesize rangeIndicatorSprite;
@synthesize UILayer;
@synthesize phaseDisplay;
@synthesize levelDisplay;
@synthesize livesDisplay;
@synthesize scoreDisplay;
@synthesize DPSDisplay;
@synthesize energyDisplay;
@synthesize MultiplierDisplay;
@synthesize touchHandler;
@synthesize currentGamePhase;
@synthesize currentTower;
@synthesize field_offsetX;
@synthesize field_offsetY;
@synthesize towers;
@synthesize pendingTowers;
@synthesize towerForThisRound;
//@synthesize zoomed;
@synthesize levelManager;
@synthesize userManager;
@synthesize killedThisRound;
@synthesize lastStabledamage;
@synthesize lastStablekills;
@synthesize startPosition;
@synthesize exploreOpen;

+(id) scene
{
	CCScene *scene = [CCScene node];
	GameFieldScene *layer = [GameFieldScene node];
    layer.tag = CCNodeTag_GameField;
    [layer setContentSize:CGSizeMake(field_width, field_height)];
	[scene addChild: layer];
    [layer StartBuildPhase];
	return scene;
}

+(id) sceneWithLoad
{
	CCScene *scene = [CCScene node];
	GameFieldScene *layer = [GameFieldScene node];
    layer.tag = CCNodeTag_GameField;
    [layer setContentSize:CGSizeMake(field_width, field_height)];
	[scene addChild: layer];
    [layer.userManager loadGameWithField:layer];
    [layer StartBuildPhase];
	return scene;
}

-(id) init
{
	if( (self=[super init] )) 
    {
        field_offsetX = 0.0;
        field_offsetY = 0.0;
        currentRound = 0;
        towerForThisRound = 0;
        lives = Initial_Lives;
        score = 0;
        scoreForLevel = 0;
        energy = Initial_Energy;
        multiplier = Initial_Multiplier;
        roundTimer = 0.0;
        dpsTimer = 0.0;
        damageThisRound = 0;
        killedThisRound = 0;
        lastStabledamage = 0;
        lastStablekills = 0;
        mainSpawner = nil;
        pathFinder = nil;
        exploreOpen = NO;
        
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        textureLibrary = delegate.textureLibrary;
        userManager = delegate.userManager;
        towerMixer = [[TowerMixer alloc] initWithGameField:self];
        towerManager = [[TowerManager alloc] initWithGameField:self];
        combatManager = [[CombatManager alloc] initWithGameField:self];
        touchHandler = [[TouchHandler alloc] initWithGameField:self];
        levelManager = [[LevelManager alloc] initWithGameField:self];
        pathFinder = [[PathFinding alloc] init];
        
        [self initField];

        goalpoints = [[NSMutableDictionary alloc] init];
        towers = [[NSMutableArray alloc] init];
        pendingTowers = [[NSMutableArray alloc] init];
        fieldEffects = [[NSMutableArray alloc] init];
        startPosition = [self parseMap];
        
        rangeIndicatorSprite = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_RANGEINDICATOR]];
        rangeIndicatorSprite.position = ccp(200,200);
        [self addChild:rangeIndicatorSprite z:3];
        rangeIndicatorSprite.visible = NO;
              
        phaseDisplay = [[CCLabelBMFont labelWithString:String_NULL fntFile:Font_UIPrimary] retain];
        phaseDisplay.position = ccp(device_width - 100, device_height - 177);
        phaseDisplay.color = Color_Black;
        [phaseDisplay setString:String_PhaseLabelBuild];
        
        levelDisplay = [[CCLabelBMFont labelWithString:String_NULL fntFile:Font_UIPrimary] retain];
        levelDisplay.position = ccp(device_width - 100, device_height - 207);
        levelDisplay.color = Color_Black;
        [levelDisplay setString:[levelManager GetCurrentLevel].levelName];
        
        livesDisplay = [[CCLabelBMFont labelWithString:String_NULL fntFile:Font_UIPrimary] retain];
        livesDisplay.position = ccp(device_width - 100, device_height - 237);
        livesDisplay.color = Color_Black;
        [livesDisplay setString:[NSString stringWithFormat:@"%@ %d", String_LivesLabel, lives]];
        
        scoreDisplay = [[CCLabelBMFont labelWithString:String_NULL fntFile:Font_UIPrimary] retain];
        scoreDisplay.position = ccp(device_width - 100, device_height - 267);
        scoreDisplay.color = Color_Black;
        [scoreDisplay setString:[NSString stringWithFormat:@"%@ %d", String_ScoreLabel, score]];
    
        energyDisplay = [[CCLabelBMFont labelWithString:String_NULL fntFile:Font_UIPrimary] retain];
        energyDisplay.position = ccp(device_width - 100, device_height - 297);
        energyDisplay.color = Color_Black;
        [energyDisplay setString:[NSString stringWithFormat:@"%@ %d", String_EnergyLabel, energy]];

        DPSDisplay = [[CCLabelBMFont labelWithString:String_NULL fntFile:Font_UIPrimary] retain];
        DPSDisplay.position = ccp(device_width/2-25, 15);
        DPSDisplay.color = Color_Black;
        [DPSDisplay setString:[NSString stringWithFormat:@"%@: %d", String_DPSLabel, 0]];
        
        MultiplierDisplay = [[CCLabelBMFont labelWithString:String_NULL fntFile:Font_UIPrimary] retain];
        MultiplierDisplay.position = ccp(device_width/2 + 200, 15);
        MultiplierDisplay.color = Color_Black;
        [MultiplierDisplay setString:[NSString stringWithFormat:@"%@ %d", String_MultiplierLabel, multiplier]];
        
        UILayer = nil;
        
        self.isTouchEnabled = YES;
        [self schedule:@selector(tick:)];
        self.scale = min_zoom;
        self.position = ccp(-256,-192);
        [self updateScrollOffsetWithDeltaX:0 DeltaY:0];
        actualWidth = 1024.0;
        actualHeight = 768.0;
        self.anchorPoint = ccp(0,0);
	}
	return self;
}

- (void)addEffect:(BaseEffect*)effect
{
    [fieldEffects addObject:effect];
    [effect startEffect];
}

- (void)removeEffect:(BaseEffect*)effect
{
    [effect finishEffect];
    [fieldEffects removeObject:effect];
}

- (void) initUILayer
{
    UILayer = [[CCLayer alloc] init];
    UILayer.tag = CCNodeTag_UILayer;
    [UILayer setContentSize:CGSizeMake(1024, 768)];
    UILayer.position = ccp(0, 0);
    
    [UILayer addChild:phaseDisplay];
    [UILayer addChild:levelDisplay];
    [UILayer addChild:livesDisplay];
    [UILayer addChild:scoreDisplay];
    [UILayer addChild:DPSDisplay];
    [UILayer addChild:energyDisplay];
    [UILayer addChild:MultiplierDisplay];
    [UILayer addChild:towerMixer.elementMixerSprite];
    [UILayer addChild:towerManager.towerManagerSprite];
    
    pauseBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_PAUSEBTN]];
    menuItemPause = [CCMenuItemSprite itemFromNormalSprite:pauseBtn selectedSprite:nil 
                                                       disabledSprite:nil target:self selector:@selector(onPause:)];
    CCSprite * exploreMiniBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_EXPLOREMINIBTN]];
    CCMenuItemSprite * menuItemExploreMini = [CCMenuItemSprite itemFromNormalSprite:exploreMiniBtn selectedSprite:nil 
                                            disabledSprite:nil target:self selector:@selector(onExplore:)];
    pauseMenu = [CCMenu menuWithItems: menuItemPause, menuItemExploreMini, nil];
    pauseMenu.position = ccp(device_width - 100, device_height - 400);
    [pauseMenu alignItemsVerticallyWithPadding:20];
    [UILayer addChild:pauseMenu z:1];
    
    [[CCDirector sharedDirector].runningScene addChild: UILayer z:1]; 
    
    tutorialManager = [[TutorialManager alloc] initWithField:self];
    [tutorialManager showIntroTutorial];
}

- (void)onMainMenu:(id)sender
{
    [[CCDirector sharedDirector] resume];
    self.isTouchEnabled = YES;
    [towerManager enableAll];
    [towerMixer enableAll];
    menuItemPause.isEnabled = YES;
    [userManager saveGame];
    [[CCDirector sharedDirector] replaceScene:[MainMenuScene scene]];
}

- (void)onResume:(id)sender
{
    [[CCDirector sharedDirector].runningScene removeChild: minimenuLayer cleanup:YES];
    [[CCDirector sharedDirector] resume];
    self.isTouchEnabled = YES;
    [towerManager enableAll];
    [towerMixer enableAll];
    menuItemPause.isEnabled = YES;
}

- (void)onRestoreFromExplore
{    
    [miniMenuBackground runAction:[CCFadeOut actionWithDuration:0.3]];
    [[CCDirector sharedDirector] resume];
    exploreOpen = NO;
}

- (void) onExplore:(id)sender
{
    minimenuLayer = [[CCLayer alloc] init];
    minimenuLayer.tag = CCNodeTag_Minimenu;
    [minimenuLayer setContentSize:CGSizeMake(1024, 768)];
    minimenuLayer.position = ccp(0,0);
    
    miniMenuBackground = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_EXPLORERBACKGROUND]];
    
    miniMenuBackground.position = ccp(device_width/2, device_height/2);
    
    [miniMenuBackground runAction:[CCFadeIn actionWithDuration:0.3]];
    [minimenuLayer addChild:miniMenuBackground];
    
    exploreOpen = YES;
    
    [UILayer addChild:minimenuLayer z:5];
    menuItemPause.isEnabled = NO;
    
    [[CCDirector sharedDirector] pause];
}

- (void) onPause:(id)sender
{
    minimenuLayer = [[CCLayer alloc] init];
    minimenuLayer.tag = CCNodeTag_Minimenu;
    [minimenuLayer setContentSize:CGSizeMake(1024, 768)];
    minimenuLayer.position = ccp(0,0);
    
    miniMenuBackground = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MINIMENU]];
    miniMenuBackground.position = ccp(device_width/2, device_height/2);
    [minimenuLayer addChild:miniMenuBackground];
    
    mainMenuBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MAINMENUBTN]];
    menuItemMainMenu = [CCMenuItemSprite itemFromNormalSprite:mainMenuBtn selectedSprite:nil 
                                             disabledSprite:nil target:self selector:@selector(onMainMenu:)];
    resumeBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_RESUMEBTN]];
    menuItemResume = [CCMenuItemSprite itemFromNormalSprite:resumeBtn selectedSprite:nil 
                                             disabledSprite:nil target:self selector:@selector(onResume:)];
    miniMenu = [CCMenu menuWithItems: menuItemResume, menuItemMainMenu, nil];
    miniMenu.position = ccp(device_width/2-10, device_height/2);
    [miniMenu alignItemsVerticallyWithPadding:20];
    [minimenuLayer addChild:miniMenu z:1];
    [[CCDirector sharedDirector] pause];
    self.isTouchEnabled = NO;
    [towerManager disableAll];
    [towerMixer disableAll];
    menuItemPause.isEnabled = NO;
    [[CCDirector sharedDirector].runningScene addChild: minimenuLayer z:2]; 
}

- (void) tick:(ccTime)elapsed
{    
    if (!UILayer)
    {
        [self initUILayer];
    }
    
    roundTimer += elapsed;
    
    for (BaseEffect * effect in fieldEffects)
    {
        [effect updateEffect:elapsed];
    }
    
    [combatManager tick:elapsed];
    [touchHandler ticker:elapsed];
    
    if (mainSpawner) [mainSpawner tick:elapsed];
    if (currentGamePhase == GamePhase_Creeps)
    {
        dpsTimer += elapsed;
        float DPS = (float)damageThisRound / dpsTimer;
        [DPSDisplay setString:[NSString stringWithFormat:@"%@ %.0f",String_DPSLabel, DPS]];
        multiplier = 1.0 + (DPS/100.0);
        [MultiplierDisplay setString:[NSString stringWithFormat:@"%@ %.1fX",String_MultiplierLabel, multiplier]];
        
        
        for (BaseTower * tower in towers)
        {
            if (tower.towerType != TowerType_Base)
            {
                [tower tick:elapsed];
            }
        }
    }
}

- (BaseTower*)GenerateRandomTowerAtPosition:(CGPoint)position {
    if (towerForThisRound == 0)
    {
        towerForThisRound = 1 + arc4random() % 4;
    }
    ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
    BaseTower * tower;
    switch (towerForThisRound) {
        case 1: tower = [delegate constructTowerWithType:TowerType_Hydrogen gameField:self addToField:YES]; break;
        case 2: tower = [delegate constructTowerWithType:TowerType_Oxygen gameField:self addToField:YES]; break;
        case 3: tower = [delegate constructTowerWithType:TowerType_Nitrogen gameField:self addToField:YES]; break;
        case 4: tower = [delegate constructTowerWithType:TowerType_Carbon gameField:self addToField:YES]; break;
//        case 5: tower = [delegate constructTowerWithType:TowerType_Sodium gameField:self addToField:YES]; break;
//        case 6: tower = [delegate constructTowerWithType:TowerType_Chlorine gameField:self addToField:YES]; break;
        default:
            return nil;
            break;
    }
    [tower setPositionWithX:position.x*cellSize Y:position.y*cellSize];
    [tower show];
    return tower;
}

-(void)removeTower:(BaseTower*)tower
{
    int cellX = [tower getTowerPosition].x/cellSize;
    int cellY = [tower getTowerPosition].y/cellSize;
    [self set1x1SpaceStatus:cellX :cellY :TILE_OPEN];
    [tower hide];
    [towers removeObject:tower];
}

- (void)removeCreep:(Creep*)creep
{
    for (BaseTower * tower in towers)
    {
        [tower creepGone:creep];
    }
    [self removeChild:creep.creepSprite cleanup:NO];
}

- (void)addCreep:(Creep*)creep
{
    [self addChild:creep.creepSprite z:3];
}

- (void) showRangeIndicatorForTower:(BaseTower*)tower
{
    rangeIndicatorSprite.position = [tower getTowerPosition];
    rangeIndicatorSprite.scale = (float)tower.shotRange / 50.0;
    rangeIndicatorSprite.visible = true;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [touchHandler HandleccTouchesBegan:touches withEvent:event];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [touchHandler HandleccTouchesMoved:touches withEvent:event];
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [touchHandler HandleccTouchesEnded:touches withEvent:event];
}

- (void)StartPlacePhase:(BaseTower*)tower
{
    [tutorialManager showPlaceTutorial];
    [phaseDisplay setString:String_PhaseLabelPlace];
    //[mixer hide];
    currentGamePhase = GamePhase_Place;
    currentTower = tower;
}

- (void)StartPickPhase
{
    [tutorialManager showMixTutorial];
    
    [phaseDisplay setString:String_PhaseLabelPick];
    //[mixer show];
    currentGamePhase = GamePhase_Pick;
    for (BaseTower * tower in pendingTowers)
    {
        [tower startGlowAction];
    }
}

- (void)StartCreepsPhase
{
    static BOOL creepTutorialViewed = NO;
    if (!creepTutorialViewed)
    {
        [tutorialManager showCreepsTutorial];
        creepTutorialViewed = YES;
    }
    
    [phaseDisplay setString:String_PhaseLabelCreeps];
    //[mixer hide];
    if (!pathFinder)
    {
        pathFinder = [[PathFinding alloc] init];
    }
    currentGamePhase = GamePhase_Creeps;
    [pathFinder resetPathCache];
    for (BaseTower * tower in pendingTowers)
    {
        //printf ("trying to mark %lf, %lf\n", tower.towerSprite.position.x/cellSize, (tower.towerSprite.position.y/cellSize));
        if (tower == currentTower)
        {
            [tower setColor:Color_White];
            [towers addObject:tower];
            [tower setPower:tower.towerPower];
            [tower show];
            [self set1x1SpaceStatus:[tower getTowerPosition].x/cellSize :([tower getTowerPosition].y/cellSize) :TILE_FINALTOWER + tower.towerType];
            [self set1x1SpaceLevel:[tower getTowerPosition].x/cellSize :([tower getTowerPosition].y/cellSize) :tower.towerPower];
        } else 
        {
            BaseTower * newtower = [[BaseTower alloc] initWithGameField:self addToField:YES];
            [newtower setPositionWithX:[tower getTowerPosition].x Y:[tower getTowerPosition].y];
            [newtower show];
            [tower hide];
            [towers addObject:newtower];
            [self set1x1SpaceStatus:[newtower getTowerPosition].x/cellSize :([newtower getTowerPosition].y/cellSize) :TILE_FINALTOWER + newtower.towerType];
            [self set1x1SpaceLevel:[newtower getTowerPosition].x/cellSize :([newtower getTowerPosition].y/cellSize) :newtower.towerPower];
        }
    }
    [pendingTowers removeAllObjects];
    NSMutableArray * usedTowers = [[NSMutableArray alloc] init];
    for (BaseTower * tower in towers)
    {
        if (tower.usedByMixer)
        {
            [usedTowers addObject:tower];
        }
    }
    for (BaseTower * tower in usedTowers)
    {
        BaseTower * newtower = [[BaseTower alloc] initWithGameField:self addToField:YES];
        [newtower setPositionWithX:[tower getTowerPosition].x Y:[tower getTowerPosition].y];
        [newtower show];
        [tower hide];
        [towers addObject:newtower];
        [towers removeObject:tower];
    }
    mainSpawner = [[CreepSpawner alloc] initWithPos:startPosition :[UIColor orangeColor]];
    for (BaseTower * tower in towers)
    {
        tower.currentSpawner = mainSpawner;
    }
}

- (void)createLevelUpdateLabel:(int)x y:(int)y layer:(CCLayer*)layer string:(NSString*)string
{
    CCLabelBMFont * label = [[CCLabelBMFont labelWithString:string fntFile:Font_UIPrimary] retain];
    label.position = ccp(x, y);
    label.color = Color_Black;
    [layer addChild:label z:4];
}

- (void)showHighScoreForStatType:(int)statType stat:(LevelStat*)stat
{
    int row1Y = device_height - 208;
    int row2Y = device_height - 274;
    int row3Y = device_height - 328;
    int row4Y = device_height - 368;
    int row5Y = device_height - 408;
    int row6Y = device_height - 448;
    int row7Y = device_height - 488;
    int col1headerX = 244;
    int col1numberX = 61;
    int col1nameX = 206;
    int col1valueX = 382;
    
    if (highscoreLayer)
    {
        [[CCDirector sharedDirector].runningScene removeChild:highscoreLayer cleanup:YES];
    }
    
    highscoreLayer = [[CCLayer alloc] init];
    [highscoreLayer setContentSize:CGSizeMake(1024, 768)];
    highscoreLayer.position = ccp(0,0);
    
    [self createLevelUpdateLabel:col1headerX y:row1Y layer:highscoreLayer string:String_Ranking];
    [self createLevelUpdateLabel:col1numberX y:row2Y layer:highscoreLayer string:String_RankingHeaderRank];
    [self createLevelUpdateLabel:col1nameX y:row2Y layer:highscoreLayer string:String_RankingHeaderName];
    switch (statType) {
        case StatType_CompletionTime:
            [self createLevelUpdateLabel:col1valueX y:row2Y layer:highscoreLayer string:String_RankingStatTypeTime];
            [self createLevelUpdateLabel:col1valueX y:row3Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue1/1000, stat.statValue1%1000]];
            [self createLevelUpdateLabel:col1valueX y:row4Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue2/1000, stat.statValue2%1000]];
            [self createLevelUpdateLabel:col1valueX y:row5Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue3/1000, stat.statValue3%1000]];
            [self createLevelUpdateLabel:col1valueX y:row6Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue4/1000, stat.statValue4%1000]];
            [self createLevelUpdateLabel:col1valueX y:row7Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue5/1000, stat.statValue5%1000]];
            break;
        case StatType_Score:
            [self createLevelUpdateLabel:col1valueX y:row2Y layer:highscoreLayer string:String_RankingStatTypeScore];
            [self createLevelUpdateLabel:col1valueX y:row3Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue1]];
            [self createLevelUpdateLabel:col1valueX y:row4Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue2]];
            [self createLevelUpdateLabel:col1valueX y:row5Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue3]];
            [self createLevelUpdateLabel:col1valueX y:row6Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue4]];
            [self createLevelUpdateLabel:col1valueX y:row7Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue5]];
            break;
        case StatType_DamageDone:
            [self createLevelUpdateLabel:col1valueX y:row2Y layer:highscoreLayer string:String_RankingStatTypeDamage];
            [self createLevelUpdateLabel:col1valueX y:row3Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue1]];
            [self createLevelUpdateLabel:col1valueX y:row4Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue2]];
            [self createLevelUpdateLabel:col1valueX y:row5Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue3]];
            [self createLevelUpdateLabel:col1valueX y:row6Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue4]];
            [self createLevelUpdateLabel:col1valueX y:row7Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue5]];
            break;
        default:
            break;
    }
    [self createLevelUpdateLabel:col1numberX y:row3Y layer:highscoreLayer string:@"#1"];
    [self createLevelUpdateLabel:col1numberX y:row4Y layer:highscoreLayer string:@"#2"];
    [self createLevelUpdateLabel:col1numberX y:row5Y layer:highscoreLayer string:@"#3"];
    [self createLevelUpdateLabel:col1numberX y:row6Y layer:highscoreLayer string:@"#4"];
    [self createLevelUpdateLabel:col1numberX y:row7Y layer:highscoreLayer string:@"#5"];
    [self createLevelUpdateLabel:col1nameX y:row3Y layer:highscoreLayer string:stat.name1];
    [self createLevelUpdateLabel:col1nameX y:row4Y layer:highscoreLayer string:stat.name2];
    [self createLevelUpdateLabel:col1nameX y:row5Y layer:highscoreLayer string:stat.name3];
    [self createLevelUpdateLabel:col1nameX y:row6Y layer:highscoreLayer string:stat.name4];
    [self createLevelUpdateLabel:col1nameX y:row7Y layer:highscoreLayer string:stat.name5];
    
    CCSprite * scoreBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_SCOREBTN]];
    CCSprite * timeBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_TIMEBTN]];
    CCSprite * damageBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_DAMAGEBTN]];
    
    CCMenuItemSprite * menuItemScore = [CCMenuItemSprite itemFromNormalSprite:scoreBtn selectedSprite:nil 
                                                     disabledSprite:nil target:self selector:@selector(onScore:)];
    CCMenuItemSprite * menuItemTime = [CCMenuItemSprite itemFromNormalSprite:timeBtn selectedSprite:nil 
                                                               disabledSprite:nil target:self selector:@selector(onTime:)];
    CCMenuItemSprite * menuItemDamage = [CCMenuItemSprite itemFromNormalSprite:damageBtn selectedSprite:nil 
                                                               disabledSprite:nil target:self selector:@selector(onDamage:)];
    
    CCMenu * statTypeMenu = [CCMenu menuWithItems: menuItemScore, menuItemTime, menuItemDamage, nil];
    [statTypeMenu alignItemsHorizontallyWithPadding:20];
    statTypeMenu.position = ccp(col1headerX,row7Y-40);
    [highscoreLayer addChild:statTypeMenu z:4];
    
    [[CCDirector sharedDirector].runningScene addChild: highscoreLayer z:3]; 
}

- (void)onDamage:(id)sender
{
    [self showHighScoreForStatType:StatType_DamageDone stat:damageStat];
}

- (void)onTime:(id)sender
{
    [self showHighScoreForStatType:StatType_CompletionTime stat:timeStat];
}

- (void)onScore:(id)sender
{
    [self showHighScoreForStatType:StatType_Score stat:scoreStat];
}

- (void)midLevelUpdate:(int)backgroundid
{
    backgroundId =backgroundid;
    
    if (minimenuLayer)
        [[CCDirector sharedDirector].runningScene removeChild: minimenuLayer cleanup:YES]; 
    if (highscoreLayer)
        [[CCDirector sharedDirector].runningScene removeChild: highscoreLayer cleanup:YES]; 
    
    minimenuLayer = [[CCLayer alloc] init];
    minimenuLayer.tag = CCNodeTag_Minimenu;
    [minimenuLayer setContentSize:CGSizeMake(1024, 768)];
    minimenuLayer.position = ccp(0,0);
    
    miniMenuBackground = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:backgroundid]];
    miniMenuBackground.position = ccp(device_width/2, device_height/2);
    [minimenuLayer addChild:miniMenuBackground];
    
    if (backgroundId == UITEXTURE_LEVELCLEARBACKGROUND)
    {
        statArray = [userManager submitLevelStats:levelManager.currentLevel completionTime:roundTimer*1000  damageDone:damageThisRound 
                                            score:scoreForLevel creepsKilled:killedThisRound];
    }
    else 
    {
        BOOL won = false;
        if (backgroundId == UITEXTURE_YOUWINBACKGROUND)
            won = true;
        
        lastStablegameTimer += roundTimer;
        lastStablekills += killedThisRound;
        lastStabledamage += damageThisRound;
        
        NSString * towerstring = @"";
        NSMutableDictionary * towerDictionary = [[NSMutableDictionary alloc] init];
        for (BaseTower * t in towers)
        {
            if (t.towerType > 0)
            {
                if ([towerDictionary objectForKey:[NSNumber numberWithInt:t.towerType]])
                {
                    int currentValue = [(NSNumber*)[towerDictionary objectForKey:[NSNumber numberWithInt:t.towerType]] intValue];
                    currentValue +=1;
                    [towerDictionary setObject:[NSNumber numberWithInt:currentValue] forKey:[NSNumber numberWithInt:t.towerType]];
                }
                else 
                {
                    [towerDictionary setObject:[NSNumber numberWithInt:1] forKey:[NSNumber numberWithInt:t.towerType]];
                }
            }
        }
        
        for (NSNumber * key in [towerDictionary allKeys])
        {
            towerstring = [towerstring stringByAppendingFormat:@"%dB%dA", [key intValue], [(NSNumber*)[towerDictionary objectForKey:key] intValue]];
        }
        
        towerstring = [towerstring substringToIndex:[towerstring length] - 1];
        
        statArray = [userManager submitFinishedGame:won towers:towerstring];
    }
    
    timeStat = [statArray objectAtIndex:StatType_CompletionTime];
    scoreStat = [statArray objectAtIndex:StatType_Score];
    damageStat = [statArray objectAtIndex:StatType_DamageDone];
    
    int row1Y = device_height - 208;
    int row2Y = device_height - 274;
    int row3Y = device_height - 328;
    int row4Y = device_height - 368;
    int row5Y = device_height - 408;
    int row6Y = device_height - 448;
    int col2headerX = 775;
    int col2statX = 640;
    int col2rankX = 924;
    
    if (backgroundid == UITEXTURE_LEVELCLEARBACKGROUND)
    {
        [self createLevelUpdateLabel:col2headerX y:row1Y layer:minimenuLayer string:[NSString stringWithFormat:@"%@ %@"
                                                                                     , String_CompletedLabel
                                                                                     , [levelManager GetCurrentLevel].levelName]];
    }
    else 
    {
        [self createLevelUpdateLabel:col2headerX y:row1Y layer:minimenuLayer string:String_GameSummaryLabel];
    }

    [self createLevelUpdateLabel:col2rankX y:row2Y layer:minimenuLayer string:String_RankingHeaderRank];
    [self createLevelUpdateLabel:col2statX y:row6Y layer:minimenuLayer string:String_KilledLabel];
    [self createLevelUpdateLabel:col2statX y:row3Y layer:minimenuLayer string:String_RankingStatTypeTime];
    [self createLevelUpdateLabel:col2statX y:row4Y layer:minimenuLayer string:String_RankingStatTypeDamage];
    [self createLevelUpdateLabel:col2statX y:row5Y layer:minimenuLayer string:String_RankingStatTypeScore];
    
    if (backgroundid == UITEXTURE_LEVELCLEARBACKGROUND)
    {
        int timeinmsec = roundTimer*1000;
        int seconds = timeinmsec/1000;
        int milliseconds = timeinmsec%1000;
        
        [self createLevelUpdateLabel:col2headerX y:row6Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d/%d", killedThisRound, [levelManager GetCurrentLevel].creepCount]];
        [self createLevelUpdateLabel:col2headerX y:row3Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d.%d", seconds, milliseconds]];
        [self createLevelUpdateLabel:col2headerX y:row4Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d", damageThisRound]];
        [self createLevelUpdateLabel:col2headerX y:row5Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d", scoreForLevel]];
    }
    else 
    {
        int timeinmsec = lastStablegameTimer*1000;
        int seconds = timeinmsec/1000;
        int milliseconds = timeinmsec%1000;
        
        [self createLevelUpdateLabel:col2headerX y:row6Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d/%d", lastStablekills, levelManager.totalCreeps]];
        [self createLevelUpdateLabel:col2headerX y:row3Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d.%d", seconds, milliseconds]];
        [self createLevelUpdateLabel:col2headerX y:row4Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d", lastStabledamage]];
        [self createLevelUpdateLabel:col2headerX y:row5Y layer:minimenuLayer string:[NSString stringWithFormat:@"%d", score]];    
    }

    
    [self createLevelUpdateLabel:col2rankX y:row3Y layer:minimenuLayer string:[NSString stringWithFormat:@"#%d", timeStat.playerRank]];
    [self createLevelUpdateLabel:col2rankX y:row4Y layer:minimenuLayer string:[NSString stringWithFormat:@"#%d", damageStat.playerRank]];
    [self createLevelUpdateLabel:col2rankX y:row5Y layer:minimenuLayer string:[NSString stringWithFormat:@"#%d", scoreStat.playerRank]];
    
    CCSprite * continueBtn;
    CCMenuItemSprite * menuItemContinue;
    
    if (backgroundid == UITEXTURE_LEVELCLEARBACKGROUND)
    {
        continueBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_CONTINUEBTN]];
        menuItemContinue = [CCMenuItemSprite itemFromNormalSprite:continueBtn selectedSprite:nil 
                                                   disabledSprite:nil target:self selector:@selector(onContinue:)];
    }
    else
    {
        continueBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MAINMENUBTN]];
        menuItemContinue = [CCMenuItemSprite itemFromNormalSprite:continueBtn selectedSprite:nil 
                                                   disabledSprite:nil target:self selector:@selector(onMainMenu:)];
    }
    
    
    menuItemContinue.scaleX = .75;
    menuItemContinue.scaleY = .75;
    
    CCMenu * continueMenu = [CCMenu menuWithItems: menuItemContinue, nil];
    continueMenu.position = ccp(col2headerX,row6Y-75);
    [minimenuLayer addChild:continueMenu z:4];
    
    self.isTouchEnabled = NO;
    [towerManager disableAll];
    [towerMixer disableAll];
    menuItemPause.isEnabled = NO;
    
    id action1 = [CCDelayTime actionWithDuration:1.0];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(showMenu)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [self runAction:action3];
}

- (void)showMenu
{

    
    [self showHighScoreForStatType:StatType_Score stat:scoreStat];
    
    [[CCDirector sharedDirector].runningScene addChild: minimenuLayer z:2]; 
}

- (void)onContinue:(id)sender
{
    if (levelManager.currentLevel == levelManager.levelCount)
    {
        [self midLevelUpdate:UITEXTURE_YOUWINBACKGROUND];
    }
    else 
    {
        self.isTouchEnabled = YES;
        [towerManager enableAll];
        [towerMixer enableAll];
        menuItemPause.isEnabled = YES;
        [[CCDirector sharedDirector].runningScene removeChild: highscoreLayer cleanup:YES]; 
        [[CCDirector sharedDirector].runningScene removeChild: minimenuLayer cleanup:YES]; 
    }
}

- (void)StartBuildPhase
{
    
    [phaseDisplay setString:String_PhaseLabelBuild];
    [levelDisplay setString:[levelManager GetCurrentLevel].levelName];
    //[mixer hide];
    currentTower = nil;
    currentGamePhase = GamePhase_Build;
    
    lastStablegameTimer += roundTimer;
    lastStablecurrentRound = levelManager.currentLevel;
    lastStablelives = lives;
    lastStableenergy = energy;
    lastStablescore = score;
    lastStablekills += killedThisRound;
    lastStabledamage += damageThisRound;
    
    roundTimer = 0.0;
    dpsTimer = 0.0;
    multiplier = 1.0;
    damageThisRound = 0;
    scoreForLevel = 0;
    killedThisRound = 0;
    
    int x,y = 0;
    for(y=0;y<mapHeight;y++)
    {
        for(x=0;x<mapWidth;x++)
        {
            lastStablelevels[x][y] = levels[x][y];
            lastStabletileMap[x][y] = tileMap[x][y];
        }
    }
    
    [DPSDisplay setString:[NSString stringWithFormat:@"%@ %d", String_DPSLabel, 0]];
    [MultiplierDisplay setString:[NSString stringWithFormat:@"%@ %.1fX", String_MultiplierLabel, multiplier]];
}

- (void)decrementLives
{
    lives --;
    [livesDisplay setString:[NSString stringWithFormat:@"%@ %d", String_LivesLabel, lives]];
    if (lives == 0)
    {
        [self midLevelUpdate:UITEXTURE_YOULOSEBACKGROUND];
    }
}

- (void)updateDPS:(int)damage
{
    damageThisRound += damage;
}

- (void)awardPoints:(int)points
{
    score += points * multiplier;
    scoreForLevel += points * multiplier;
    [scoreDisplay setString:[NSString stringWithFormat:@"%@ %d", String_ScoreLabel, score]];
}

// MARK: Utilities

- (void)updateScaleAnimated:(float)duration newScale:(float)newScale
{
    if (newScale < 0.7)
    {
        newScale = 0.666666667;
    }
    
    actualWidth = 1536 * newScale;
    actualHeight = 1152 * newScale;

    self.scale = newScale;
    [self updateScrollOffsetWithDeltaX:0 DeltaY:0];
    
    //self.position = ccp((device_width/2)-newWidth, (device_height/2)-newHeight);
    
    //id actionTo = [CCScaleTo actionWithDuration:duration scale:newScale];
    //id action2 = [CCMoveTo actionWithDuration:duration position:ccp(0,0)];
    
    //[self runAction:actionTo];
    //[self runAction:action2];
}

- (void)updateScrollOffsetWithDeltaX:(float)DeltaX DeltaY:(float)DeltaY
{
    field_offsetX += DeltaX;
    field_offsetY += DeltaY;
    
    if (field_offsetX < -(actualWidth-device_width))
        field_offsetX = -(actualWidth-device_width);
    if (field_offsetY < -(actualHeight-device_height))
        field_offsetY = -(actualHeight-device_height);

    if (field_offsetX > 0)
        field_offsetX = 0;
    if (field_offsetY > 0)
        field_offsetY = 0;
    
    self.position = ccp(0+field_offsetX, 0+field_offsetY);
    
//    printf("position = %f, %f offset = %f, %f size = %f, %f \n", self.position.x, self.position.y
//           , field_offsetX, field_offsetY, actualWidth, actualHeight);
    
//    
//    int limitXlow, limitYlow, limitXhigh, limitYhigh;
//    
//    field_offsetX = [self clampFloatInclusive:field_offsetX highValue:limitXhigh lowValue:limitXlow];
//    field_offsetY = [self clampFloatInclusive:field_offsetY highValue:limitYhigh lowValue:limitYlow];
//    
//    self.position = ccp([self getScaledPosition].x + field_offsetX, [self getScaledPosition].y + field_offsetY);
}

- (void)initField
{
    sprite_bottomright = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_BACKGROUND1LR]];
    sprite_bottomleft = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_BACKGROUND1LL]];
    sprite_topleft = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_BACKGROUND1UL]];
    sprite_topright = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_BACKGROUND1UR]];
    
    sprite_topleft.position = ccp(1024/2, 1152 - (1024/2));
    sprite_topright.position = ccp(1024 + 512/2, 1152 - (1024/2));
    sprite_bottomleft.position = ccp(1024/2, 1152 - (1024 + (128/2)));
    sprite_bottomright.position = ccp(1024 + 512/2, 1152 - (1024 + (128/2)));
    
    CCSprite * sprite_bottomrightfg = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_FOREGROUND1LR]];
    CCSprite * sprite_bottomleftfg = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_FOREGROUND1LL]];
    CCSprite * sprite_topleftfg = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_FOREGROUND1UL]];
    CCSprite * sprite_toprightfg = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:FIELDTEXTURE_FOREGROUND1UR]];
    
    sprite_topleftfg.position = ccp(1024/2, 1152 - (1024/2));
    sprite_toprightfg.position = ccp(1024 + 512/2, 1152 - (1024/2));
    sprite_bottomleftfg.position = ccp(1024/2, 1152 - (1024 + (128/2)));
    sprite_bottomrightfg.position = ccp(1024 + 512/2, 1152 - (1024 + (128/2)));
    
    [self updateScrollOffsetWithDeltaX:0 DeltaY:0];
    [self addChild:sprite_bottomright];
    [self addChild:sprite_bottomleft];
    [self addChild:sprite_topright];
    [self addChild:sprite_topleft];
    [self addChild:sprite_bottomrightfg z:9];
    [self addChild:sprite_bottomleftfg z:9];
    [self addChild:sprite_toprightfg z:9];
    [self addChild:sprite_topleftfg z:9];
}

- (CGPoint)getScaledPosition
{
    return ccp(0.0-((field_width/4.0)*(1.0-((self.scale-.5)*2))), 0.0-((field_height/4.0)*(1.0-((self.scale-.5)*2))));
}

- (CGPoint)parseMap
{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    NSString *mapPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"map.dat"];
    
    NSData *mapData = [fileManager contentsAtPath:mapPath];
    
    NSInteger dataLength;
    const uint8_t * dataBytes;
    
    CGPoint startPoint = CGPointMake(0, 0);
    
    int x,y = 0;
    for(y=0;y<mapHeight;y++)
    {
        for(x=0;x<mapWidth;x++)
        {
            tileMap[x][y] = TILE_OPEN;
            lastStablelevels[x][y] = TILE_OPEN;
            lastStabletileMap[x][y] = TILE_OPEN;
        }
    }
    
    dataLength = [mapData length];
    dataBytes = (const uint8_t*)[mapData bytes];
    
    
    int index = 0;
    for(y=0;y<=mapHeight;y++)
    {
        printf("\n");
        for(x=0;x<=mapWidth;x++)
        {
            //CCSprite * temp = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:COLORTEXTURE_BROWN]];
            
            int adjustedX = (x);
            int adjustedY = (mapHeight - (y+1));
            
            //temp.position = ccp(((adjustedX*48)+(48/2)), ((adjustedY*48)+(48/2)));
            //temp.scale = min_zoom;
            if (index < dataLength)
            {
                if (dataBytes[index] > 48 && dataBytes[index] < 84)
                {
                    printf("X");
                    //[temp setTexture:[textureLibrary GetTextureWithKey:COLORTEXTURE_GRAY]];
                    //[self addChild:temp];

                    
                    
                    if (dataBytes[index] == 49) {
                        [self set1x1SpaceStatus:adjustedX :adjustedY :TILE_BLOCKED];
                    } else if (dataBytes[index] == 50) {
                        [self set1x1SpaceStatus:adjustedX :adjustedY :TILE_BLOCKED];
                        
                    } else if (dataBytes[index] == 51) {
                        
                    } else if (dataBytes[index] == 57) {
                        [self set1x1SpaceStatus:adjustedX :adjustedY :TILE_BLOCKED];
                    }else if (dataBytes[index] >= 65 && dataBytes[index] <= 72) { //A
                        [self set1x1SpaceStatus:adjustedX :adjustedY :TILE_BLOCKED];
                        PathFindNode *goalNode = [PathFindNode node];
                        goalNode->nodeX = adjustedX;
                        goalNode->nodeY = adjustedY;
                        goalNode->parentNode = nil;
                        goalNode->cost = 0;
                        [goalpoints setObject:goalNode forKey:[NSNumber numberWithInt:dataBytes[index]-65]];
                    } else if (dataBytes[index] == 83) {
                        [self set1x1SpaceStatus:adjustedX :adjustedY :TILE_BLOCKED];
                        startPoint = ccp(adjustedX, adjustedY);
                    }
                }
                else
                {
                    printf("0");
                    //[self addChild:temp];
                }
                index ++;
            }
        }
    }
    return startPoint;
}

- (float)distanceBetweenPointsA:(CGPoint)a B:(CGPoint)b
{
    double firstDifference = (a.x - b.x);
    double secondDifference = (a.y - b.y);
    return sqrt((firstDifference*firstDifference)+(secondDifference*secondDifference));
}

- (float)clampFloatInclusive:(float)value highValue:(float)highValue lowValue:(float)lowValue
{
    if (value > highValue) value = highValue;
    if (value < lowValue) value = lowValue;
    return value;
}

//- (void)set2x2SpaceLevel:(int)x :(int)y :(int)newLevel
//{
//    int tile1X = x;
//    int tile1Y = y;
//    
//    [self set1x1SpaceLevel:tile1X :tile1Y :newLevel];
//}

- (void)set1x1SpaceLevel:(int)x :(int)y :(int)newLevel
{
    levels[x][y] = newLevel;
}

//- (void)set2x2SpaceStatus:(int)x :(int)y :(int)newStatus
//{
//    int tile1X = x;
//    int tile1Y = y;
//    
//    [self set1x1SpaceStatus:tile1X :tile1Y :newStatus];
//}

- (void)set1x1SpaceStatus:(int)x :(int)y :(int)newStatus
{
    tileMap[x][y] = newStatus;
}

//- (BOOL)checkAny2x2SpaceStatus:(int)x :(int)y :(int)Status
//{
//    int tile1X = x;
//    int tile1Y = y;
//    
//    if ([self check1x1SpaceStatus:tile1X :tile1Y :Status])
//        return YES;
//    else
//        return NO;
//}
//
//- (BOOL)check2x2SpaceStatus:(int)x :(int)y :(int)Status
//{
//    int tile1X = x;
//    int tile1Y = y;
//    
//    if ([self check1x1SpaceStatus:tile1X :tile1Y :Status])
//        return YES;
//    else
//        return NO;
//}

- (BOOL)check1x1SpaceWalkable:(int)x :(int)y
{
    if(tileMap[x][y] < TILE_FINALTOWER)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)check1x1SpaceStatus:(int)x :(int)y :(int)Status
{
    if(tileMap[x][y] == Status)
        return YES;
    else
        return NO;
}

- (void)loadGame:(NSString*)towerData levelData:(NSString*)levelData gameString:(NSString*)gameString
{
    //"level:lives:score:energy:gametime:kills:damage:gameid:difficultyid"
    NSArray *gameProperties = [gameString componentsSeparatedByString:@":"];
    levelManager.currentLevel = [(NSString*)[gameProperties objectAtIndex:0] intValue];
    lives = [(NSString*)[gameProperties objectAtIndex:1] intValue];
    [livesDisplay setString:[NSString stringWithFormat:@"%@ %d", String_LivesLabel, lives]];
    score = [(NSString*)[gameProperties objectAtIndex:2] intValue];
    [scoreDisplay setString:[NSString stringWithFormat:@"%@ %d", String_ScoreLabel, score]];
    energy = [(NSString*)[gameProperties objectAtIndex:3] intValue];
    [energyDisplay setString:[NSString stringWithFormat:@"%@ %d", String_EnergyLabel, energy]];
    lastStablegameTimer = [(NSString*)[gameProperties objectAtIndex:4] doubleValue];
    lastStablekills = [(NSString*)[gameProperties objectAtIndex:5] intValue];
    lastStabledamage = [(NSString*)[gameProperties objectAtIndex:6] intValue];
    userManager.gameid = [(NSString*)[gameProperties objectAtIndex:7] intValue];
    userManager.difficultyid = [(NSString*)[gameProperties objectAtIndex:8] intValue];
    
    NSArray *towerBytes = [towerData componentsSeparatedByString:@":"];
    NSArray *levelBytes = [levelData componentsSeparatedByString:@":"];
    
    int index = 0;
    int x,y = 0;
    for(y=0;y<mapHeight;y++)
    {
        for(x=0;x<mapWidth;x++)
        {
            int towerValue = [(NSString *)[towerBytes objectAtIndex:index] intValue];
            int levelValue = [(NSString *)[levelBytes objectAtIndex:index] intValue];
            printf("%d = %d\n", index, towerValue);
            if (towerValue >= 128)
            {
                int towerType = towerValue - 128;
            
                [self set1x1SpaceStatus:((x)) :((y)) :TILE_FINALTOWER + towerType];
                
                ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
                BaseTower * tower = [delegate constructTowerWithType:towerType gameField:self addToField:YES];
                [tower setPositionWithX:(((x)*cellSize)+cellSize/2) Y:(((y)*cellSize)+cellSize/2)];
                [tower show];
                [tower setPower:levelValue];
                [tower setColor:Color_White];
                [towers addObject:tower];
            }
            index++;
        }
    }
}

- (NSString*)levelsToData
{
    NSString * levelData = @"";
    int x,y = 0;
    for(y=0;y<mapHeight;y++)
    {
        for(x=0;x<mapWidth;x++)
        {
            int value = [[NSString stringWithFormat:@"%d", lastStablelevels[x][y]] intValue];
            levelData = [levelData stringByAppendingFormat:@"%d:", value];
        }
    }
    return levelData;
}

- (NSString*)mapToData
{
    NSString * mapData = @"";
    int x,y = 0;
    int index = 0;
    for(y=0;y<mapHeight;y++)
    {
        for(x=0;x<mapWidth;x++)
        {
            int value = [[NSString stringWithFormat:@"%d", lastStabletileMap[x][y]] intValue];
            if (value >= TILE_FINALTOWER)
            {
                printf("%d = %d\n", index, value);
                mapData = [mapData stringByAppendingFormat:@"%d:", value];
            }
            else 
            {
                mapData = [mapData stringByAppendingFormat:@"0:"];
            }
            index++;
        }
    }
    return mapData;
}

- (void) dealloc
{
	[super dealloc];
}

@end
