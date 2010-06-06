//
//  TextureLibrary.m
//  ChemTD
//
//  Created by Eric Lanz on 5/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TextureLibrary.h"


@implementation TextureLibrary

- (id) init
{
    if( (self=[super init] )) 
    {
        library = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (CCTexture2D *) LoadTextureWithName:(NSString *)textureName textureKey:(int)textureKey isPVR:(BOOL)isPVR
{
    if (![library objectForKey:[NSNumber numberWithInt:textureKey]])
    {
        if (isPVR)
        {
            NSString * realPath = [[NSBundle mainBundle] pathForResource:textureName ofType:nil];
            [library setObject:[[CCTexture2D alloc] initWithPVRTCFile:realPath] forKey:[NSNumber numberWithInt:textureKey]];
        }
        else 
        {
            
            [library setObject:[[CCTexture2D alloc] initWithImage:[UIImage imageNamed:textureName]] forKey:[NSNumber numberWithInt:textureKey]];
        }
    }
    
    return [library objectForKey:[NSNumber numberWithInt:textureKey]];        
}

- (CCTexture2D *) GetTowerTextureWithKey:(int)textureKey
{
    CCTexture2D * output = nil;
    switch (textureKey) {
        case TOWERTEXTURE_HYDROGEN: return [self LoadTextureWithName:@"hydrogen.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_OXYGEN: return [self LoadTextureWithName:@"oxygen.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_NITROGEN: return [self LoadTextureWithName:@"nitrogen.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_WATER: return [self LoadTextureWithName:@"water.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_ACETYLENE: return [self LoadTextureWithName:@"acetylene.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_AMMONIA: return [self LoadTextureWithName:@"ammonia.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_ASPIRIN: return [self LoadTextureWithName:@"aspirin.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_BAKINGSODA: return [self LoadTextureWithName:@"bakingsoda.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_BLEACH: return [self LoadTextureWithName:@"bleach.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CAFFEINE: return [self LoadTextureWithName:@"caffeine.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CAPSAICIN: return [self LoadTextureWithName:@"capsaicin.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CARBON: return [self LoadTextureWithName:@"carbon.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CARBONDIOXIDE: return [self LoadTextureWithName:@"carbondioxide.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CARBONMONOXIDE: return [self LoadTextureWithName:@"carbonmonoxide.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CHLORINE: return [self LoadTextureWithName:@"chlorine.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CHLOROFORM: return [self LoadTextureWithName:@"chloroform.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_CYANIDE: return [self LoadTextureWithName:@"cyanide.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_ETHANOL: return [self LoadTextureWithName:@"ethanol.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_HYDROCHLORICACID: return [self LoadTextureWithName:@"hydrochloricacid.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_METHANE: return [self LoadTextureWithName:@"methane.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_NITRICACID: return [self LoadTextureWithName:@"nitricacid.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_NITROGLYCERINE: return [self LoadTextureWithName:@"nitroglycerine.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_NITROUS: return [self LoadTextureWithName:@"nitrous.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_RDX: return [self LoadTextureWithName:@"rdx.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_RUBBER: return [self LoadTextureWithName:@"rubber.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_SALT: return [self LoadTextureWithName:@"salt.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_SODIUM: return [self LoadTextureWithName:@"sodium.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_TETRODOTOXIN: return [self LoadTextureWithName:@"tetrodotoxin.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_TNT: return [self LoadTextureWithName:@"tnt.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_TYLENOL: return [self LoadTextureWithName:@"tylenol.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_VALIUM: return [self LoadTextureWithName:@"valium.png" textureKey:textureKey isPVR:NO]; break;
        case TOWERTEXTURE_VITAMINC: return [self LoadTextureWithName:@"vitaminc.png" textureKey:textureKey isPVR:NO]; break;
        default:
            break;
    }
    return output;
}

- (CCTexture2D *) GetColorTextureWithKey:(int)textureKey
{
    CCTexture2D * output = nil;
    switch (textureKey) {
        case COLORTEXTURE_GRAY: return [self LoadTextureWithName:@"Gray.png" textureKey:textureKey isPVR:NO]; break;
        case COLORTEXTURE_BROWN: return [self LoadTextureWithName:@"Brown.png" textureKey:textureKey isPVR:NO]; break;
        case COLORTEXTURE_PURPLE: return [self LoadTextureWithName:@"Purple.png" textureKey:textureKey isPVR:NO]; break;
        case COLORTEXTURE_CLEAR: return [self LoadTextureWithName:@"Transparent.png" textureKey:textureKey isPVR:NO]; break;
        default:
            break;
    }
    return output;
}

- (CCTexture2D *) GetUITextureWithKey:(int)textureKey
{
    CCTexture2D * output = nil;
    switch (textureKey) {
        case UITEXTURE_REDX: return [self LoadTextureWithName:@"redX.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_TOWERMANAGERBACKGROUND: return [self LoadTextureWithName:@"TowerManager.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_TOWERMANAGERUPGRADEUP: return [self LoadTextureWithName:@"btn_TowerManagerUpgrade_Up.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_TOWERMANAGERUPGRADEDOWN: return [self LoadTextureWithName:@"btn_TowerManagerUpgrade_Down.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_TOWERMANAGERDOWNGRADEUP: return [self LoadTextureWithName:@"btn_TowerManagerDowngrade_Up.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_TOWERMANAGERDOWNGRADEDOWN: return [self LoadTextureWithName:@"btn_TowerManagerDowngrade_Down.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_MAINMENUBACKGROUND: return [self LoadTextureWithName:@"MainMenuBackground.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_CHALLENGESBTNUP: return [self LoadTextureWithName:@"ChallengesBtnUp.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_CHALLENGESBTNDOWN: return [self LoadTextureWithName:@"ChallengesBtnDown.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_CHANGEUSERBTN: return [self LoadTextureWithName:@"ChangeUserBtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_EXPLOREBTNUP: return [self LoadTextureWithName:@"ExploreBtnUp.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_EXPLOREBTNDOWN: return [self LoadTextureWithName:@"ExploreBtnDown.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_PLAYBTNUP: return [self LoadTextureWithName:@"PlayBtnUp.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_PLAYBTNDOWN: return [self LoadTextureWithName:@"PlayBtnDown.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_RANKINGBTNUP: return [self LoadTextureWithName:@"RankingBtnUp.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_RANKINGBTNDOWN: return [self LoadTextureWithName:@"RankingBtnDown.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_PAUSEBTN: return [self LoadTextureWithName:@"PauseBtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_MINIMENU: return [self LoadTextureWithName:@"mini-menu.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_MAINMENUBTN: return [self LoadTextureWithName:@"mainMenuBtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_RESUMEBTN: return [self LoadTextureWithName:@"resumeBtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_NEWGAMEBTN: return [self LoadTextureWithName:@"newGameBtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_LOGINBACKGROUND: return [self LoadTextureWithName:@"LoginBackground.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_LEVELCLEARBACKGROUND: return [self LoadTextureWithName:@"levelClearBackground.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_CONTINUEBTN: return [self LoadTextureWithName:@"continueBtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_SCOREBTN: return [self LoadTextureWithName:@"scorebtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_TIMEBTN: return [self LoadTextureWithName:@"timebtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_DAMAGEBTN: return [self LoadTextureWithName:@"damagebtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_YOUWINBACKGROUND: return [self LoadTextureWithName:@"youWinBackground.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_YOULOSEBACKGROUND: return [self LoadTextureWithName:@"youLoseBackground.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_OVERALLRANKINGBACKGROUND: return [self LoadTextureWithName:@"overallRankingBackground.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_EXPLORERBACKGROUND: return [self LoadTextureWithName:@"exploreBackground.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_TOWERCARDBACKGROUND: return [self LoadTextureWithName:@"towercardtemplate.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_EASYBTN: return [self LoadTextureWithName:@"easybtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_MEDIUMBTN: return [self LoadTextureWithName:@"mediumbtn.png" textureKey:textureKey isPVR:NO]; break;
        case UITEXTURE_HARDBTN: return [self LoadTextureWithName:@"hardbtn.png" textureKey:textureKey isPVR:NO]; break;
        default:
            break;
    }
    return output;
}

- (CCTexture2D *) GetFieldTextureWithKey:(int)textureKey
{
    CCTexture2D * output = nil;
    switch (textureKey) {
        case FIELDTEXTURE_BACKGROUND1LR: return [self LoadTextureWithName:@"background1_lowerright.png" textureKey:textureKey isPVR:NO]; break;
        case FIELDTEXTURE_BACKGROUND1LL: return [self LoadTextureWithName:@"background1_lowerleft.png" textureKey:textureKey isPVR:NO]; break;
        case FIELDTEXTURE_BACKGROUND1UL: return [self LoadTextureWithName:@"background1_upperleft.png" textureKey:textureKey isPVR:NO]; break;
        case FIELDTEXTURE_BACKGROUND1UR: return [self LoadTextureWithName:@"background1_upperright.png" textureKey:textureKey isPVR:NO]; break;   
        case FIELDTEXTURE_RANGEINDICATOR: return [self LoadTextureWithName:@"RangeIndicator.png" textureKey:textureKey isPVR:NO]; break;
        case FIELDTEXTURE_BLEACHTRAP: return [self LoadTextureWithName:@"bleachtrap.png" textureKey:textureKey isPVR:NO]; break;
        default:
            break;
    }
    return output;
}

- (CCTexture2D *) GetCreepTextureWithKey:(int)textureKey
{
    CCTexture2D * output = nil;
    switch (textureKey) {
        case CREEPTEXTURE_REDARROW: return [self LoadTextureWithName:@"creep.png" textureKey:textureKey isPVR:NO]; break;
        default:
            break;
    }
    return output;
}

- (CCTexture2D *) GetTextureWithKey:(int)textureKey
{
    CCTexture2D * output = nil;
    if (textureKey >= TOWERTEXTURE_SECTIONSTART && textureKey <= TOWERTEXTURE_SECTIONEND)
        return [self GetTowerTextureWithKey:textureKey];
    if (textureKey >= COLORTEXTURE_SECTIONSTART && textureKey <= COLORTEXTURE_SECTIONEND)
        return [self GetColorTextureWithKey:textureKey];
    if (textureKey >= UITEXTURE_SECTIONSTART && textureKey <= UITEXTURE_SECTIONEND)
        return [self GetUITextureWithKey:textureKey];
    if (textureKey >= FIELDTEXTURE_SECTIONSTART && textureKey <= FIELDTEXTURE_SECTIONEND)
        return [self GetFieldTextureWithKey:textureKey];
    if (textureKey >= CREEPTEXTURE_SCTIONSTART && textureKey <= CREEPTEXTURE_SCTIONEND)
        return [self GetCreepTextureWithKey:textureKey];
    return output;
}

@end
