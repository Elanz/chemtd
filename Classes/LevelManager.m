//
//  LevelManager.m
//  ChemTD
//
//  Created by Eric Lanz on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelManager.h"
#import "GameFieldScene.h"
#import "TextureLibrary.h"
#import "UserManager.h"

@implementation Level

@synthesize levelName;
@synthesize creepCount;
@synthesize baseHealth;
@synthesize armorType;
@synthesize speed;
@synthesize textureId;
@end

@implementation LevelManager

@synthesize levels; 
@synthesize currentLevel;
@synthesize totalCreeps;
@synthesize levelCount;

-(id) initWithGameField:(GameFieldScene *)theGameField
{
    if( (self=[super init] )) 
    {
        gameField = theGameField;
        
        totalCreeps = 0;
        
        levels = [[NSMutableDictionary alloc] init];
        [self parseLevelData];
        
        currentLevel = 1;
    }
    return self;
}

-(void) incrementLevel
{
    currentLevel ++;
}

-(Level*)GetCurrentLevel
{
    return [levels objectForKey:[NSNumber numberWithInt:currentLevel]];
}

-(void) parseLevelData
{
    NSString * item = nil;
    
    NSString * fullPath = @"";
    if (gameField.userManager.difficultyid == 1)
    {
        fullPath = [[NSBundle mainBundle] pathForResource:@"levels_easy" ofType:@"dat"];
    }
    else if (gameField.userManager.difficultyid == 2)
    {
        fullPath = [[NSBundle mainBundle] pathForResource:@"levels_medium" ofType:@"dat"];
    }
    else if (gameField.userManager.difficultyid == 3)
    {
        fullPath = [[NSBundle mainBundle] pathForResource:@"levels_hard" ofType:@"dat"];
    }
    
    NSString * file = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil]; 
    
    NSScanner * scanner = [NSScanner scannerWithString:file];
    
    int index = 0;
    int levelId = 1;
    levelCount = 1;
    
    Level * newLevel = nil;
    
    while ([scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&item]) {
        if ([item characterAtIndex:0] != '/')
        {
            switch (index) {
                case 0:
                    newLevel = [[Level alloc] init];
                    newLevel.levelName = item;
                    index ++;
                    break;
                case 1:
                    newLevel.creepCount = [item intValue];
                    totalCreeps += newLevel.creepCount;
                    index ++;
                    break;
                case 2:
                    newLevel.baseHealth = [item intValue];
                    index ++;
                    break;
                case 3:
                    newLevel.armorType = [item intValue];
                    index ++;
                    break;
                case 4:
                    newLevel.speed = [item floatValue];
                    index ++;
                    break;
                case 5:
                    newLevel.textureId = [item intValue];
                    [levels setObject:newLevel forKey:[NSNumber numberWithInt:levelId]];
                    levelId ++;
                    levelCount ++;
                    index = 0;
                    break;
                default:
                    break;
            }
        }
    }    
}

@end
