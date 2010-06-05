//
//  MainMenuScene.m
//  ChemTD
//
//  Created by Eric Lanz on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuScene.h"
#import "GameFieldScene.h"
#import "ChemTDAppDelegate.h"
#import "TextureLibrary.h"
#import "TowerMixer.h"
#import "TowerManager.h"
#import "UserManager.h"
#import "USEnglishStrings.h"
#import "Colors.h"
#import "Towers.h"

@implementation MainMenuScene

@synthesize motd;

+(id) scene
{
	CCScene *scene = [CCScene node];
	MainMenuScene *layer = [MainMenuScene node];
    layer.tag = CCNodeTag_MainMenu;
    [layer setContentSize:CGSizeMake(device_width, device_height)];
	[scene addChild: layer];
    
	return scene;
}

#define degreesToRadian(x) (M_PI * (x) / 180.0)

-(id) init
{
	if( (self=[super init] )) 
    {
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        textureLibrary = delegate.textureLibrary;
        userManager = delegate.userManager;
        
        background = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MAINMENUBACKGROUND]];
        background.position = ccp(device_width/2, device_height/2);
        [self addChild:background];
        
        //challengesBtnUp = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_CHALLENGESBTNUP]];
        //challengesBtnDown = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_CHALLENGESBTNDOWN]];
        changeUserBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_CHANGEUSERBTN]];
        ExploreBtnUp = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_EXPLOREBTNUP]];
        ExploreBtnDown = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_EXPLOREBTNDOWN]];
        PlayBtnUp = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_PLAYBTNUP]];
        PlayBtnDown = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_PLAYBTNDOWN]];
        RankingBtnUp = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_RANKINGBTNUP]];
        RankingBtnDown = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_RANKINGBTNDOWN]];
        
        //menuItemChallenges = [CCMenuItemSprite itemFromNormalSprite:challengesBtnUp selectedSprite:challengesBtnDown 
        //                                             disabledSprite:challengesBtnDown target:self selector:@selector(onChallenges:)];
        menuItemExplore = [CCMenuItemSprite itemFromNormalSprite:ExploreBtnUp selectedSprite:ExploreBtnDown 
                                                  disabledSprite:ExploreBtnDown target:self selector:@selector(onExplore:)];
        menuItemPlay = [CCMenuItemSprite itemFromNormalSprite:PlayBtnUp selectedSprite:PlayBtnDown 
                                               disabledSprite:PlayBtnDown target:self selector:@selector(onPlay:)];
        menuItemRanking = [CCMenuItemSprite itemFromNormalSprite:RankingBtnUp selectedSprite:RankingBtnDown 
                                                  disabledSprite:RankingBtnDown target:self selector:@selector(onRanking:)];
        menuItemChangeUser = [CCMenuItemSprite itemFromNormalSprite:changeUserBtn selectedSprite:changeUserBtn 
                                                     disabledSprite:changeUserBtn target:self selector:@selector(onChangeUser:)];
        
        mainMenu = [CCMenu menuWithItems: menuItemPlay, menuItemExplore, menuItemRanking, nil];//menuItemChallenges, nil];
        [mainMenu alignItemsVerticallyWithPadding:15];
        mainMenu.position = ccp(840,320);
        [self addChild:mainMenu z:1];
        userMenu = [CCMenu menuWithItems: menuItemChangeUser, nil];
        userMenu.position = ccp(870, 710);
        [self addChild:userMenu z:1];
        
        usernameDisplay = [[CCBitmapFontAtlas bitmapFontAtlasWithString:String_NULL fntFile:Font_UIPrimary] retain];
        usernameDisplay.position = ccp(200, device_height-50);
        usernameDisplay.color = Color_Black;
        [usernameDisplay setString:String_NULL];
        [self addChild:usernameDisplay];
        
        motd = [[NSMutableArray alloc] init];
        motdLabels = [[NSMutableArray alloc] init];
        
        motdX = device_width/2;
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                         priority:0
                                                  swallowsTouches:YES];
        
        [self schedule:@selector(doLoginCheck:)];
        [self schedule:@selector(tick:)];
    }
    return self;
}

- (void) tick:(ccTime)elapsed
{
    if (scrollVelocity >.5)
    {
        float percentToDecay = scrollVelocity * 0.05;
        scrollVelocity -= percentToDecay;
        float percentToMove = scrollVelocity / originalVelocity;
        if (towerScrollLayer)
        {
            [self updateScrollOffsetWithDeltaX:(scrollVector.x*percentToMove)];
        }
    }
}

- (void)updateScrollOffsetWithDeltaX:(float)DeltaX
{
    float newvalue = towerScrollLayer.position.x+DeltaX;
    if (newvalue > 180)
        newvalue = 180;
    if (newvalue < -10533)
        newvalue = -10533;
    
    towerScrollLayer.position = ccp(newvalue, towerScrollLayer.position.y);
}

- (void)startMOTDcrawl
{
    for (NSString * string in motd)
    {
        CCBitmapFontAtlas * motdLabel = [[CCBitmapFontAtlas bitmapFontAtlasWithString:string fntFile:Font_UIPrimary] retain];
        motdX += (motdLabel.contentSize.width/2);
        motdLabel.position = ccp(motdX, 27);
        motdLabel.color = Color_White;
        [self addChild:motdLabel z:3];
        [motdLabels addObject:motdLabel];
        motdX += (motdLabel.contentSize.width/2) + 100;
    }
    [self schedule:@selector(updateMOTDCrawl:)];
}

- (void)updateMOTDCrawl:(ccTime)elapsed
{
    int maxX = 0;
    int maxW = 0;
    
    for (CCBitmapFontAtlas * motdLabel in motdLabels)
    {
        if (motdLabel.position.x > maxX)
        {
            maxX = motdLabel.position.x;
            maxW = motdLabel.contentSize.width;
        }
    }
    
    for (CCBitmapFontAtlas * motdLabel in motdLabels)
    {
        motdLabel.position = ccp(motdLabel.position.x-2, 27);
        if (motdLabel.position.x < -motdLabel.contentSize.width)
        {
            if (maxX > device_width)
            {
                motdLabel.position = ccp(maxX + (maxW/2) + 100 + (motdLabel.contentSize.width/2), 27);
            }
            else 
            {
                motdLabel.position = ccp(device_width + (motdLabel.contentSize.width/2) + 100, 27); 
            }

        }
    }
}

- (void)doLoginCheck:(ccTime)elapsed
{
    NSString * username = [userManager getUserName];
    if (username)
    {
        if (![userManager login:username])
        {
            [self showLogin];
        }
        else
        {
            if (userManager.online)
            {
                [usernameDisplay setString:[NSString stringWithFormat:@"%@ %@",String_WelcomeLabel, username]];
            }
            else
            {
                [usernameDisplay setString:String_OfflineString];
            }
        }
    }
    else 
    {
        [self showLogin];
    }
    [self unschedule:@selector(doLoginCheck:)];
}

-(void)refreshDifficultyDisplay
{
    switch (userManager.difficultyid) {
        case DIFFICULTY_EASY: [difficultyDisplay setString:String_DifficultyEasy]; break;
        case DIFFICULTY_MEDIUM: [difficultyDisplay setString:String_DifficultyMedium]; break;
        case DIFFICULTY_HARD: [difficultyDisplay setString:String_DifficultyHard]; break;
        default:
            break;
    }
}

- (void) onEasy: (id) sender
{
    userManager.difficultyid = DIFFICULTY_EASY;
    [self refreshDifficultyDisplay];
}

- (void) onMedium: (id) sender
{
    userManager.difficultyid = DIFFICULTY_MEDIUM;
    [self refreshDifficultyDisplay];    
}

- (void) onHard: (id) sender
{
    userManager.difficultyid = DIFFICULTY_HARD;
    [self refreshDifficultyDisplay];    
}

-(void) onPlay: (id) sender
{
    minimenuLayer = [[CCLayer alloc] init];
    minimenuLayer.tag = CCNodeTag_Minimenu;
    [minimenuLayer setContentSize:CGSizeMake(1024, 768)];
    minimenuLayer.position = ccp(0,0);
    
    miniMenuBackground = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MINIMENU]];
    miniMenuBackground.position = ccp(device_width/2, device_height/2);
    [minimenuLayer addChild:miniMenuBackground];
    
    newGameBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_NEWGAMEBTN]];
    menuItemNewGame = [CCMenuItemSprite itemFromNormalSprite:newGameBtn selectedSprite:newGameBtn 
                                               disabledSprite:newGameBtn target:self selector:@selector(onNewGame:)];
    resumeBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_RESUMEBTN]];
    menuItemResume = [CCMenuItemSprite itemFromNormalSprite:resumeBtn selectedSprite:resumeBtn 
                                             disabledSprite:resumeBtn target:self selector:@selector(onResume:)];
    miniMenu = [CCMenu menuWithItems: menuItemResume, menuItemNewGame, nil];
    miniMenu.position = ccp(device_width/2-10, device_height/2);
    [miniMenu alignItemsVerticallyWithPadding:20];
    [minimenuLayer addChild:miniMenu z:1];
    //self.isTouchEnabled = NO;
    //menuItemChallenges.isEnabled = NO;
    menuItemExplore.isEnabled = NO;
    menuItemPlay.isEnabled = NO;
    menuItemRanking.isEnabled = NO;
    menuItemChangeUser.isEnabled = NO;
    
    userManager.difficultyid = DIFFICULTY_EASY;
    
    difficultyDisplay = [[CCBitmapFontAtlas bitmapFontAtlasWithString:String_NULL fntFile:Font_UIPrimary] retain];
    difficultyDisplay.position = ccp(device_width/2, device_height-165);
    difficultyDisplay.color = Color_Black;
    [self refreshDifficultyDisplay];
    [minimenuLayer addChild:difficultyDisplay];
    
    CCSprite * easyBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_EASYBTN]];
    CCSprite * mediumBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MEDIUMBTN]];
    CCSprite * hardBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_HARDBTN]];
    
    CCMenuItemSprite * menuItemEasy = [CCMenuItemSprite itemFromNormalSprite:easyBtn selectedSprite:easyBtn 
                                                               disabledSprite:easyBtn target:self selector:@selector(onEasy:)];
    CCMenuItemSprite * menuItemMedium = [CCMenuItemSprite itemFromNormalSprite:mediumBtn selectedSprite:mediumBtn 
                                                              disabledSprite:mediumBtn target:self selector:@selector(onMedium:)];
    CCMenuItemSprite * menuItemHard = [CCMenuItemSprite itemFromNormalSprite:hardBtn selectedSprite:hardBtn 
                                                                disabledSprite:hardBtn target:self selector:@selector(onHard:)];
    
    CCMenu * difficultyMenu = [CCMenu menuWithItems: menuItemEasy, menuItemMedium, menuItemHard, nil];
    [difficultyMenu alignItemsHorizontallyWithPadding:20];
    difficultyMenu.position = ccp(device_width/2,device_height-207);
    [minimenuLayer addChild:difficultyMenu z:4];
    
    [[CCDirector sharedDirector].runningScene addChild: minimenuLayer z:2]; 
    if (![userManager hasSavedGame])
    {
        menuItemResume.isEnabled = NO;
    }
    else
    {
        menuItemResume.isEnabled = YES;
    }
}

-(void) onNewGame:(id)sender
{
    [userManager submitStartGame];
    CCScene * scene = [GameFieldScene scene];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void) onResume:(id)sender
{
    CCScene * scene = [GameFieldScene sceneWithLoad];
    [[CCDirector sharedDirector] replaceScene:scene];
}

-(void) showExplorerLayer
{
    minimenuLayer = [[CCLayer alloc] init];
    minimenuLayer.tag = CCNodeTag_Minimenu;
    [minimenuLayer setContentSize:CGSizeMake(1024, 768)];
    minimenuLayer.position = ccp(0,0);
    
    miniMenuBackground = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_EXPLORERBACKGROUND]];
    [minimenuLayer addChild:miniMenuBackground];
    
    CCSprite * mainMenuBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MAINMENUBTN]];
    CCMenuItemSprite * menuItemMainMenu = [CCMenuItemSprite itemFromNormalSprite:mainMenuBtn selectedSprite:mainMenuBtn 
                                                                  disabledSprite:mainMenuBtn target:self selector:@selector(onMainMenu:)];
    
    menuItemMainMenu.scale = .75;
    
    mainMenu = [CCMenu menuWithItems: menuItemMainMenu, nil];
    mainMenu.position = ccp(device_width/2,device_height-704);
    [minimenuLayer addChild:mainMenu z:4];
    
    miniMenuBackground.position = ccp(device_width/2, device_height/2);
    
    towerScrollLayer = [[CCLayer alloc] init];
    towerScrollLayer.position = ccp(180, -35);
    for (int i = 1;i <= NumberOfTowerTypes;i++)
    {
        [towerScrollLayer addChild:[self createTowerCardForType:i x:((i-1)*(342+25)) y:474] z:5];
    }
    
    [[CCDirector sharedDirector].runningScene addChild: towerScrollLayer z:3]; 
    
    //menuItemChallenges.isEnabled = NO;
    menuItemExplore.isEnabled = NO;
    menuItemPlay.isEnabled = NO;
    menuItemRanking.isEnabled = NO;
    menuItemChangeUser.isEnabled = NO;
    [[CCDirector sharedDirector].runningScene addChild: minimenuLayer z:2]; 
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    scrollVelocity = 0.0;
    if (towerScrollLayer)
    {
        CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:nil]];
        if (location.y < device_height - 578)
        {
            //rangelow = -10900;
            //rangehigh = 180;
            //range = 10720;
            float percentX = location.x / device_width;
            int newvalue;
            if (percentX < .05)
            {
                newvalue = 180;
            }
            else if (percentX > .95)
            {
                newvalue = -10533;
            }
            else
            {
                newvalue = 180 - (10713 * percentX);
            }
            float diff = abs(towerScrollLayer.position.x - newvalue);
            if (newvalue > 180)
                newvalue = 180;
            if (newvalue < -10533)
                newvalue = -10533;
            float duration = 0.0;
            if (diff < 1000)
                duration = 0.2;
            if (diff >= 1000 && diff < 5000)
                duration = 0.5;
            if (diff >= 5000 && diff < 8000)
                duration = 0.7;
            if (diff > 8000)
                duration = 1.0;
            
            printf("%f, %d\n", diff, newvalue);
            
            [towerScrollLayer runAction:[CCMoveTo actionWithDuration:duration position:ccp(newvalue,towerScrollLayer.position.y)]];
            return NO;
        }
        else {
            return YES;
        }
    }
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (towerScrollLayer)
    {
        CGPoint location = [[CCDirector sharedDirector] convertToGL:[touch locationInView:nil]];
        CGPoint previouslocation = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:nil]];
        int newvalue;
        float diff = location.x - previouslocation.x;
        newvalue = towerScrollLayer.position.x+diff;
        if (newvalue > 180)
            newvalue = 180;
        if (newvalue < -10533)
            newvalue = -10533;
        
        towerScrollLayer.position = ccp(newvalue,towerScrollLayer.position.y);

    }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint firstTouchLocation = [[CCDirector sharedDirector] convertToGL:[touch locationInView:nil]];
    CGPoint previousFirstTouchLocation = [[CCDirector sharedDirector] convertToGL:[touch previousLocationInView:nil]];
    
    scrollVelocity = [self distanceBetweenPointsA:firstTouchLocation B:previousFirstTouchLocation];
    originalVelocity = scrollVelocity;
    scrollVector = ccp(firstTouchLocation.x - previousFirstTouchLocation.x, firstTouchLocation.y - previousFirstTouchLocation.y);
    
    printf("velocity = %f, x = %f, d = %f\n", scrollVelocity, scrollVector.x, scrollVector.y);
}

- (float)distanceBetweenPointsA:(CGPoint)a B:(CGPoint)b
{
    double firstDifference = (a.x - b.x);
    double secondDifference = (a.y - b.y);
    return sqrt((firstDifference*firstDifference)+(secondDifference*secondDifference));
}

-(CCSprite*) createTowerCardForType:(int)towerType x:(int)x y:(int)y
{
    CCSprite * card = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_TOWERCARDBACKGROUND]];
    card.position = ccp(x,y);
    ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
    BaseTower * tower = [delegate constructTowerWithType:towerType gameField:nil addToField:NO];
    [tower prepareCard:(CCSprite*)card];
    return card;
}

-(void) onExplore: (id) sender
{
    [self showExplorerLayer];
}

-(void) onScore:(id) sender
{
    [self showStatLayerForStatType:StatType_Score stat:scoreStat];
}

-(void) onDamage:(id) sender
{
    [self showStatLayerForStatType:StatType_DamageDone stat:damageStat];
}

-(void) onTime:(id) sender
{
    [self showStatLayerForStatType:StatType_CompletionTime stat:timeStat];
}

- (void)showStatLayerForStatType:(int)statType stat:(LevelStat*)stat
{
    if (highscoreLayer)
    {
        [[CCDirector sharedDirector].runningScene removeChild:highscoreLayer cleanup:YES];
    }
    
    highscoreLayer = [[CCLayer alloc] init];
    [highscoreLayer setContentSize:CGSizeMake(1024, 768)];
    highscoreLayer.position = ccp(0,0);
    
    int rankX = 304;
    int nameX = 512;
    int valueX = 709;
    
    int rowLabelsY = device_height - 112;
    int row1Y = rowLabelsY - 40;
    int row2Y = row1Y - 40;
    int row3Y = row2Y - 40;
    int row4Y = row3Y - 40;
    int row5Y = row4Y - 40;
    int row6Y = row5Y - 40;
    int row7Y = row6Y - 40;
    int row8Y = row7Y - 40;
    int row9Y = row8Y - 40;
    int row10Y = row9Y - 40;
    int pY = row10Y - 50;
    
    switch (statType) {
        case StatType_Score:
            [self createRankingLabel:valueX y:rowLabelsY layer:highscoreLayer string:String_RankingStatTypeScore];
            [self createRankingLabel:valueX y:row1Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue1]];
            [self createRankingLabel:valueX y:row2Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue2]];
            [self createRankingLabel:valueX y:row3Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue3]];
            [self createRankingLabel:valueX y:row4Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue4]];
            [self createRankingLabel:valueX y:row5Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue5]];
            [self createRankingLabel:valueX y:row6Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue6]];
            [self createRankingLabel:valueX y:row7Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue7]];
            [self createRankingLabel:valueX y:row8Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue8]];
            [self createRankingLabel:valueX y:row9Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue9]];
            [self createRankingLabel:valueX y:row10Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue10]];
            [self createRankingLabel:valueX y:pY layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.playerValue]];
            break;
        case StatType_CompletionTime:
            [self createRankingLabel:valueX y:rowLabelsY layer:highscoreLayer string:String_RankingStatTypeTime];
            [self createRankingLabel:valueX y:row1Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue1/1000, stat.statValue1%1000]];
            [self createRankingLabel:valueX y:row2Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue2/1000, stat.statValue2%1000]];
            [self createRankingLabel:valueX y:row3Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue3/1000, stat.statValue3%1000]];
            [self createRankingLabel:valueX y:row4Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue4/1000, stat.statValue4%1000]];
            [self createRankingLabel:valueX y:row5Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue5/1000, stat.statValue5%1000]];
            [self createRankingLabel:valueX y:row6Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue6/1000, stat.statValue6%1000]];
            [self createRankingLabel:valueX y:row7Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue7/1000, stat.statValue7%1000]];
            [self createRankingLabel:valueX y:row8Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue8/1000, stat.statValue8%1000]];
            [self createRankingLabel:valueX y:row9Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue9/1000, stat.statValue9%1000]];
            [self createRankingLabel:valueX y:row10Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.statValue10/1000, stat.statValue10%1000]];
            [self createRankingLabel:valueX y:pY layer:highscoreLayer string:[NSString stringWithFormat:@"%d.%d", stat.playerValue/1000, stat.playerValue%1000]];
            break;
        case StatType_DamageDone:
            [self createRankingLabel:valueX y:rowLabelsY layer:highscoreLayer string:String_RankingStatTypeDamage];
            [self createRankingLabel:valueX y:row1Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue1]];
            [self createRankingLabel:valueX y:row2Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue2]];
            [self createRankingLabel:valueX y:row3Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue3]];
            [self createRankingLabel:valueX y:row4Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue4]];
            [self createRankingLabel:valueX y:row5Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue5]];
            [self createRankingLabel:valueX y:row6Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue6]];
            [self createRankingLabel:valueX y:row7Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue7]];
            [self createRankingLabel:valueX y:row8Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue8]];
            [self createRankingLabel:valueX y:row9Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue9]];
            [self createRankingLabel:valueX y:row10Y layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.statValue10]];
            [self createRankingLabel:valueX y:pY layer:highscoreLayer string:[NSString stringWithFormat:@"%d", stat.playerValue]];
            break;
        default:
            break;
    }
    
    [self createRankingLabel:rankX y:rowLabelsY layer:highscoreLayer string:String_RankingHeaderRank];
    [self createRankingLabel:nameX y:rowLabelsY layer:highscoreLayer string:String_RankingHeaderName];
    
    [self createRankingLabel:nameX y:row1Y layer:highscoreLayer string:stat.name1];
    [self createRankingLabel:nameX y:row2Y layer:highscoreLayer string:stat.name2];
    [self createRankingLabel:nameX y:row3Y layer:highscoreLayer string:stat.name3];
    [self createRankingLabel:nameX y:row4Y layer:highscoreLayer string:stat.name4];
    [self createRankingLabel:nameX y:row5Y layer:highscoreLayer string:stat.name5];
    [self createRankingLabel:nameX y:row6Y layer:highscoreLayer string:stat.name6];
    [self createRankingLabel:nameX y:row7Y layer:highscoreLayer string:stat.name7];
    [self createRankingLabel:nameX y:row8Y layer:highscoreLayer string:stat.name8];
    [self createRankingLabel:nameX y:row9Y layer:highscoreLayer string:stat.name9];
    [self createRankingLabel:nameX y:row10Y layer:highscoreLayer string:stat.name10];
    [self createRankingLabel:nameX y:pY layer:highscoreLayer string:[userManager getUserName]];
    
    [self createRankingLabel:rankX y:row1Y layer:highscoreLayer string:@"#1"];
    [self createRankingLabel:rankX y:row2Y layer:highscoreLayer string:@"#2"];
    [self createRankingLabel:rankX y:row3Y layer:highscoreLayer string:@"#3"];
    [self createRankingLabel:rankX y:row4Y layer:highscoreLayer string:@"#4"];
    [self createRankingLabel:rankX y:row5Y layer:highscoreLayer string:@"#5"];
    [self createRankingLabel:rankX y:row6Y layer:highscoreLayer string:@"#6"];
    [self createRankingLabel:rankX y:row7Y layer:highscoreLayer string:@"#7"];
    [self createRankingLabel:rankX y:row8Y layer:highscoreLayer string:@"#8"];
    [self createRankingLabel:rankX y:row9Y layer:highscoreLayer string:@"#9"];
    [self createRankingLabel:rankX y:row10Y layer:highscoreLayer string:@"#10"];
    [self createRankingLabel:rankX y:pY layer:highscoreLayer string:[NSString stringWithFormat:@"#%d", stat.playerRank]];
    
    [[CCDirector sharedDirector].runningScene addChild: highscoreLayer z:3]; 
}

- (void)createRankingLabel:(int)x y:(int)y layer:(CCLayer*)layer string:(NSString*)string
{
    CCBitmapFontAtlas * label = [[CCBitmapFontAtlas bitmapFontAtlasWithString:string fntFile:Font_UIPrimary] retain];
    label.position = ccp(x, y);
    label.color = Color_Black;
    [layer addChild:label z:4];
}

-(void) onMainMenu:(id) sender
{
    //self.isTouchEnabled = YES;
    //menuItemChallenges.isEnabled = NO;
    menuItemExplore.isEnabled = YES;
    menuItemPlay.isEnabled = YES;
    menuItemRanking.isEnabled = YES;
    menuItemChangeUser.isEnabled = YES;
    [[CCDirector sharedDirector].runningScene removeChild:minimenuLayer cleanup:YES]; 
    [[CCDirector sharedDirector].runningScene removeChild:highscoreLayer cleanup:YES];
    if (towerScrollLayer)
    {
        [[CCDirector sharedDirector].runningScene removeChild:towerScrollLayer cleanup:YES];
        towerScrollLayer = nil;
    }
}

-(void) showRankingLayer
{
    minimenuLayer = [[CCLayer alloc] init];
    minimenuLayer.tag = CCNodeTag_Minimenu;
    [minimenuLayer setContentSize:CGSizeMake(1024, 768)];
    minimenuLayer.position = ccp(0,0);
    
    miniMenuBackground = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_OVERALLRANKINGBACKGROUND]];
    [minimenuLayer addChild:miniMenuBackground];
    
    CCSprite * mainMenuBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_MAINMENUBTN]];
    CCMenuItemSprite * menuItemMainMenu = [CCMenuItemSprite itemFromNormalSprite:mainMenuBtn selectedSprite:mainMenuBtn 
                                               disabledSprite:mainMenuBtn target:self selector:@selector(onMainMenu:)];

    menuItemMainMenu.scale = .75;
    
    mainMenu = [CCMenu menuWithItems: menuItemMainMenu, nil];
    mainMenu.position = ccp(device_width/2,device_height-704);
    [minimenuLayer addChild:mainMenu z:4];
    
    miniMenuBackground.position = ccp(device_width/2, device_height/2);
    
    CCSprite * scoreBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_SCOREBTN]];
    CCSprite * timeBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_TIMEBTN]];
    CCSprite * damageBtn = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_DAMAGEBTN]];
    
    CCMenuItemSprite * menuItemScore = [CCMenuItemSprite itemFromNormalSprite:scoreBtn selectedSprite:scoreBtn 
                                                               disabledSprite:scoreBtn target:self selector:@selector(onScore:)];
    CCMenuItemSprite * menuItemTime = [CCMenuItemSprite itemFromNormalSprite:timeBtn selectedSprite:timeBtn 
                                                              disabledSprite:timeBtn target:self selector:@selector(onTime:)];
    CCMenuItemSprite * menuItemDamage = [CCMenuItemSprite itemFromNormalSprite:damageBtn selectedSprite:damageBtn 
                                                                disabledSprite:damageBtn target:self selector:@selector(onDamage:)];
    
    CCMenu * statTypeMenu = [CCMenu menuWithItems: menuItemScore, menuItemTime, menuItemDamage, nil];
    [statTypeMenu alignItemsHorizontallyWithPadding:30];
    statTypeMenu.position = ccp(device_width/2,device_height-612);
    [minimenuLayer addChild:statTypeMenu z:4];
    
    //self.isTouchEnabled = NO;
    //menuItemChallenges.isEnabled = NO;
    menuItemExplore.isEnabled = NO;
    menuItemPlay.isEnabled = NO;
    menuItemRanking.isEnabled = NO;
    menuItemChangeUser.isEnabled = NO;
    [[CCDirector sharedDirector].runningScene addChild: minimenuLayer z:2]; 
    [self showStatLayerForStatType:StatType_Score stat:scoreStat];
}

-(void) onRanking: (id) sender
{
    NSArray * statArray = [userManager getOveralRanking];
    
    timeStat = [statArray objectAtIndex:StatType_CompletionTime];
    scoreStat = [statArray objectAtIndex:StatType_Score];
    damageStat = [statArray objectAtIndex:StatType_DamageDone];
    
    [self showRankingLayer];
}

//-(void) onChallenges: (id) sender
//{
//    
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //limit the size :
    unsigned int limit = 9;
    return !([textField.text length]>limit && [string length] > range.length);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([userManager login:[textField.text uppercaseString]])
    {
        [userManager clearSaveGame];
        if (userManager.online)
        {
            [usernameDisplay setString:[NSString stringWithFormat:@"%@ %@",String_WelcomeLabel, [textField.text uppercaseString]]];
        }
        else
        {
            [usernameDisplay setString:String_OfflineString];
        }
        [textField resignFirstResponder];
        [[CCDirector sharedDirector].runningScene removeChild: minimenuLayer cleanup:YES];
        [userNameField removeFromSuperview];
        //self.isTouchEnabled = YES;
        //menuItemChallenges.isEnabled = YES;
        menuItemExplore.isEnabled = YES;
        menuItemPlay.isEnabled = YES;
        menuItemRanking.isEnabled = YES;
        menuItemChangeUser.isEnabled = YES;
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void) showLogin
{
    minimenuLayer = [[CCLayer alloc] init];
    minimenuLayer.tag = CCNodeTag_Minimenu;
    [minimenuLayer setContentSize:CGSizeMake(1024, 768)];
    minimenuLayer.position = ccp(0,0);
    
    miniMenuBackground = [CCSprite spriteWithTexture:[textureLibrary GetTextureWithKey:UITEXTURE_LOGINBACKGROUND]];
    miniMenuBackground.position = ccp(device_width/2, device_height/2);
    [minimenuLayer addChild:miniMenuBackground];
    
    //self.isTouchEnabled = NO;
    //menuItemChallenges.isEnabled = NO;
    menuItemExplore.isEnabled = NO;
    menuItemPlay.isEnabled = NO;
    menuItemRanking.isEnabled = NO;
    menuItemChangeUser.isEnabled = NO;
    [[CCDirector sharedDirector].runningScene addChild: minimenuLayer z:2];
    
    userNameField = [[UITextField alloc] init];
    userNameField.frame = CGRectMake((device_height/2)-100, (device_width/2), 500, 72);
    userNameField.backgroundColor = [UIColor blackColor];
    userNameField.textAlignment = UITextAlignmentCenter;
    userNameField.textColor = [UIColor whiteColor];
    userNameField.font = [UIFont fontWithName:@"Helvetica" size:60.0f];
    userNameField.delegate = self;
    
    userNameField.transform = CGAffineTransformIdentity;
    userNameField.transform = CGAffineTransformMakeRotation(degreesToRadian(90));
    [[[CCDirector sharedDirector] openGLView] addSubview:userNameField];
    [userNameField becomeFirstResponder];
}

-(void) onChangeUser: (id) sender
{
    [self showLogin];
}

- (void) dealloc
{
	[super dealloc];
}

@end
