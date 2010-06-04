//
//  TowerMixer.h
//  ChemTD
//
//  Created by Eric Lanz on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFieldScene.h"

@class BaseTower;

@interface TowerMixer : NSObject {

    CCSprite * elementMixerSprite;
    BaseTower * tower1Sprite;
    BaseTower * tower2Sprite;
    BaseTower * tower3Sprite;
    BaseTower * tower4Sprite;
    BaseTower * tower5Sprite;
    BaseTower * resultSprite;
    
    CCSprite * btnMixerAcceptUp;
    CCSprite * btnMixerAcceptDown;
    CCSprite * btnMixerClearUp;
    CCSprite * btnMixerClearDown;
    CCMenuItemSprite * btnMixerClear;
    CCMenuItemSprite * btnMixerAccept;
    CCMenu * MixerMenu;
    
    int currentSlot;
    
    NSMutableArray * selectedTowers;
    NSMutableArray * recipeList;
    
    GameFieldScene *gameField;
    
    BOOL btnMixerClearOldState;
    BOOL btnMixerAcceptOldState;
}

@property (nonatomic, retain) CCSprite * elementMixerSprite;

- (void) disableAll;
- (void) enableAll;

-(BaseTower*) getMixerResult;

-(BOOL) pickTower: (BaseTower *) tower;

-(BOOL) isTowerSelected: (BaseTower *) tower;

-(BOOL) updateTowerSlots;

-(void) hide;
-(void) show;

-(void) onAccept: (id) sender;
-(void) onClear: (id) sender;

-(id) initWithGameField:(GameFieldScene *)theGameField;

-(void) populate5ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)towerType3 :(int)power3 
                              :(int)towerType4 :(int)power4 :(int)towerType5 :(int)power5 :(int)productType;
-(void) populate4ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)towerType3 :(int)power3 
                              :(int)towerType4 :(int)power4 :(int)productType;
-(void) populate3ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)towerType3 :(int)power3 :(int)productType;
-(void) populate2ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)productType;
-(void) populateSingleElementRecipe:(int)towerType;
-(void) populateRecipeList;

@end
