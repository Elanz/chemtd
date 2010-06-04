//
//  LevelManager.h
//  ChemTD
//
//  Created by Eric Lanz on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameFieldScene.h"

// Level definitions
// string : level name
// int : creep count
// int : base health
// int : armor type (0 = mineral, 1 = animal, 2 = plant)
// float : speed
// int : texture id
@interface Level: NSObject
{
    NSString * levelName;
    int creepCount;
    int baseHealth;
    int armorType;
    float speed;
    int textureId;
}

@property (nonatomic, retain) NSString * levelName;
@property (nonatomic) int creepCount;
@property (nonatomic) int baseHealth;
@property (nonatomic) int armorType;
@property (nonatomic) float speed;
@property (nonatomic) int textureId;

@end


@interface LevelManager : NSObject {

    NSMutableDictionary * levels;
    
    GameFieldScene * gameField;
    
    int totalCreeps;
    int currentLevel;
    int levelCount;
}

@property (nonatomic, retain) NSMutableDictionary * levels;
@property (nonatomic) int currentLevel;
@property (nonatomic) int totalCreeps;
@property (nonatomic) int levelCount;

-(id) initWithGameField:(GameFieldScene *)theGameField;
-(void) parseLevelData;
-(void) incrementLevel;
-(Level*)GetCurrentLevel;

@end
