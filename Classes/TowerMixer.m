//
//  TowerMixer.m
//  ChemTD
//
//  Created by Eric Lanz on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TowerMixer.h"
#import "Towers.h"
#import "Colors.h"
#import "Recipe.h"
#import "TowerManager.h"
#import "TextureLibrary.h"

@implementation TowerMixer

@synthesize elementMixerSprite;

-(id) initWithGameField:(GameFieldScene *)theGameField
{
	if( (self=[super init] )) 
    {
        gameField = theGameField;
        
        elementMixerSprite = [[CCSprite spriteWithFile:@"ElementMixer.png"] retain];
        elementMixerSprite.position = ccp(384/2,128/2);
        //[gameField.UILayer addChild:elementMixerSprite z:4];
        
        int spriteSize = 48;
        int mixerY = (elementMixerSprite.contentSize.height - 27) - spriteSize/2;
        int sprite1X = (elementMixerSprite.position.x - (elementMixerSprite.contentSize.width/2) + 10) + spriteSize/2;
        int sprite2X = (sprite1X + 58);
        int sprite3X = (sprite2X + 58);
        int sprite4X = (sprite3X + 58);
        int sprite5X = (sprite4X + 58);
        int sprite6X = 324 + (spriteSize/2);
        
        tower1Sprite = [[BaseTower alloc] initWithGameField:theGameField addToField:NO];
        tower2Sprite = [[BaseTower alloc] initWithGameField:theGameField addToField:NO];
        tower3Sprite = [[BaseTower alloc] initWithGameField:theGameField addToField:NO];
        tower4Sprite = [[BaseTower alloc] initWithGameField:theGameField addToField:NO];
        tower5Sprite = [[BaseTower alloc] initWithGameField:theGameField addToField:NO];
        resultSprite = [[BaseTower alloc] initWithGameField:theGameField addToField:NO];
        
        [elementMixerSprite addChild:tower1Sprite.towerSprite z:2];
        [elementMixerSprite addChild:tower2Sprite.towerSprite z:2];
        [elementMixerSprite addChild:tower3Sprite.towerSprite z:2];
        [elementMixerSprite addChild:tower4Sprite.towerSprite z:2];
        [elementMixerSprite addChild:tower5Sprite.towerSprite z:2];
        [elementMixerSprite addChild:resultSprite.towerSprite z:2];
        
        [tower1Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
        [tower1Sprite setPositionWithX:sprite1X Y:mixerY];
        [tower1Sprite show];
        
        [tower2Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
        [tower2Sprite setPositionWithX:sprite2X Y:mixerY];
        [tower2Sprite show];
        
        [tower3Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
        [tower3Sprite setPositionWithX:sprite3X Y:mixerY];
        [tower3Sprite show];
        
        [tower4Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
        [tower4Sprite setPositionWithX:sprite4X Y:mixerY];
        [tower4Sprite show];
        
        [tower5Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
        [tower5Sprite setPositionWithX:sprite5X Y:mixerY];
        [tower5Sprite show];
        
        [resultSprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
        [resultSprite setPositionWithX:sprite6X Y:mixerY];
        [resultSprite show];
        
        btnMixerAcceptUp = [CCSprite spriteWithFile:@"btn_MixerAccept_Up.png"];
        btnMixerAcceptDown = [CCSprite spriteWithFile:@"btn_MixerAccept_Down.png"];
        btnMixerClearUp = [CCSprite spriteWithFile:@"btn_MixerClear_Up.png"];
        btnMixerClearDown = [CCSprite spriteWithFile:@"btn_MixerClear_Down.png"];
        btnMixerClear = [CCMenuItemSprite itemFromNormalSprite:btnMixerClearUp selectedSprite:btnMixerClearDown disabledSprite:btnMixerClearDown target:self selector:@selector(onClear:)];
        btnMixerAccept = [CCMenuItemSprite itemFromNormalSprite:btnMixerAcceptUp selectedSprite:btnMixerAcceptDown disabledSprite:btnMixerAcceptDown target:self selector:@selector(onAccept:)];
        MixerMenu = [CCMenu menuWithItems: btnMixerClear, btnMixerAccept, nil];
        [MixerMenu alignItemsHorizontallyWithPadding:80];
        MixerMenu.position = ccp(elementMixerSprite.position.x, elementMixerSprite.position.y - 35);

        [elementMixerSprite addChild:MixerMenu z:1];
        
        selectedTowers = [[NSMutableArray alloc] init];
        recipeList = [[NSMutableArray alloc] init];
        
        [self populateRecipeList];
        
        currentSlot = 0;
        
        btnMixerAccept.isEnabled = NO;
    }
    return self;
}

- (void) disableAll
{
    btnMixerClearOldState = btnMixerClear.isEnabled;
    btnMixerAcceptOldState = btnMixerAccept.isEnabled;
    btnMixerClear.isEnabled = NO;
    btnMixerAccept.isEnabled = NO;
}

- (void) enableAll
{
    btnMixerClear.isEnabled = btnMixerClearOldState;
    btnMixerAccept.isEnabled = btnMixerAcceptOldState;
}

-(BOOL) isTowerSelected: (BaseTower *) tower
{
    BOOL found = NO;
    for (BaseTower * theTower in selectedTowers)
    {
        if (theTower == tower)
            found = YES;
    }
    return found;
}

-(void) show
{
    [MixerMenu setVisible:YES];
    [elementMixerSprite setVisible:YES];
    [tower1Sprite show];
    [tower2Sprite show];
    [tower3Sprite show];
    [tower4Sprite show];
    [tower5Sprite show];
    [resultSprite show];
}

-(void) hide
{
    [MixerMenu setVisible:NO];
    [elementMixerSprite setVisible:NO];
    [tower1Sprite hide];
    [tower2Sprite hide];
    [tower3Sprite hide];
    [tower4Sprite hide];
    [tower5Sprite hide];
    [resultSprite hide];
}

-(BaseTower*) getMixerResult
{
    BaseTower * outTower = nil;
    for (Recipe * recipe in recipeList)
    {
        if ([recipe canBuild:selectedTowers])
        {
            ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
            outTower = [delegate constructTowerWithType:recipe.product gameField:gameField addToField:YES];
            [outTower setPower:recipe.power];
        }
    }
    return outTower;
}

-(BOOL) updateTowerSlots
{
    [tower1Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
    [tower1Sprite setPower:0];
    [tower2Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
    [tower2Sprite setPower:0];
    [tower3Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
    [tower3Sprite setPower:0];
    [tower4Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
    [tower4Sprite setPower:0];
    [tower5Sprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
    [tower5Sprite setPower:0];
    [resultSprite setTexture:[gameField.textureLibrary GetTextureWithKey:UITEXTURE_REDX]];
    [resultSprite setPower:0];
    
    if (currentSlot > 0)
    {
        BaseTower * temp = [selectedTowers objectAtIndex:0];
        [tower1Sprite setTexture:[temp getTexture]];
        [tower1Sprite setPower:[temp getPower]];
    }
    if (currentSlot > 1)
    {
        BaseTower * temp = [selectedTowers objectAtIndex:1];
        [tower2Sprite setTexture:[temp getTexture]];
        [tower2Sprite setPower:[temp getPower]];
    }
    if (currentSlot > 2)
    {
        BaseTower * temp = [selectedTowers objectAtIndex:2];
        [tower3Sprite setTexture:[temp getTexture]];
        [tower3Sprite setPower:[temp getPower]];
    }
    if (currentSlot > 3)
    {
        BaseTower * temp = [selectedTowers objectAtIndex:3];
        [tower4Sprite setTexture:[temp getTexture]];
        [tower4Sprite setPower:[temp getPower]];
    }
    if (currentSlot > 4)
    {
        BaseTower * temp = [selectedTowers objectAtIndex:4];
        [tower5Sprite setTexture:[temp getTexture]];
        [tower5Sprite setPower:[temp getPower]];
    }
    
    BaseTower * temp = [self getMixerResult];
    
    BOOL pickedOne = NO;
    
    if (temp)
    {
        [resultSprite setTexture:[temp getTexture]];
        [resultSprite setPower:[temp getPower]];
        btnMixerAccept.isEnabled = YES;
        //printf("auto pick\n");
        [gameField.towerManager chooseTower:temp];
        pickedOne = YES;
    }
    else 
    {
        btnMixerAccept.isEnabled = NO;
        [gameField.towerManager chooseTower:nil];
    }
    return pickedOne;
}

-(BOOL) pickTower: (BaseTower *) tower
{
    if (![self isTowerSelected:tower])
    {
        [selectedTowers addObject:tower];
        [tower setColor:Color_Yellow];
        currentSlot ++;
    } else {
        [selectedTowers removeObject:tower];
        [tower setColor:Color_White];
        currentSlot --;
    }
    return [self updateTowerSlots];
}

-(void) onAccept: (id) sender
{
    for (BaseTower * tower in selectedTowers)
    {
        tower.usedByMixer = YES;
    }
    [gameField StartPlacePhase:[self getMixerResult]];
    [self onClear:nil];
}

-(void) onClear: (id) sender
{
    for (BaseTower * theTower in selectedTowers)
    {
        [theTower setColor:Color_White];
    }
    [selectedTowers removeAllObjects];
    currentSlot = 0;
    [self updateTowerSlots];
}

-(void) populateSingleElementRecipe:(int)towerType
{
    for (int towerPower = 1; towerPower <= 30; towerPower++)
    {
        [recipeList addObject:[[Recipe alloc] initWithTower1:towerType power1:towerPower product:towerType power:towerPower]];
    }   
}

-(void) populate5ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)towerType3 :(int)power3 
                              :(int)towerType4 :(int)power4 :(int)towerType5 :(int)power5 :(int)productType
{
    [recipeList addObject:[[Recipe alloc] initWithTower1:towerType1 power1:power1 tower2:towerType2 power2:power2 tower3:towerType3 power3:power3 
                                                  tower4:towerType4 power4:power4 tower5:towerType5 power5:power5 product:productType power:1]];   
}

-(void) populate4ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)towerType3 :(int)power3 
                              :(int)towerType4 :(int)power4 :(int)productType
{
    [recipeList addObject:[[Recipe alloc] initWithTower1:towerType1 power1:power1 tower2:towerType2 power2:power2 tower3:towerType3 power3:power3 
                                                  tower4:towerType4 power4:power4 product:productType power:1]];    
}

-(void) populate3ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)towerType3 :(int)power3 :(int)productType
{
    [recipeList addObject:[[Recipe alloc] initWithTower1:towerType1 power1:power1 tower2:towerType2 power2:power2 tower3:towerType3 power3:power3 
                                                 product:productType power:1]];
}

-(void) populate2ElementRecipe:(int)towerType1 :(int)power1 :(int)towerType2 :(int)power2 :(int)productType
{
    [recipeList addObject:[[Recipe alloc] initWithTower1:towerType1 power1:power1 tower2:towerType2 power2:power2 product:productType power:1]];
}

-(void) populateRecipeList;
{
    [self populateSingleElementRecipe:TowerType_Hydrogen];
    [self populateSingleElementRecipe:TowerType_Oxygen];
    [self populateSingleElementRecipe:TowerType_Nitrogen];
//    [self populateSingleElementRecipe:TowerType_Sodium];
    [self populateSingleElementRecipe:TowerType_Carbon];
//    [self populateSingleElementRecipe:TowerType_Chlorine];
    
    int O = TowerType_Oxygen;
    int N = TowerType_Nitrogen;
    int C = TowerType_Carbon;
    int H = TowerType_Hydrogen;
//    int Na = TowerType_Sodium;
//    int Cl = TowerType_Chlorine;
    
    [self populate2ElementRecipe:H :2 :O :1 :TowerType_Water];
    [self populate2ElementRecipe:N :1 :H :3 :TowerType_Ammonia];
    [self populate3ElementRecipe:C :9 :H :8 :O :4 :TowerType_Aspirin];
//    [self populate4ElementRecipe:C :1 :H :1 :Na :1 :O :3 :TowerType_BakingSoda];
//    [self populate3ElementRecipe:Na :1 :O :1 :Cl :1 :TowerType_Bleach];
    [self populate4ElementRecipe:C :8 :H :10 :N :4 :O :2 :TowerType_Caffeine];
    [self populate4ElementRecipe:C :18 :H :27 :N :1 :O :3 :TowerType_Capsaicin];
    [self populate2ElementRecipe:C :1 :O :2 :TowerType_CarbonDioxide];
    [self populate2ElementRecipe:C :1 :O :1 :TowerType_CarbonMonoxide];
//    [self populate3ElementRecipe:C :1 :H :1 :Cl :3 :TowerType_Chloroform];
    [self populate3ElementRecipe:H :1 :C :1 :N :1 :TowerType_Cyanide];
    [self populate3ElementRecipe:C :2 :H :6 :O :1 :TowerType_Ethanol];
//    [self populate2ElementRecipe:H :1 :Cl :1 :TowerType_HydrochloricAcid];
    [self populate2ElementRecipe:C :1 :H :4 :TowerType_Methane];
    [self populate3ElementRecipe:H :1 :N :1 :O :3 :TowerType_NitricAcid];
    [self populate4ElementRecipe:C :3 :H :5 :N :3 :O :9 :TowerType_Nitroglycerine];
    [self populate2ElementRecipe:N :2 :O :1 :TowerType_Nitrous];
    [self populate4ElementRecipe:C :3 :H :6 :N :6 :O :6 :TowerType_RDX];
    [self populate2ElementRecipe:C :5 :H :8 :TowerType_Rubber];
//    [self populate2ElementRecipe:Na :1 :Cl :1 :TowerType_Salt];
    [self populate4ElementRecipe:C :11 :H :17 :N :3 :O :8 :TowerType_Tetrodotoxin];
    [self populate4ElementRecipe:C :7 :H :5 :N :3 :O :6 :TowerType_TNT];
    [self populate4ElementRecipe:C :8 :H :9 :N :1 :O :2 :TowerType_Tylenol];
//    [self populate5ElementRecipe:C :16 :H :13 :Cl :1 :N :2 :O :1 :TowerType_Valium];
    [self populate3ElementRecipe:C :6 :H :8 :O :6 :TowerType_VitaminC];
    [self populate2ElementRecipe:C :2 :H :2 :TowerType_Acetylene];
}

@end
