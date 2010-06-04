//
//  MainMenuScene.h
//  ChemTD
//
//  Created by Eric Lanz on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "ChemTDAppDelegate.h"

@class UserManager;
@class LevelStat;

@interface MainMenuScene : CCLayer <UITextFieldDelegate> {

    TextureLibrary * textureLibrary;
    
    CCSprite * background;
    //CCSprite * challengesBtnUp;
    //CCSprite * challengesBtnDown;
    CCSprite * changeUserBtn;
    CCSprite * ExploreBtnUp;
    CCSprite * ExploreBtnDown;
    CCSprite * PlayBtnUp;
    CCSprite * PlayBtnDown;
    CCSprite * RankingBtnUp;
    CCSprite * RankingBtnDown;
    
    //CCMenuItemSprite * menuItemChallenges;
    CCMenuItemSprite * menuItemExplore;
    CCMenuItemSprite * menuItemPlay;
    CCMenuItemSprite * menuItemRanking;
    CCMenuItemSprite * menuItemChangeUser;
    
    CCMenu * mainMenu;
    CCMenu * userMenu;
    
    UserManager * userManager;
    
    CCLayer * minimenuLayer;
    CCSprite * miniMenuBackground;
    CCSprite * newGameBtn;
    CCMenuItemSprite * menuItemNewGame;
    CCSprite * resumeBtn;
    CCMenuItemSprite * menuItemResume;
    CCMenu * miniMenu;
    
    CCLayer * highscoreLayer;
    CCLayer * towerScrollLayer;
    
    CCBitmapFontAtlas * usernameDisplay;
    
    NSMutableArray * motd;
    NSMutableArray * motdLabels;
    
    int motdX;
    
    UITextField * userNameField;
    
    LevelStat * timeStat;
    LevelStat * scoreStat;
    LevelStat * damageStat;
    
    float originalVelocity;
    float scrollVelocity;
    CGPoint scrollVector;
}

@property (nonatomic, retain) NSMutableArray * motd;

+(id) scene;

- (void)updateScrollOffsetWithDeltaX:(float)DeltaX;
- (float)distanceBetweenPointsA:(CGPoint)a B:(CGPoint)b;
- (CCSprite*) createTowerCardForType:(int)towerType x:(int)x y:(int)y;
- (void) showExplorerLayer;
- (void) showRankingLayer;
- (void) createRankingLabel:(int)x y:(int)y layer:(CCLayer*)layer string:(NSString*)string;
- (void) showStatLayerForStatType:(int)statType stat:(LevelStat*)stat;
- (void) onMainMenu:(id) sender;
- (void) doLoginCheck:(ccTime)elapsed;
- (void) startMOTDcrawl;
- (void) updateMOTDCrawl:(ccTime)elapsed;
- (void) onNewGame:(id)sender;
- (void) onResume:(id)sender;
- (void) onPlay: (id) sender;
- (void) onExplore: (id) sender;
- (void) onRanking: (id) sender;
//-(void) onChallenges: (id) sender;
- (void) onChangeUser: (id) sender;

- (void) showLogin;

@end
