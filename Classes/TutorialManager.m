//
//  TutorialManager.m
//  ChemTD
//
//  Created by Eric Lanz on 6/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TutorialManager.h"
#import "GameFieldScene.h"
#import "TextureLibrary.h"

@implementation TutorialManager

- (id) initWithField:(GameFieldScene*)field
{
    if( (self=[super init] )) 
    {
        UILayer = field.UILayer;
        library = field.textureLibrary;
    }
    return self;
}

- (void) showIntroTutorial
{
    introTutorial = [CCSprite spriteWithTexture:[library GetTextureWithKey:UITEXTURE_TUTORIALINTRO]];
    introTutorial.position = ccp(551, device_height-287);
    introTutorial.opacity = 0.0;
    [introTutorial runAction:[CCFadeIn actionWithDuration:0.3]];
    [UILayer addChild:introTutorial z:5];
    id action1 = [CCDelayTime actionWithDuration:10.0];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(startHidingTutorialIntro)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [introTutorial runAction:action3];
}

- (void) showCreepsTutorial
{
    creepsTutorial = [CCSprite spriteWithTexture:[library GetTextureWithKey:UITEXTURE_TUTORIALCREEPS]];
    creepsTutorial.position = ccp(487, device_height-369);
    creepsTutorial.opacity = 0.0;
    [creepsTutorial runAction:[CCFadeIn actionWithDuration:0.3]];
    [UILayer addChild:creepsTutorial z:5];
    id action1 = [CCDelayTime actionWithDuration:5.0];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(startHidingTutorialCreeps)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [creepsTutorial runAction:action3];
}

- (void) showMixTutorial
{
    mixTutorial = [CCSprite spriteWithTexture:[library GetTextureWithKey:UITEXTURE_TUTORIALMIX]];
    mixTutorial.position = ccp(274, device_height-569);
    mixTutorial.opacity = 0.0;
    [mixTutorial runAction:[CCFadeIn actionWithDuration:0.3]];
    [UILayer addChild:mixTutorial z:5];
    id action1 = [CCDelayTime actionWithDuration:4.0];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(startHidingTutorialMix)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [mixTutorial runAction:action3];
}

- (void) showPlaceTutorial
{
    placeTutorial = [CCSprite spriteWithTexture:[library GetTextureWithKey:UITEXTURE_TUTORIALPLACE]];
    placeTutorial.position = ccp(596, device_height-233);
    placeTutorial.opacity = 0.0;
    [placeTutorial runAction:[CCFadeIn actionWithDuration:0.3]];
    id action1 = [CCDelayTime actionWithDuration:3.0];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(startHidingTutorialPlace)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [placeTutorial runAction:action3];
    [UILayer addChild:placeTutorial z:5];
}

- (void) showBuildTutorial
{
    buildTutorial = [CCSprite spriteWithTexture:[library GetTextureWithKey:UITEXTURE_TUTORIALBUILD]];
    buildTutorial.position = ccp(551, device_height-287);
    buildTutorial.opacity = 0.0;
    [buildTutorial runAction:[CCFadeIn actionWithDuration:0.3]];
    [UILayer addChild:buildTutorial z:5];
    id action1 = [CCDelayTime actionWithDuration:5.0];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(startHidingTutorialBuild)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [buildTutorial runAction:action3];
}

- (void) startHidingTutorialIntro
{
    [introTutorial runAction:[CCFadeOut actionWithDuration:0.3]];
    id action1 = [CCDelayTime actionWithDuration:0.4];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(removeTutorialIntro)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [introTutorial runAction:action3];
}

- (void) startHidingTutorialCreeps
{
    [creepsTutorial runAction:[CCFadeOut actionWithDuration:0.3]];
    id action1 = [CCDelayTime actionWithDuration:0.4];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(removeTutorialCreeps)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [creepsTutorial runAction:action3];
}

- (void) startHidingTutorialMix
{
    [mixTutorial runAction:[CCFadeOut actionWithDuration:0.3]];
    id action1 = [CCDelayTime actionWithDuration:0.4];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(removeTutorialMix)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [mixTutorial runAction:action3];
}

- (void) startHidingTutorialPlace
{
    [placeTutorial runAction:[CCFadeOut actionWithDuration:0.3]];
    id action1 = [CCDelayTime actionWithDuration:0.4];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(removeTutorialPlace)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [placeTutorial runAction:action3];
}

- (void) startHidingTutorialBuild
{
    [buildTutorial runAction:[CCFadeOut actionWithDuration:0.3]];
    id action1 = [CCDelayTime actionWithDuration:0.4];
    id action2 = [CCCallFunc actionWithTarget:self selector:@selector(removeTutorialBuild)];
    id action3 = [CCSequence actions:action1, action2, nil];
    [buildTutorial runAction:action3];
}

- (void) removeTutorialIntro
{
    [UILayer removeChild:introTutorial cleanup:YES];
    [self showBuildTutorial];
}

- (void) removeTutorialCreeps
{
    [UILayer removeChild:creepsTutorial cleanup:YES];
}

- (void) removeTutorialMix
{
    [UILayer removeChild:mixTutorial cleanup:YES];
}

- (void) removeTutorialPlace
{
    [UILayer removeChild:placeTutorial cleanup:YES];
}

- (void) removeTutorialBuild
{
    [UILayer removeChild:buildTutorial cleanup:YES];
}


@end
