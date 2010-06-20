//
//  TutorialManager.h
//  ChemTD
//
//  Created by Eric Lanz on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class GameFieldScene;
@class TextureLibrary;

@interface TutorialManager : NSObject {

    CCLayer * UILayer;
    
    TextureLibrary * library;
    
    CCSprite * introTutorial;
    CCSprite * creepsTutorial;
    CCSprite * mixTutorial;
    CCSprite * placeTutorial;
    CCSprite * buildTutorial;
    
    BOOL introOpen;
    BOOL creepsOpen;
    BOOL mixOpen;
    BOOL placeOpen;
    BOOL buildOpen;
}

- (id) initWithField:(GameFieldScene*)field;

- (void) closeAll;

- (void) showIntroTutorial;
- (void) showCreepsTutorial;
- (void) showMixTutorial;
- (void) showPlaceTutorial;
- (void) showBuildTutorial;

- (void) startHidingTutorialIntro;
- (void) startHidingTutorialCreeps;
- (void) startHidingTutorialMix;
- (void) startHidingTutorialPlace;
- (void) startHidingTutorialBuild;

- (void) removeTutorialIntro;
- (void) removeTutorialCreeps;
- (void) removeTutorialMix;
- (void) removeTutorialPlace;
- (void) removeTutorialBuild;

@end
