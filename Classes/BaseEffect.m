//
//  BaseEffect.m
//  ChemTD
//
//  Created by Eric Lanz on 6/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BaseEffect.h"
#import "BaseTower.h"
#import "Creep.h"

@implementation BaseEffect

@synthesize effectType;

- (id) initWithSource:(BaseTower*)sourceTower target:(Creep*)targetCreep
{
    if ((self = [super init])) {
        source = sourceTower;
        target = targetCreep;
    }
    return self;
}


- (void) refreshEffect
{
    duration = maxDuration;
}

- (void) startEffect
{
    
}

- (void) finishEffect
{
    
}

- (void) updateEffect: (double) elapsed
{
    
}

@end
