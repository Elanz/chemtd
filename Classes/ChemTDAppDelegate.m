//
//  ChemTDAppDelegate.m
//  ChemTD
//
//  Created by Eric Lanz on 5/10/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "ChemTDAppDelegate.h"
#import "cocos2d.h"
#import "GameFieldScene.h"
#import "MainMenuScene.h"
#import "TextureLibrary.h"
#import "UserManager.h"
#import "BaseTower.h"
#import "Towers.h"

@implementation ChemTDAppDelegate

@synthesize window;
@synthesize textureLibrary;
@synthesize userManager;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		
    textureLibrary = [[TextureLibrary alloc] init];
    userManager = [[UserManager alloc] init];
    
    CC_DIRECTOR_INIT();
	[window makeKeyAndVisible];		
   
    [window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
    
    [CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
		
    [[CCDirector sharedDirector] runWithScene:[MainMenuScene scene]];
}

- (BaseTower *)constructTowerWithType:(int)towerType gameField:(GameFieldScene*)gameField addToField:(BOOL)addToField
{
    BaseTower * constructedTower = nil;
    
    switch (towerType) {      
        case TowerType_Acetylene: constructedTower = [[AcetyleneTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Ammonia: constructedTower = [[AmmoniaTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Aspirin: constructedTower = [[AspirinTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_BakingSoda: constructedTower = [[BakingSodaTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_Bleach: constructedTower = [[BleachTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Caffeine: constructedTower = [[CaffeineTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Capsaicin: constructedTower = [[CapsaicinTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Carbon: constructedTower = [[CarbonTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_CarbonDioxide: constructedTower = [[CarbonDioxideTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_CarbonMonoxide: constructedTower = [[CarbonMonoxideTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_Chlorine: constructedTower = [[ChlorineTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_Chloroform: constructedTower = [[ChloroformTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Cyanide: constructedTower = [[CyanideTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Ethanol: constructedTower = [[EthanolTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_HydrochloricAcid: constructedTower = [[HydrochloricAcidTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Hydrogen: constructedTower = [[HydrogenTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Methane: constructedTower = [[MethaneTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_NitricAcid: constructedTower = [[NitricAcidTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Nitrogen: constructedTower = [[NitrogenTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Nitroglycerine: constructedTower = [[NitroglycerineTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Nitrous: constructedTower = [[NitrousTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Oxygen: constructedTower = [[OxygenTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_RDX: constructedTower = [[RDXTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Rubber: constructedTower = [[RubberTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_Salt: constructedTower = [[SaltTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_Sodium: constructedTower = [[SodiumTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Tetrodotoxin: constructedTower = [[TetrodotoxinTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_TNT: constructedTower = [[TNTTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Tylenol: constructedTower = [[TylenolTower alloc] initWithGameField:gameField addToField:addToField]; break;
//        case TowerType_Valium: constructedTower = [[ValiumTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_VitaminC: constructedTower = [[VitaminCTower alloc] initWithGameField:gameField addToField:addToField]; break;
        case TowerType_Water: constructedTower = [[WaterTower alloc] initWithGameField:gameField addToField:addToField]; break;
            
        default:
            constructedTower = [[BaseTower alloc] initWithGameField:gameField addToField:addToField]; break;
    }
    
    return constructedTower;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCTextureCache sharedTextureCache] removeUnusedTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [userManager saveGame];
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
