//
//  AOERangeBoostEffect.h
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEffect.h"
#import "cocos2d.h"

@interface RangeBoostEffect : BaseEffect {

}

- (id) initWithTargetTower:(BaseTower*)targetTower;
- (void) startEffect;
- (void) finishEffect;
- (void) updateEffect: (double) elapsed;

@end
