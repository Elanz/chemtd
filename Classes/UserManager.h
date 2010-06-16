//
//  UserManager.h
//  ChemTD
//
//  Created by Eric Lanz on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameFieldScene;

#define StatType_CompletionTime 0
#define StatType_Score 1
#define StatType_DamageDone 2

#define DIFFICULTY_EASY 1
#define DIFFICULTY_MEDIUM 2
#define DIFFICULTY_HARD 3

@interface LevelStat : NSObject
{
    int statType;
    NSString * name1;
    NSString * name2;
    NSString * name3;
    NSString * name4;
    NSString * name5;
    NSString * name6;
    NSString * name7;
    NSString * name8;
    NSString * name9;
    NSString * name10;
    int statValue1;
    int statValue2;
    int statValue3;
    int statValue4;
    int statValue5;
    int statValue6;
    int statValue7;
    int statValue8;
    int statValue9;
    int statValue10;
    
    int playerRank;
    int playerValue;
}

@property (nonatomic, retain) NSString * name1;
@property (nonatomic, retain) NSString * name2;
@property (nonatomic, retain) NSString * name3;
@property (nonatomic, retain) NSString * name4;
@property (nonatomic, retain) NSString * name5;
@property (nonatomic, retain) NSString * name6;
@property (nonatomic, retain) NSString * name7;
@property (nonatomic, retain) NSString * name8;
@property (nonatomic, retain) NSString * name9;
@property (nonatomic, retain) NSString * name10;
@property (nonatomic) int statType;
@property (nonatomic) int playerRank;
@property (nonatomic) int statValue1;
@property (nonatomic) int statValue2;
@property (nonatomic) int statValue3;
@property (nonatomic) int statValue4;
@property (nonatomic) int statValue5;
@property (nonatomic) int statValue6;
@property (nonatomic) int statValue7;
@property (nonatomic) int statValue8;
@property (nonatomic) int statValue9;
@property (nonatomic) int statValue10;
@property (nonatomic) int playerValue;

@end


@interface UserManager : NSObject {
    
    int gameid;
    BOOL online;
    int difficultyid;
}

@property (nonatomic) int gameid;
@property (nonatomic) int difficultyid;
@property (nonatomic) BOOL online;

- (void) reachabilityChanged: (NSNotification* )note;

- (NSString*) splitbar1:(NSString*)input;
- (int) splitbar2:(NSString*)input;
- (NSArray*) getOveralRanking;

- (NSArray*) submitFinishedGame:(BOOL)won towers:(NSString*)towers;
- (void) submitStartGame;

- (LevelStat*) createFakeStat:(int)statType;
- (NSArray*) submitLevelStats:(int)levelId completionTime:(int)completionTime damageDone:(int)damageDone score:(int)score 
                 creepsKilled:(int)creepsKilled;

- (NSString*) getUserName;
- (BOOL) login:(NSString*)userName;

- (void) clearSaveGame;
- (void) saveGame;
- (void) loadGameWithField:(GameFieldScene*)gameField;

- (BOOL) hasSavedGame;

@end
