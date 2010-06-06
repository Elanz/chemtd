//
//  TrapEffect.h
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEffect.h"
#import "cocos2d.h"

@interface AOESpriteTrapEffect : BaseEffect {
    
    CCSprite * trapSprite;
    float dotTimer;
    float dotElapsed;
    int range;
}

- (id) initWithSourceField:(BaseTower*)sourceTower target:(GameFieldScene*)targetField position:(CGPoint)targetPosition;
- (void) startEffect;
- (void) finishEffect;
- (void) updateEffect: (double) elapsed;

@end
