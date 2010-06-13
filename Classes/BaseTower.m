//
//  Tower.m
//  tdtest
//
//  Created by Eric Lanz on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseTower.h"
#import "Creep.h"
#import "CreepSpawner.h"
#import "CombatManager.h"
#import "BaseEffect.h"

@implementation BaseTower

@synthesize currentSpawner;
@synthesize towerType;
@synthesize towerName;
@synthesize shotInterval;
@synthesize shotRange;
@synthesize minDamage;
@synthesize maxDamage;
@synthesize targetType;
@synthesize towerPower;
@synthesize towerSprite;
@synthesize usedByMixer;
@synthesize effectType;
@synthesize switchTargetsAfterHit;
@synthesize dotMin;
@synthesize dotMax;
@synthesize baseDotMin;
@synthesize baseDotMax;
@synthesize shotParticleKey;
@synthesize hitParticleKey;
@synthesize trapTextureKey;
@synthesize baseRange;
@synthesize baseMinDamage;
@synthesize baseMaxDamage;
@synthesize baseInterval;

- (id)initWithGameField:(GameFieldScene*)theGameField addToField:(BOOL)addToField
{
    if ((self = [self init])) {
        gameField = theGameField;

        powerDisplay = [CCBitmapFontAtlas bitmapFontAtlasWithString:String_NULL fntFile:Font_TowerPower];
        powerDisplay.position = ccp(43,10);
        powerDisplay.scale = 1.5;
        powerDisplay.color = ccBLACK;
        [powerDisplay setString:String_NULL];
        
        effects = [[NSMutableArray alloc] init];
        targets = [[NSMutableArray alloc] init];
        maxTargets = 1;
        
        towerType = TowerType_Base;
        towerName = String_TowerName_Base;
        targetType = TowerTargetType_None;
        effectType = TowerEffectType_ExplodeOnImpact;
        trapTextureKey = 0;
        shotParticleKey = iEffect_SingleTargetFireball;
        hitParticleKey = iEffect_SingleTargetExplosion;
        towerPower = 0;
        maxPower = 1;
        towerClass = 0;
        switchTargetsAfterHit = NO;
        
        formulaComponent1 = -1;
        formulaQuantity1 = 2;
        formulaComponent2 = -1;
        formulaQuantity2 = 2;
        formulaComponent3 = -1;
        formulaQuantity3 = 0;
        formulaComponent4 = -1;
        formulaQuantity4 = 0;
        formulaComponent5 = -1;
        formulaQuantity5 = 0;
        
        baseRange = 0;
        baseMinDamage = 0;
        baseMaxDamage = 0;
        baseInterval = 0;
        baseDotMin = 0;
        baseDotMax = 0;
        
        shotRange = baseRange;
        minDamage = baseMinDamage;
        maxDamage = baseMaxDamage;
        dotMin = baseDotMin;
        dotMax = baseDotMax;
        shotInterval = baseInterval;
        
        [self setPower:towerPower];
        
        usedByMixer = NO;
                
        ChemTDAppDelegate *delegate = (ChemTDAppDelegate*)[[UIApplication sharedApplication] delegate];
        library = delegate.textureLibrary;
        towerSprite = [CCSprite spriteWithTexture:[library GetTextureWithKey:COLORTEXTURE_GRAY]];
        [towerSprite addChild:powerDisplay z:2];
        [towerSprite setVisible:NO];
        if (addToField)
            [gameField addChild:towerSprite z:1];
    }
    return self;
}

- (void)towerPicked
{
    
}

- (void)addEffect:(BaseEffect*)effect
{
    [effects addObject:effect];
    [effect startEffect];
}

- (void)prepareCard:(CCSprite*)towerCard
{
    [self addName:towerCard];
    [self addClass:towerCard];
    [self addStats:towerCard];
    [self addDescription:towerCard];
    [self addFormula:towerCard];
    [self addIcon:towerCard];
}

- (void)addClass:(CCSprite*)towerCard
{
    CCBitmapFontAtlas * output = [CCBitmapFontAtlas bitmapFontAtlasWithString:String_NULL fntFile:Font_UISmall];
    output.position = ccp(206,474-54);
    output.color = ccBLACK;
    output.scale = 1.3;
    switch (towerClass) {
        case 1: [output setString:String_TowerClass1Label]; break;
        case 2: [output setString:String_TowerClass2Label]; break;
        case 3: [output setString:String_TowerClass3Label]; break;
        case 4: [output setString:String_TowerClass4Label]; break;
        case 5: [output setString:String_TowerClass5Label]; break;
        case 6: [output setString:String_TowerClass6Label]; break;
        default:
            break;
    }
    [towerCard addChild:output z:6];
}

- (void)addStats:(CCSprite*)towerCard
{
    int x = 273;
    int y1 = 474-87;
    int y2 = 474-112;
    int y3 = 474-139;
    int y4 = 474-166;

    [self makeLabelWithPosition:ccp(x,y1) scale:1.1 string:[NSString stringWithFormat:@"%d - %d", minDamage, maxDamage] towerCard:towerCard];
    [self makeLabelWithPosition:ccp(x,y2) scale:1.1 string:[NSString stringWithFormat:@"%d", shotRange] towerCard:towerCard];
    [self makeLabelWithPosition:ccp(x,y3) scale:1.1 string:[NSString stringWithFormat:@"%1.2f", shotInterval] towerCard:towerCard];
    switch (targetType)
    {
        case TowerTargetType_None: [self makeLabelWithPosition:ccp(x,y4) scale:1.1 string:String_TargetTypeNone towerCard:towerCard]; break;
        case TowerTargetType_Single: [self makeLabelWithPosition:ccp(x,y4) scale:1.1 string:String_TargetTypeSingle towerCard:towerCard]; break; 
        case TowerTargetType_Multi: [self makeLabelWithPosition:ccp(x,y4) scale:1.1 string:String_TargetTypeMulti towerCard:towerCard]; break;
        case TowerTargetType_Splash: [self makeLabelWithPosition:ccp(x,y4) scale:1.1 string:String_TargetTypeSplash towerCard:towerCard]; break;
        case TowerTargetType_Trap: [self makeLabelWithPosition:ccp(x,y4) scale:1.1 string:String_TargetTypeTrap towerCard:towerCard]; break;
        case TowerTargetType_Cloud: [self makeLabelWithPosition:ccp(x,y4) scale:1.1 string:String_TargetTypeCloud towerCard:towerCard]; break;
    }
}

- (void) makeLabelWithPosition:(CGPoint)position scale:(float)scale string:(NSString*)string towerCard:(CCSprite*)towerCard
{
    CCBitmapFontAtlas * output = [CCBitmapFontAtlas bitmapFontAtlasWithString:string fntFile:Font_UISmall];
    output.position = position;
    output.color = ccBLACK;
    output.scale = scale;
    [towerCard addChild:output z:6];
}

- (void)addDescription:(CCSprite*)towerCard
{
    CCLabel *lbl01 = [CCLabel labelWithString:chemicalDescription dimensions:CGSizeMake(307, 76) alignment:UITextAlignmentLeft fontName:@"Helvetica" fontSize:18];
    [lbl01 setPosition: ccp(171,474-238)];
    lbl01.color = ccBLACK;
    [towerCard addChild: lbl01 z:6];
        
    CCLabel *lbl02 = [CCLabel labelWithString:towerEffects dimensions:CGSizeMake(307, 76) alignment:UITextAlignmentLeft fontName:@"Helvetica" fontSize:18];
    [lbl02 setPosition: ccp(171,474-330)];
    lbl02.color = ccBLACK;
    [towerCard addChild: lbl02 z:6];
}

- (void)addFormula:(CCSprite*)towerCard
{
    [self makeLabelWithPosition:ccp(212,474-372) scale:1.0 string:formula towerCard:towerCard];
    
    int y1 = 474-410;
    int y2 = 474-450;
    int x1 = 57;
    int x2 = x1 + 57;
    int x3 = x2 + 57;
    int x4 = x3 + 57;
    int x5 = x4 + 57;
    
    if (formulaComponent1 >= 0)
    {
        CCSprite * icon = [CCSprite spriteWithTexture:[library GetTextureWithKey:formulaComponent1]];
        icon.scale = 1.0;
        icon.position = ccp(x1,y1);
        [towerCard addChild:icon z:6];
        
        [self makeLabelWithPosition:ccp(x1,y2) scale:1.0 string:[NSString stringWithFormat:@"%d", formulaQuantity1] towerCard:towerCard];
    }
    if (formulaComponent2 >= 0)
    {
        CCSprite * icon = [CCSprite spriteWithTexture:[library GetTextureWithKey:formulaComponent2]];
        icon.scale = 1.0;
        icon.position = ccp(x2,y1);
        [towerCard addChild:icon z:6];
        
        [self makeLabelWithPosition:ccp(x2,y2) scale:1.0 string:[NSString stringWithFormat:@"%d", formulaQuantity2] towerCard:towerCard];
    }    
    if (formulaComponent3 >= 0)
    {
        CCSprite * icon = [CCSprite spriteWithTexture:[library GetTextureWithKey:formulaComponent3]];
        icon.scale = 1.0;
        icon.position = ccp(x3,y1);
        [towerCard addChild:icon z:6];
        
        [self makeLabelWithPosition:ccp(x3,y2) scale:1.0 string:[NSString stringWithFormat:@"%d", formulaQuantity3] towerCard:towerCard];
    }
    if (formulaComponent4 >= 0)
    {
        CCSprite * icon = [CCSprite spriteWithTexture:[library GetTextureWithKey:formulaComponent4]];
        icon.scale = 1.0;
        icon.position = ccp(x4,y1);
        [towerCard addChild:icon z:6];
        
        [self makeLabelWithPosition:ccp(x4,y2) scale:1.0 string:[NSString stringWithFormat:@"%d", formulaQuantity4] towerCard:towerCard];
    }
    if (formulaComponent5 >= 0)
    {
        CCSprite * icon = [CCSprite spriteWithTexture:[library GetTextureWithKey:formulaComponent5]];
        icon.scale = 1.0;
        icon.position = ccp(x5,y1);
        [towerCard addChild:icon z:6];
        
        [self makeLabelWithPosition:ccp(x5,y2) scale:1.0 string:[NSString stringWithFormat:@"%d", formulaQuantity5] towerCard:towerCard];
    }
}

- (void)addName:(CCSprite*)towerCard
{
    CCBitmapFontAtlas * output = [CCBitmapFontAtlas bitmapFontAtlasWithString:String_NULL fntFile:Font_UISmall];
    output.position = ccp(171,474-20);
    output.color = ccBLACK;
    output.scale = 2.0;
    [output setString:towerName];
    [towerCard addChild:output z:6];
}

- (void)addIcon:(CCSprite*)towerCard
{
    CCSprite * icon = [CCSprite spriteWithTexture:towerSprite.texture];
    icon.scale = 2.0;
    icon.position = ccp(63,474-127);
    [towerCard addChild:icon z:6];
}

- (void) removeFromLayer
{
    [gameField removeChild:towerSprite cleanup:NO];
}

- (void) removeFromLayerWithCleanup
{
    [gameField removeChild:towerSprite cleanup:YES];
}

- (int) getPower
{
    return towerPower;
}

- (void) setPower:(int)newPower
{
    if (towerPower == newPower)
    {
        if (towerPower == 0)
        {
            [powerDisplay setString:String_NULL];
        }
        else 
        {
            [powerDisplay setString:[NSString stringWithFormat:@"%d", towerPower]];   
        }
        powerDisplay.visible = YES;
        return;
    }
    
    towerPower = newPower;
    
    minDamage = (float)baseMinDamage + ((float)baseMinDamage * towerPower * 0.10);
    maxDamage = (float)baseMaxDamage + ((float)baseMaxDamage * towerPower * 0.10);
    shotRange = (float)baseRange + ((float)baseRange * (towerPower-1) * 0.10);
    //printf("range from power = %d\n", shotRange);
    shotInterval = baseInterval - (baseInterval * towerPower * 0.05);
    if (shotInterval < 0.1)
    {
        shotInterval = 0.1;
    }
    if (towerPower == 0)
    {
        [powerDisplay setString:String_NULL];
    }
    else 
    {
        [powerDisplay setString:[NSString stringWithFormat:@"%d", towerPower]];   
    }
    powerDisplay.visible = YES;
}

- (void) upgrade
{
    if (towerPower < maxPower)
    {
        [self setPower:towerPower+1];
    }
}

- (void) setScale:(float)newScale
{
    if (towerSprite)
        towerSprite.scale = newScale;
}

- (void) setTexture:(CCTexture2D*)newTexture
{
    if (towerSprite)
        towerSprite.texture = newTexture;
}

- (CCTexture2D*) getTexture
{
    if (towerSprite)
        return towerSprite.texture;
    else 
        return nil;
}

- (CGPoint) getTowerPosition
{
    if (towerSprite)
        return towerSprite.position;
    else 
        return CGPointMake(0,0);
}

- (CGSize) getTowerSize
{
    if (towerSprite)
        return towerSprite.contentSize;
    else 
        return CGSizeMake(0,0);  
}

- (void) setColor:(ccColor3B)newColor
{
    if (towerSprite)
        [towerSprite setColor:newColor];
}

- (void) setPositionWithX:(int)x Y:(int)y
{
    if (towerSprite)
        towerSprite.position = ccp(x,y);
}

- (void) show
{
    if (towerSprite)
        [towerSprite setVisible:YES];
}

- (void) hide
{
    if (towerSprite)
        [towerSprite setVisible:NO];
}

- (void) UpdateTargets:(double)elapsed
{
    shotTimer += elapsed;
    if (shotTimer > shotInterval)
    {
        NSMutableArray * toRemove = [[NSMutableArray alloc] init];
        for (Creep * target in targets)
        {
            if (target && [gameField distanceBetweenPointsA:target.creepSprite.position B:towerSprite.position] < shotRange)
            {
                [gameField.combatManager shootWithTower:self creep:target];
                //printf("shooting target\n");
                if (switchTargetsAfterHit)
                {
                    [toRemove addObject:target];
                    //printf("switching target 1\n");
                }
            }
            else 
            {
                [toRemove addObject:target];
                //printf("switching target 2\n");
            }
        }
        for (Creep * target in toRemove)
        {
            [targets removeObject:target];
        }
        shotTimer = 0.0;
    }
    if ([targets count] < maxTargets)
    {
        int targetsToFind = maxTargets - [targets count];
        for (int i = 0; i < targetsToFind; i++)
        {
            float bestdistance = 10000.0;
            float thisdistance;
            Creep * target = nil;
            for (Creep * creep in currentSpawner.creeps)
            {
                thisdistance = [gameField distanceBetweenPointsA:creep.creepSprite.position B:towerSprite.position];
                if (thisdistance < bestdistance && thisdistance < shotRange && ![targets containsObject:creep])
                {
                    bestdistance = thisdistance;
                    target = creep;
                    //printf("new target\n");
                }
            }
            if (target)
                [targets addObject:target];
        }
    }
}

- (void) tick:(double)elapsed
{
    switch (targetType) {
        case TowerTargetType_None: break;
        case TowerTargetType_Single: [self UpdateTargets:elapsed]; break;
        case TowerTargetType_Multi: [self UpdateTargets:elapsed]; break;
        default:
            break;
    }
}

- (void) creepGone:(Creep*)creep
{
    if ([targets containsObject:creep])
    {
        [targets removeObject:creep];
    }
        
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
