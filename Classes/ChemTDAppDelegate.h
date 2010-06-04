//
//  ChemTDAppDelegate.h
//  ChemTD
//
//  Created by Eric Lanz on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#define CCNodeTag_GameField 1
#define CCNodeTag_UILayer 2
#define CCNodeTag_MainMenu 3
#define CCNodeTag_Minimenu 4

@class TextureLibrary;
@class UserManager;
@class BaseTower;
@class GameFieldScene;

@interface ChemTDAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    
    TextureLibrary * textureLibrary;
    UserManager * userManager;
}

@property (nonatomic, retain) UserManager * userManager;
@property (nonatomic, retain) TextureLibrary * textureLibrary;
@property (nonatomic, retain) UIWindow * window;

- (BaseTower *)constructTowerWithType:(int)towerType gameField:(GameFieldScene*)gameField addToField:(BOOL)addToField;

@end
