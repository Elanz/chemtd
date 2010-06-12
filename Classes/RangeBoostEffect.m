//
//  AOERangeBoostEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RangeBoostEffect.h"
#import "BaseTower.h"

@implementation RangeBoostEffect

- (id) initWithTargetTower:(BaseTower*)targetTower
{
    if ((self = [super initWithTargetTower:targetTower]))
    {
        
    }
    return self;
}

- (void) startEffect
{
    tower.shotRange += (float)tower.shotRange * 0.15;
    //printf("new range = %d\n", tower.shotRange);
}

- (void) finishEffect
{
    tower.shotRange = tower.baseRange;
}

- (void) updateEffect: (double) elapsed
{

}

@end
