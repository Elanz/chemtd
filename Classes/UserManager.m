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
#import "Reachability.h"

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
@synthesize online;
@synthesize difficultyid;

- (id) init
{
    if( (self=[super init] )) 
    {
        online = false;
//        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
//        
//        Reachability* hostReach = [[Reachability reachabilityWithHostName: @"www.200Monkeys.com"] retain];
//        [hostReach startNotifer];
//        
//        Reachability* internetReach = [[Reachability reachabilityForInternetConnection] retain];
//        [internetReach startNotifer];
    }
    return self;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        if (online == YES)
        {
            //printf("network down");
            online = NO;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error." message:@"Make sure this device is connected to the internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        
            [alert show];
            [alert release];
            
        }
    }
    else {
        online = YES;
    }
}

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
        NSString *saveString = [NSString stringWithFormat:@"%d:%d:%d:%d:%lf:%d:%d:%d:%d", gameField.lastStablecurrentRound, gameField.lastStablelives
                                , gameField.lastStablescore, gameField.lastStableenergy, gameField.lastStablegameTimer
                                , gameField.lastStablekills, gameField.lastStabledamage, gameid, difficultyid];
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
//    if (online)
//    {
//        NSString * Uid = [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
//        NSString * URLforGet = [NSString stringWithFormat:@"http://www.200monkeys.com/chemtd/startgame.php?username=%@&deviceid=%@&difficultyid=%d", [self getUserName], Uid, difficultyid];
//        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
//        [request setURL:[NSURL URLWithString:URLforGet]];  
//        [request setHTTPMethod:@"GET"]; 
//        [request setTimeoutInterval:5.0];
//        NSURLResponse *response;
//        NSError *urlerror;
//        NSData* receivedData = [[NSMutableData data] retain];
//        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlerror];
//        NSString *output = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//        
//        gameid = [output intValue];
//        if (gameid == 0)
//        {
//            gameid = 1;
//            online = NO;
//        }
//    }
//    else
//    {
        gameid = 1;
//    }
}

- (NSArray*) getOveralRanking
{
    NSString * stats = @"";
//    if (online)
//    {
//        NSString * Uid = [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
//        NSString * URLforGet = [NSString stringWithFormat:
//                                @"http://200monkeys.com/chemtd/getgamestats.php?username=%@&deviceid=%@"
//                                , [self getUserName], Uid];
//        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
//        [request setURL:[NSURL URLWithString:URLforGet]];  
//        [request setHTTPMethod:@"GET"]; 
//        [request setTimeoutInterval:5.0];
//        NSURLResponse *response;
//        NSError *urlerror;
//        NSData* receivedData = [[NSMutableData data] retain];
//        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlerror];
//        stats = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    }
    
    NSArray *statsections = [stats componentsSeparatedByString:@"\n\n"];
    
    NSMutableArray * levelStats = nil;
    if ([statsections count] == 4)
    {
        //damage -> time -> score
        NSArray * damage = [(NSString*)[statsections objectAtIndex:0] componentsSeparatedByString:@"\n"];
        NSArray * time = [(NSString*)[statsections objectAtIndex:1] componentsSeparatedByString:@"\n"];
        NSArray * score = [(NSString*)[statsections objectAtIndex:2] componentsSeparatedByString:@"\n"];
        NSArray * player = [(NSString*)[statsections objectAtIndex:3] componentsSeparatedByString:@"\n"];
        
        LevelStat * damagestat = [[LevelStat alloc] init];
        damagestat.statType = StatType_DamageDone;
        LevelStat * timestat = [[LevelStat alloc] init];
        timestat.statType = StatType_CompletionTime;
        LevelStat * scorestat = [[LevelStat alloc] init];
        scorestat.statType = StatType_Score;
        NSString * row;
        if ([damage count] > 0) {row = [damage objectAtIndex:0];damagestat.name1 = [self splitbar1:row]; damagestat.statValue1 = [self splitbar2:row];}
        if ([damage count] > 1) {row = [damage objectAtIndex:1];damagestat.name2 = [self splitbar1:row]; damagestat.statValue2 = [self splitbar2:row];}
        if ([damage count] > 2) {row = [damage objectAtIndex:2];damagestat.name3 = [self splitbar1:row]; damagestat.statValue3 = [self splitbar2:row];}
        if ([damage count] > 3) {row = [damage objectAtIndex:3];damagestat.name4 = [self splitbar1:row]; damagestat.statValue4 = [self splitbar2:row];}
        if ([damage count] > 4) {row = [damage objectAtIndex:4];damagestat.name5 = [self splitbar1:row]; damagestat.statValue5 = [self splitbar2:row];}
        if ([damage count] > 5) {row = [damage objectAtIndex:5];damagestat.name6 = [self splitbar1:row]; damagestat.statValue6 = [self splitbar2:row];}
        if ([damage count] > 6) {row = [damage objectAtIndex:6];damagestat.name7 = [self splitbar1:row]; damagestat.statValue7 = [self splitbar2:row];}
        if ([damage count] > 7) {row = [damage objectAtIndex:7];damagestat.name8 = [self splitbar1:row]; damagestat.statValue8 = [self splitbar2:row];}
        if ([damage count] > 8) {row = [damage objectAtIndex:8];damagestat.name9 = [self splitbar1:row]; damagestat.statValue9 = [self splitbar2:row];}
        if ([damage count] > 9) {row = [damage objectAtIndex:9];damagestat.name10 = [self splitbar1:row]; damagestat.statValue10 = [self splitbar2:row];}
        row = [player objectAtIndex:0];
        damagestat.playerRank = [[self splitbar1:row] intValue] + 1;
        damagestat.playerValue = [self splitbar2:row];
        if ([time count] > 0) {row = [time objectAtIndex:0];timestat.name1 = [self splitbar1:row]; timestat.statValue1 = [self splitbar2:row];}
        if ([time count] > 1) {row = [time objectAtIndex:1];timestat.name2 = [self splitbar1:row]; timestat.statValue2 = [self splitbar2:row];}
        if ([time count] > 2) {row = [time objectAtIndex:2];timestat.name3 = [self splitbar1:row]; timestat.statValue3 = [self splitbar2:row];}
        if ([time count] > 3) {row = [time objectAtIndex:3];timestat.name4 = [self splitbar1:row]; timestat.statValue4 = [self splitbar2:row];}
        if ([time count] > 4) {row = [time objectAtIndex:4];timestat.name5 = [self splitbar1:row]; timestat.statValue5 = [self splitbar2:row];}
        if ([time count] > 5) {row = [time objectAtIndex:5];timestat.name6 = [self splitbar1:row]; timestat.statValue6 = [self splitbar2:row];}
        if ([time count] > 6) {row = [time objectAtIndex:6];timestat.name7 = [self splitbar1:row]; timestat.statValue7 = [self splitbar2:row];}
        if ([time count] > 7) {row = [time objectAtIndex:7];timestat.name8 = [self splitbar1:row]; timestat.statValue8 = [self splitbar2:row];}
        if ([time count] > 8) {row = [time objectAtIndex:8];timestat.name9 = [self splitbar1:row]; timestat.statValue9 = [self splitbar2:row];}
        if ([time count] > 9) {row = [time objectAtIndex:9];timestat.name10 = [self splitbar1:row]; timestat.statValue10 = [self splitbar2:row];}
        row = [player objectAtIndex:1];
        timestat.playerRank = [[self splitbar1:row] intValue] + 1;
        timestat.playerValue = [self splitbar2:row];
        if ([score count] > 0) {row = [score objectAtIndex:0];scorestat.name1 = [self splitbar1:row]; scorestat.statValue1 = [self splitbar2:row];}
        if ([score count] > 1) {row = [score objectAtIndex:1];scorestat.name2 = [self splitbar1:row]; scorestat.statValue2 = [self splitbar2:row];}
        if ([score count] > 2) {row = [score objectAtIndex:2];scorestat.name3 = [self splitbar1:row]; scorestat.statValue3 = [self splitbar2:row];}
        if ([score count] > 3) {row = [score objectAtIndex:3];scorestat.name4 = [self splitbar1:row]; scorestat.statValue4 = [self splitbar2:row];}
        if ([score count] > 4) {row = [score objectAtIndex:4];scorestat.name5 = [self splitbar1:row]; scorestat.statValue5 = [self splitbar2:row];}
        if ([score count] > 5) {row = [score objectAtIndex:5];scorestat.name6 = [self splitbar1:row]; scorestat.statValue6 = [self splitbar2:row];}
        if ([score count] > 6) {row = [score objectAtIndex:6];scorestat.name7 = [self splitbar1:row]; scorestat.statValue7 = [self splitbar2:row];}
        if ([score count] > 7) {row = [score objectAtIndex:7];scorestat.name8 = [self splitbar1:row]; scorestat.statValue8 = [self splitbar2:row];}
        if ([score count] > 8) {row = [score objectAtIndex:8];scorestat.name9 = [self splitbar1:row]; scorestat.statValue9 = [self splitbar2:row];}
        if ([score count] > 9) {row = [score objectAtIndex:9];scorestat.name10 = [self splitbar1:row]; scorestat.statValue10 = [self splitbar2:row];}
        row = [player objectAtIndex:2];
        scorestat.playerRank = [[self splitbar1:row] intValue] + 1;
        scorestat.playerValue = [self splitbar2:row];
        levelStats = [[NSMutableArray alloc] initWithObjects:timestat,scorestat,damagestat,nil];
    }
    else {
        levelStats = [[NSMutableArray alloc] initWithObjects:[self createFakeStat:StatType_CompletionTime]
                      ,[self createFakeStat:StatType_Score],[self createFakeStat:StatType_DamageDone],nil];
    }
    
    
//    NSArray * overallStats = [[NSArray alloc] initWithObjects:[self createFakeStat:StatType_CompletionTime]
//                           ,[self createFakeStat:StatType_Score],[self createFakeStat:StatType_DamageDone],nil];
    return levelStats;
}

- (NSArray*) submitFinishedGame:(BOOL)won towers:(NSString*)towers
{
    //http://www.200monkeys.com/chemtd/finishgame.php?gameid=3&won=1&towers=1B2A5B20A6B3
//    if (online)
//    {
//        NSString * URLforGet = [NSString stringWithFormat:
//                                @"http://www.200monkeys.com/chemtd/finishgame.php?gameid=%d&won=%d&towers=%@"
//                                , gameid, won, towers];
//        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
//        [request setURL:[NSURL URLWithString:URLforGet]];  
//        [request setHTTPMethod:@"GET"]; 
//        [request setTimeoutInterval:5.0];
//        NSURLResponse *response;
//        NSError *urlerror;
//        NSData* receivedData = [[NSMutableData data] retain];
//        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlerror];
//        //NSString *output = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    }

    return [self getOveralRanking];
}

- (NSArray*) submitLevelStats:(int)levelId completionTime:(int)completionTime damageDone:(int)damageDone score:(int)score
                 creepsKilled:(int)creepsKilled
{
    //http://www.200monkeys.com/chemtd/levelstats.php?username=test&deviceid=test&gameid=1&levelid=2&time=1234&damage=546&score=439&killed=34211
//    if (online)
//    {
//        NSString * Uid = [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
//        NSString * URLforGet = [NSString stringWithFormat:
//                                @"http://www.200monkeys.com/chemtd/levelstats.php?username=%@&deviceid=%@&gameid=%d&levelid=%d&time=%d&damage=%d&score=%d&killed=%d"
//                                , [self getUserName], Uid, gameid, levelId, completionTime, damageDone, score, creepsKilled];
//        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
//        [request setURL:[NSURL URLWithString:URLforGet]];  
//        [request setHTTPMethod:@"GET"]; 
//        [request setTimeoutInterval:5.0];
//        NSURLResponse *response;
//        NSError *urlerror;
//        NSData* receivedData = [[NSMutableData data] retain];
//        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlerror];
//        //NSString *output = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    }
//    
    NSString * stats = @"";
//    if (online)
//    {
//        NSString * Uid = [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
//        NSString * URLforGet = [NSString stringWithFormat:
//                                @"http://200monkeys.com/chemtd/getlevelstats.php?username=%@&deviceid=%@&levelid=%d&mydamage=%d&mytime=%d&myscore=%d"
//                                , [self getUserName], Uid, levelId, damageDone, completionTime, score];
//        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
//        [request setURL:[NSURL URLWithString:URLforGet]];  
//        [request setHTTPMethod:@"GET"]; 
//        [request setTimeoutInterval:5.0];
//        NSURLResponse *response;
//        NSError *urlerror;
//        NSData* receivedData = [[NSMutableData data] retain];
//        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlerror];
//        stats = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//    }
    
    NSArray *statsections = [stats componentsSeparatedByString:@"\n\n"];
    
    NSMutableArray * levelStats = nil;
    if ([statsections count] == 4)
    {
        //damage -> time -> score
        NSArray * damage = [(NSString*)[statsections objectAtIndex:0] componentsSeparatedByString:@"\n"];
        NSArray * time = [(NSString*)[statsections objectAtIndex:1] componentsSeparatedByString:@"\n"];
        NSArray * score = [(NSString*)[statsections objectAtIndex:2] componentsSeparatedByString:@"\n"];
        NSArray * player = [(NSString*)[statsections objectAtIndex:3] componentsSeparatedByString:@"\n"];
        
        LevelStat * damagestat = [[LevelStat alloc] init];
        damagestat.statType = StatType_DamageDone;
        LevelStat * timestat = [[LevelStat alloc] init];
        timestat.statType = StatType_CompletionTime;
        LevelStat * scorestat = [[LevelStat alloc] init];
        scorestat.statType = StatType_Score;
        NSString * row;
        if ([damage count] > 0) {row = [damage objectAtIndex:0];damagestat.name1 = [self splitbar1:row]; damagestat.statValue1 = [self splitbar2:row];}
        if ([damage count] > 1) {row = [damage objectAtIndex:1];damagestat.name2 = [self splitbar1:row]; damagestat.statValue2 = [self splitbar2:row];}
        if ([damage count] > 2) {row = [damage objectAtIndex:2];damagestat.name3 = [self splitbar1:row]; damagestat.statValue3 = [self splitbar2:row];}
        if ([damage count] > 3) {row = [damage objectAtIndex:3];damagestat.name4 = [self splitbar1:row]; damagestat.statValue4 = [self splitbar2:row];}
        if ([damage count] > 4) {row = [damage objectAtIndex:4];damagestat.name5 = [self splitbar1:row]; damagestat.statValue5 = [self splitbar2:row];}
        if ([damage count] > 5) {row = [damage objectAtIndex:5];damagestat.name6 = [self splitbar1:row]; damagestat.statValue6 = [self splitbar2:row];}
        if ([damage count] > 6) {row = [damage objectAtIndex:6];damagestat.name7 = [self splitbar1:row]; damagestat.statValue7 = [self splitbar2:row];}
        if ([damage count] > 7) {row = [damage objectAtIndex:7];damagestat.name8 = [self splitbar1:row]; damagestat.statValue8 = [self splitbar2:row];}
        if ([damage count] > 8) {row = [damage objectAtIndex:8];damagestat.name9 = [self splitbar1:row]; damagestat.statValue9 = [self splitbar2:row];}
        if ([damage count] > 9) {row = [damage objectAtIndex:9];damagestat.name10 = [self splitbar1:row]; damagestat.statValue10 = [self splitbar2:row];}
        damagestat.playerRank = [(NSString*)[player objectAtIndex:0] intValue] + 1;
        if ([time count] > 0) {row = [time objectAtIndex:0];timestat.name1 = [self splitbar1:row]; timestat.statValue1 = [self splitbar2:row];}
        if ([time count] > 1) {row = [time objectAtIndex:1];timestat.name2 = [self splitbar1:row]; timestat.statValue2 = [self splitbar2:row];}
        if ([time count] > 2) {row = [time objectAtIndex:2];timestat.name3 = [self splitbar1:row]; timestat.statValue3 = [self splitbar2:row];}
        if ([time count] > 3) {row = [time objectAtIndex:3];timestat.name4 = [self splitbar1:row]; timestat.statValue4 = [self splitbar2:row];}
        if ([time count] > 4) {row = [time objectAtIndex:4];timestat.name5 = [self splitbar1:row]; timestat.statValue5 = [self splitbar2:row];}
        if ([time count] > 5) {row = [time objectAtIndex:5];timestat.name6 = [self splitbar1:row]; timestat.statValue6 = [self splitbar2:row];}
        if ([time count] > 6) {row = [time objectAtIndex:6];timestat.name7 = [self splitbar1:row]; timestat.statValue7 = [self splitbar2:row];}
        if ([time count] > 7) {row = [time objectAtIndex:7];timestat.name8 = [self splitbar1:row]; timestat.statValue8 = [self splitbar2:row];}
        if ([time count] > 8) {row = [time objectAtIndex:8];timestat.name9 = [self splitbar1:row]; timestat.statValue9 = [self splitbar2:row];}
        if ([time count] > 9) {row = [time objectAtIndex:9];timestat.name10 = [self splitbar1:row]; timestat.statValue10 = [self splitbar2:row];}
        timestat.playerRank = [(NSString*)[player objectAtIndex:1] intValue] + 1;
        if ([score count] > 0) {row = [score objectAtIndex:0];scorestat.name1 = [self splitbar1:row]; scorestat.statValue1 = [self splitbar2:row];}
        if ([score count] > 1) {row = [score objectAtIndex:1];scorestat.name2 = [self splitbar1:row]; scorestat.statValue2 = [self splitbar2:row];}
        if ([score count] > 2) {row = [score objectAtIndex:2];scorestat.name3 = [self splitbar1:row]; scorestat.statValue3 = [self splitbar2:row];}
        if ([score count] > 3) {row = [score objectAtIndex:3];scorestat.name4 = [self splitbar1:row]; scorestat.statValue4 = [self splitbar2:row];}
        if ([score count] > 4) {row = [score objectAtIndex:4];scorestat.name5 = [self splitbar1:row]; scorestat.statValue5 = [self splitbar2:row];}
        if ([score count] > 5) {row = [score objectAtIndex:5];scorestat.name6 = [self splitbar1:row]; scorestat.statValue6 = [self splitbar2:row];}
        if ([score count] > 6) {row = [score objectAtIndex:6];scorestat.name7 = [self splitbar1:row]; scorestat.statValue7 = [self splitbar2:row];}
        if ([score count] > 7) {row = [score objectAtIndex:7];scorestat.name8 = [self splitbar1:row]; scorestat.statValue8 = [self splitbar2:row];}
        if ([score count] > 8) {row = [score objectAtIndex:8];scorestat.name9 = [self splitbar1:row]; scorestat.statValue9 = [self splitbar2:row];}
        if ([score count] > 9) {row = [score objectAtIndex:9];scorestat.name10 = [self splitbar1:row]; scorestat.statValue10 = [self splitbar2:row];}
        scorestat.playerRank = [(NSString*)[player objectAtIndex:2] intValue] + 1;
        levelStats = [[NSMutableArray alloc] initWithObjects:timestat,scorestat,damagestat,nil];
    }
    else {
        levelStats = [[NSMutableArray alloc] initWithObjects:[self createFakeStat:StatType_CompletionTime]
                                ,[self createFakeStat:StatType_Score],[self createFakeStat:StatType_DamageDone],nil];
    }

    
    
    return levelStats; 
}

- (int) splitbar2:(NSString*)input
{
    return [(NSString*)[[input componentsSeparatedByString:@"|"] objectAtIndex:1] intValue];
}

- (NSString*) splitbar1:(NSString*)input
{
    return [[input componentsSeparatedByString:@"|"] objectAtIndex:0];
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
    
//    if (online)
//    {
//        NSString * Uid = [[[UIDevice currentDevice] uniqueIdentifier] lowercaseString];
//        NSString * URLforGet = [NSString stringWithFormat:@"http://www.200monkeys.com/chemtd/login.php?username=%@&deviceid=%@", userName, Uid];
//        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];  
//        [request setURL:[NSURL URLWithString:URLforGet]];  
//        [request setHTTPMethod:@"GET"]; 
//        [request setTimeoutInterval:5.0];
//        NSURLResponse *response;
//        NSError *urlerror;
//        NSData* receivedData = [[NSMutableData data] retain];
//        receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&urlerror];
//        NSString *output = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
//        
//        NSArray *loginStrings = [output componentsSeparatedByString:@"\n"];
//        
//        if ([(NSString *)[loginStrings objectAtIndex:0] isEqualToString:@"yes"])
//        {
//            MainMenuScene * mainMenu = (MainMenuScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_MainMenu];
//            for (NSString * string in loginStrings)
//            {
//                if (![string isEqualToString:@"yes"])
//                {
//                    [mainMenu.motd addObject:string];
//                }
//            }
//            [mainMenu startMOTDcrawl];
//            return YES;
//        }
//        else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:output delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];        
//            [alert show];
//            [alert release];
//            online = NO;
//            return YES;
//        }        
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
