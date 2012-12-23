//
//  TowerManager.m
//  ChemTD
//
//  Created by Eric Lanz on 5/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TowerManager.h"
#import "Towers.h"
#import "TextureLibrary.h"
#import "USEnglishStrings.h"

@implementation TowerManager

@synthesize towerManagerSprite;

-(id) initWithGameField:(GameFieldScene *)theGameField
{
	if( (self=[super init] )) 
    {
        gameField = theGameField;
                
        towerManagerSprite = [[CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_TOWERMANAGERBACKGROUND]] retain];
        towerManagerSprite.position = ccp(device_width-95, device_height-80);
        //[gameField.UILayer addChild:towerManagerSprite z:4];
        btnTowerManagerUpgradeUp = [CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_TOWERMANAGERUPGRADEUP]];
        btnTowerManagerUpgradeDown = [CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_TOWERMANAGERUPGRADEDOWN]];
        btnTowerManagerDowngradeUp = [CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_TOWERMANAGERDOWNGRADEUP]];
        btnTowerManagerDowngradeDown = [CCSprite spriteWithTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_TOWERMANAGERDOWNGRADEDOWN]];
        btnTowerManagerUpgrade = [CCMenuItemSprite itemFromNormalSprite:btnTowerManagerUpgradeUp selectedSprite:btnTowerManagerUpgradeDown 
                                                         disabledSprite:nil target:self selector:@selector(onUpgrade:)];
        btnTowerManagerDowngrade = [CCMenuItemSprite itemFromNormalSprite:btnTowerManagerDowngradeUp selectedSprite:btnTowerManagerDowngradeDown 
                                                           disabledSprite:nil target:self selector:@selector(onDowngrade:)];

        btnTowerManagerUpgrade.scaleY = 5.5;
        btnTowerManagerDowngrade.scaleY = 5.5;
        
        towerManagerMenu = [CCMenu menuWithItems: btnTowerManagerDowngrade, btnTowerManagerUpgrade, nil];
        [towerManagerMenu alignItemsHorizontallyWithPadding:120];
        towerManagerMenu.position = ccp(95,45);
        [towerManagerSprite addChild:towerManagerMenu z:1];
        
        towerName = [self makeLabelWithPosition:ccp(95, 145) scale:1.0 string:String_NoTowerSelectedLabel];
        rangeLabel = [self makeLabelWithPosition:ccp(60, 70) scale:1.0 string:String_RNGLabel];
        damageLabel = [self makeLabelWithPosition:ccp(60, 50) scale:1.0 string:String_DMGLabel];
        speedLabel = [self makeLabelWithPosition:ccp(60, 30) scale:1.0 string:String_SPDLabel];
        currentRange = [self makeLabelWithPosition:ccp(115, 70) scale:1.0 string:String_NULL];      
        currentDamage = [self makeLabelWithPosition:ccp(115, 50) scale:1.0 string:String_NULL]; 
        currentSpeed = [self makeLabelWithPosition:ccp(115, 30) scale:1.0 string:String_NULL]; 
    }
    return self;
}

- (void) disableAll
{
    towerManagerUpgradeOldState = btnTowerManagerUpgrade.isEnabled;
    towerManagerDowngradeOldState = btnTowerManagerDowngrade.isEnabled;
    btnTowerManagerUpgrade.isEnabled = NO;
    btnTowerManagerDowngrade.isEnabled = NO;
}

- (void) enableAll
{
    btnTowerManagerUpgrade.isEnabled = towerManagerUpgradeOldState;
    btnTowerManagerDowngrade.isEnabled = towerManagerDowngradeOldState;
}

- (CCLabelBMFont*) makeLabelWithPosition:(CGPoint)position scale:(float)scale string:(NSString*)string
{
    CCLabelBMFont * output = [CCLabelBMFont labelWithString:string fntFile:Font_UISmall];
    output.position = position;
    output.color = ccBLACK;
    output.scale = scale;
    [output setString:string];
    [towerManagerSprite addChild:output z:2];
    return output;
}

- (void) clearChosenTower
{
    [towerManagerSprite removeChild:[towerManagerSprite getChildByTag:TowerSprite_Tag] cleanup:YES];
    [currentTower release];
    currentTower = nil;
    [currentRange setString:String_NULL];
    [currentDamage setString:String_NULL];
    [currentSpeed setString:String_NULL];
    [towerName setString:String_NoTowerSelectedLabel];
}

- (void) chooseTower:(BaseTower*)newTower
{
    if (newTower)
    {
        //printf("choosing\n");
        while([towerManagerSprite getChildByTag:TowerSprite_Tag])
        {    
            [self clearChosenTower];
        }
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        currentTower = [delegate constructTowerWithType:newTower.towerType gameField:gameField addToField:YES];
        [currentTower setPower:newTower.towerPower];
        currentTower.shotRange = newTower.shotRange;
        currentTower.minDamage = newTower.minDamage;
        currentTower.maxDamage = newTower.maxDamage;
        currentTower.shotInterval = newTower.shotInterval;
        actualTower = newTower;
        [currentTower setPositionWithX:34 Y:109];
        [currentTower removeFromLayer];
        currentTower.towerSprite.tag = TowerSprite_Tag;
        [towerManagerSprite addChild:currentTower.towerSprite];
        [currentTower show];
        [towerName setString:currentTower.towerName];
        [currentRange setString:[NSString stringWithFormat:@"%d", currentTower.shotRange]];
        [currentDamage setString:[NSString stringWithFormat:@"%d - %d", currentTower.minDamage, currentTower.maxDamage]];
        [currentSpeed setString:[NSString stringWithFormat:@"%1.2f", currentTower.shotInterval]];
    }
    else
    {
        while([towerManagerSprite getChildByTag:TowerSprite_Tag])
        {    
            [self clearChosenTower];
        }
    }
}

-(void) onUpgrade: (id) sender
{
    if (currentTower && currentTower.towerType != TowerType_Base)
    {
        [actualTower upgrade];
        [currentTower upgrade];
        [currentRange setString:[NSString stringWithFormat:@"%d", currentTower.shotRange]];
        [currentDamage setString:[NSString stringWithFormat:@"%d - %d", currentTower.minDamage, currentTower.maxDamage]];
        [currentSpeed setString:[NSString stringWithFormat:@"%1.2f", currentTower.shotInterval]];
    }
}

-(void) onDowngrade: (id) sender
{
    if (currentTower && currentTower.towerType == TowerType_Base)
    {
        [gameField removeTower:actualTower];
        [self chooseTower:nil];
    }
}

@end
