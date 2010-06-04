//
//  UserManager.m
//  ChemTD
//
//  Created by Eric Lanz on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserManager.h"
#import "GameFieldScene.h"
#import "MainMenuScene.h"

@implementation LevelStat

@synthesize statType;
@synthesize name1;
@synthesize name2;
@synthesize name3;
@synthesize name4;
@synthesize name5;
@synthesize name6;
@synthesize name7;
@synthesize name8;
@synthesize name9;
@synthesize name10;
@synthesize statValue1;
@synthesize statValue2;
@synthesize statValue3;
@synthesize statValue4;
@synthesize statValue5;
@synthesize statValue6;
@synthesize statValue7;
@synthesize statValue8;
@synthesize statValue9;
@synthesize statValue10;
@synthesize playerRank;
@synthesize playerValue;

@end

@implementation UserManager

@synthesize gameid;

- (void) clearSaveGame
{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedmap.txt"];
    [fileManager removeItemAtPath:writablePath error:nil];
    writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedlevels.txt"];
    [fileManager removeItemAtPath:writablePath error:nil];
    writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedata.txt"];
    [fileManager removeItemAtPath:writablePath error:nil];
}

- (void) saveGame
{
    if ([[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField])
    {
        NSFileManager * fileManager = [[NSFileManager alloc] init];
        GameFieldScene * gameField = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];
        NSString * towerData = [gameField mapToData];
        NSString * levelData = [gameField levelsToData];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedmap.txt"];
        [fileManager removeItemAtPath:writablePath error:nil];
        [towerData writeToFile:writablePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedlevels.txt"];
        [fileManager removeItemAtPath:writablePath error:nil];
        [levelData writeToFile:writablePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        //"level:lives:score:energy:gametime:kills:damage:gameid"
        NSString *saveString = [NSString stringWithFormat:@"%d:%d:%d:%d:%lf:%d:%d:%d", gameField.lastStablecurrentRound, gameField.lastStablelives
                                , gameField.lastStablescore, gameField.lastStableenergy, gameField.lastStablegameTimer
                                , gameField.lastStablekills, gameField.lastStabledamage, gameid];
        writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedata.txt"];
        [fileManager removeItemAtPath:writablePath error:nil];
        [saveString writeToFile:writablePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (LevelStat*) createFakeStat:(int)statType
{
    LevelStat * fakeStat = [[LevelStat alloc] init];
    fakeStat.statType = statType;
    fakeStat.name1 = [NSString stringWithFormat:@"FakeName1_%d", statType];
    fakeStat.name2 = [NSString stringWithFormat:@"FakeName2_%d", statType];
    fakeStat.name3 = [NSString stringWithFormat:@"FakeName3_%d", statType];
    fakeStat.name4 = [NSString stringWithFormat:@"FakeName4_%d", statType];
    fakeStat.name5 = [NSString stringWithFormat:@"FakeName5_%d", statType];
    fakeStat.name6 = [NSString stringWithFormat:@"FakeName6_%d", statType];
    fakeStat.name7 = [NSString stringWithFormat:@"FakeName7_%d", statType];
    fakeStat.name8 = [NSString stringWithFormat:@"FakeName8_%d", statType];
    fakeStat.name9 = [NSString stringWithFormat:@"FakeName9_%d", statType];
    fakeStat.name10 = [NSString stringWithFormat:@"FakeName10_%d", statType];
    fakeStat.statValue1 = 10000;
    fakeStat.statValue2 = 9000;
    fakeStat.statValue3 = 8000;
    fakeStat.statValue4 = 7000;
    fakeStat.statValue5 = 6000;
    fakeStat.statValue6 = 5000;
    fakeStat.statValue7 = 4000;
    fakeStat.statValue8 = 3000;
    fakeStat.statValue9 = 2000;
    fakeStat.statValue10 = 1000;
    fakeStat.playerValue = 100000;
    fakeStat.playerRank = 1000 + arc4random() % 1000;
    return fakeStat;
}

- (void) submitStartGame
{
    gameid = 1;
}

- (NSArray*) getOveralRanking
{
    NSArray * overallStats = [[NSArray alloc] initWithObjects:[self createFakeStat:StatType_CompletionTime]
                           ,[self createFakeStat:StatType_Score],[self createFakeStat:StatType_DamageDone],nil];
    return overallStats;
}

- (NSArray*) submitFinishedGame:(BOOL)won
{
    NSArray * gameStats = [[NSArray alloc] initWithObjects:[self createFakeStat:StatType_CompletionTime]
                            ,[self createFakeStat:StatType_Score],[self createFakeStat:StatType_DamageDone],nil];
    return gameStats;
}

- (NSArray*) submitLevelStats:(int)levelId completionTime:(int)completionTime damageDone:(int)damageDone score:(int)score
                 creepsKilled:(int)creepsKilled
{
    NSArray * levelStats = [[NSArray alloc] initWithObjects:[self createFakeStat:StatType_CompletionTime]
                            ,[self createFakeStat:StatType_Score],[self createFakeStat:StatType_DamageDone],nil];
    return levelStats;
}

- (NSString*) getUserName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];        
    NSString *username = [prefs objectForKey:@"username"];        
    return username;
}

- (BOOL) login:(NSString*)userName
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];        
    [prefs setObject:userName forKey:@"username"];        
    [prefs synchronize];
//    
//    NSString * Uid = [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
//    NSString * URLforGet = [NSString stringWithFormat:@"http://data.200monkeys.com/login.php?username=%@&deviceid=%@", userName, Uid];
//    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
//    [request setURL:[NSURL URLWithString:URLforGet]];  
//    [request setHTTPMethod:@"GET"]; 
//    [request setTimeoutInterval:5.0];
//    NSURLResponse *response;
//    NSError *urlerror;
//    NSData* receivedData = [[NSMutableData data] retain];
//    receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlerror];
//    NSString *output = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    
//    NSArray *loginStrings = [output componentsSeparatedByString:@"\n"];
//    
//    if ([(NSString *)[loginStrings objectAtIndex:0] isEqualToString:@"yes"])
//    {
//        MainMenuScene * mainMenu = (MainMenuScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_MainMenu];
//        for (NSString * string in loginStrings)
//        {
//            if (![string isEqualToString:@"yes"])
//            {
//                [mainMenu.motd addObject:string];
//            }
//        }
//        [mainMenu startMOTDcrawl];
//        return YES;
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        
//        [alert show];
//        [alert release];
//        return NO;
//    }
    
    return YES;    
}

- (void) loadGameWithField:(GameFieldScene*)gameField
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedmap.txt"];
    NSString * towerdata = [NSString stringWithContentsOfFile:writablePath encoding:NSUTF8StringEncoding error:nil];
    writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedlevels.txt"];
    NSString * leveldata = [NSString stringWithContentsOfFile:writablePath encoding:NSUTF8StringEncoding error:nil];
    writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedata.txt"];
    NSString * loadString = [NSString stringWithContentsOfFile:writablePath encoding:NSUTF8StringEncoding error:nil]; 
    
    [gameField loadGame:towerdata levelData:leveldata gameString:loadString];
}

- (BOOL) hasSavedGame
{
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *writablePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"savedata.txt"];
    if ([fileManager fileExistsAtPath:writablePath])
    {
        return YES;
    }
    return NO;
}

@end
