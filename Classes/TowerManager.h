//
//  TowerManager.h
//  ChemTD
//
//  Created by Eric Lanz on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFieldScene.h"

#define TowerSprite_Tag 500

@class BaseTower;

@interface TowerManager : NSObject {

    CCSprite * towerManagerSprite;
    BaseTower * tower1Sprite;
    
    CCSprite * btnTowerManagerUpgradeUp;
    CCSprite * btnTowerManagerUpgradeDown;
    CCSprite * btnTowerManagerDowngradeUp;
    CCSprite * btnTowerManagerDowngradeDown;
    CCMenuItemSprite * btnTowerManagerUpgrade;
    CCMenuItemSprite * btnTowerManagerDowngrade;
    CCMenu * towerManagerMenu;
    
    BaseTower * currentTower;
    BaseTower * actualTower;
    
    GameFieldScene *gameField;
    
    CCBitmapFontAtlas * towerName;
    CCBitmapFontAtlas * currentRange;
    CCBitmapFontAtlas * currentDamage;
    CCBitmapFontAtlas * currentSpeed;
    CCBitmapFontAtlas * rangeLabel;
    CCBitmapFontAtlas * damageLabel;
    CCBitmapFontAtlas * speedLabel;
    
    BOOL towerManagerUpgradeOldState;
    BOOL towerManagerDowngradeOldState;
}

@property (nonatomic, retain) CCSprite * towerManagerSprite;

- (void) disableAll;
- (void) enableAll;
- (CCBitmapFontAtlas*) makeLabelWithPosition:(CGPoint)position scale:(float)scale string:(NSString*)string;
- (void) clearChosenTower;
- (id) initWithGameField:(GameFieldScene *)theGameField;
- (void) chooseTower:(BaseTower*)newTower;
-(void) onUpgrade: (id) sender;
-(void) onDowngrade: (id) sender;

@end
