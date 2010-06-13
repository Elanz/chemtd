//
//  PathFinding.m
//  tdtest
//
//  Created by Eric Lanz on 5/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PathFinding.h"
#import "GameFieldScene.h"

@implementation PathFindNode
+(id)node
{
	return [[[PathFindNode alloc] init] autorelease];
}
@end

@implementation PathFinding

-(id) init
{
    self = [super init];
    gameField = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];
    pathCache = [[NSMutableDictionary alloc] init];
    return self;
    
}

- (void) resetPathCache
{
    [pathCache removeAllObjects];
}

-(PathFindNode*)nodeInArray:(NSMutableArray*)a withX:(int)x Y:(int)y
{
	//Quickie method to find a given node in the array with a specific x,y value
	NSEnumerator *e = [a objectEnumerator];
	PathFindNode *n;
	if(e)
	{
		while((n = [e nextObject]))
		{
			if((n->nodeX == x) && (n->nodeY == y))
			{
				return n;
			}
		}
	}
	return nil;
}

-(PathFindNode*)lowestCostNodeInArray:(NSMutableArray*)a
{
	//Finds the node in a given array which has the lowest cost
	PathFindNode *n, *lowest;
	lowest = nil;
	NSEnumerator *e = [a objectEnumerator];
	if(e)
	{
		while((n = [e nextObject]))
		{
			if(lowest == nil)
			{
				lowest = n;
			}
			else
			{
				if(n->cost < lowest->cost)
				{
					lowest = n;
				}
			}
		}
		return lowest;
	}
	return nil;
}

-(NSMutableArray *)findPath:(int)startX :(int)startY :(int)endX :(int)endY
{
    if (!gameField)
        gameField = (GameFieldScene*)[[CCDirector sharedDirector].runningScene getChildByTag:CCNodeTag_GameField];
    
    NSString * key = [NSString stringWithFormat:@"%d%d_%d%d", startX, startY, endX, endY];
    if ([pathCache objectForKey:key])
    {
        //printf("fetching key = %s\n", [key UTF8String]);
        return [pathCache objectForKey:key];
    }
    
	//find path function. takes a starting point and end point and performs the A-Star algorithm
	//to find a path, if possible. Once a path is found it can be traced by following the last
	//node's parent nodes back to the start
	int newX,newY;
	int currentX,currentY;
	NSMutableArray *openList, *closedList;
	
	if((startX == endX) && (startY == endY))
		return nil;
	
	openList = [NSMutableArray array];
	closedList = [NSMutableArray array];
	
	PathFindNode *currentNode = nil;
	PathFindNode *aNode = nil;
	
	PathFindNode *startNode = [PathFindNode node];
	startNode->nodeX = startX;
	startNode->nodeY = startY;
	startNode->parentNode = nil;
	startNode->cost = 0;
	[openList addObject: startNode];
	
	while([openList count])
	{
		currentNode = [self lowestCostNodeInArray: openList];
		
        //printf("current x,y = %d,%d / goal x,y = %d,%d\n", currentNode->nodeX, currentNode->nodeY, endX, endY);
        
		if((currentNode->nodeX == endX) && (currentNode->nodeY == endY))
		{
			
			//********** PATH FOUND ********************	
			
			//*****************************************//
			//NOTE: Code below is for the Demo app to trace/mark the path
            NSMutableArray * waypoints = [[NSMutableArray alloc] init];
            
            PathFindNode *goalNode = [PathFindNode node];
            goalNode->nodeX = endX;
            goalNode->nodeY = endY;
            goalNode->parentNode = nil;
            goalNode->cost = 0;
            [waypoints addObject:goalNode];
            
			aNode = currentNode->parentNode;
			while(aNode->parentNode != nil)
			{
                [waypoints addObject:aNode];
				aNode = aNode->parentNode;
			}
            
            //printf("adding key = %s\n", [key UTF8String]);
            [pathCache setObject:waypoints forKey:key];
            
			return waypoints;
			//*****************************************//
		}
		else
		{
			[closedList addObject: currentNode];
			[openList removeObject: currentNode];
			currentX = currentNode->nodeX;
			currentY = currentNode->nodeY;
			//check left
            newX = currentX - 1;
            newY = currentY;
            //simple bounds check for the demo app's array
            if((newX>=0)&&(newY>=0)&&(newX<mapWidth)&&(newY<mapHeight))
            {
                if(![self nodeInArray: openList withX: newX Y:newY])
                {
                    if(![self nodeInArray: closedList withX: newX Y:newY])
                    {
                        if([gameField check1x1SpaceWalkable: newX :newY])
                        {
                            aNode = [PathFindNode node];
                            aNode->nodeX = newX;
                            aNode->nodeY = newY;
                            aNode->parentNode = currentNode;
                            aNode->cost = currentNode->cost + 1;
                            
                            //Compute your cost here. This demo app uses a simple manhattan
                            //distance, added to the existing cost
                            aNode->cost += [gameField distanceBetweenPointsA:ccp(newX, newY) B:ccp(endX, endY)];
                            //////////
                            
                            [openList addObject: aNode];
                        }
                    }
                }
            }
            //check right
            newX = currentX + 1;
            newY = currentY;
            //simple bounds check for the demo app's array
            if((newX>=0)&&(newY>=0)&&(newX<mapWidth)&&(newY<mapHeight))
            {
                if(![self nodeInArray: openList withX: newX Y:newY])
                {
                    if(![self nodeInArray: closedList withX: newX Y:newY])
                    {
                        if([gameField check1x1SpaceWalkable: newX :newY])
                        {
                            aNode = [PathFindNode node];
                            aNode->nodeX = newX;
                            aNode->nodeY = newY;
                            aNode->parentNode = currentNode;
                            aNode->cost = currentNode->cost + 1;
                            
                            //Compute your cost here. This demo app uses a simple manhattan
                            //distance, added to the existing cost
                            aNode->cost += [gameField distanceBetweenPointsA:ccp(newX, newY) B:ccp(endX, endY)];
                            //////////
                            
                            [openList addObject: aNode];
                        }
                    }
                }
            }
            //check top
            newX = currentX;
            newY = currentY - 1;
            //simple bounds check for the demo app's array
            if((newX>=0)&&(newY>=0)&&(newX<mapWidth)&&(newY<mapHeight))
            {
                if(![self nodeInArray: openList withX: newX Y:newY])
                {
                    if(![self nodeInArray: closedList withX: newX Y:newY])
                    {
                        if([gameField check1x1SpaceWalkable: newX :newY])
                        {
                            aNode = [PathFindNode node];
                            aNode->nodeX = newX;
                            aNode->nodeY = newY;
                            aNode->parentNode = currentNode;
                            aNode->cost = currentNode->cost + 1;
                            
                            //Compute your cost here. This demo app uses a simple manhattan
                            //distance, added to the existing cost
                            aNode->cost += [gameField distanceBetweenPointsA:ccp(newX, newY) B:ccp(endX, endY)];
                            //////////
                            
                            [openList addObject: aNode];
                        }
                    }
                }
            }
            //check bottom
            newX = currentX;
            newY = currentY + 1;
            //simple bounds check for the demo app's array
            if((newX>=0)&&(newY>=0)&&(newX<mapWidth)&&(newY<mapHeight))
            {
                if(![self nodeInArray: openList withX: newX Y:newY])
                {
                    if(![self nodeInArray: closedList withX: newX Y:newY])
                    {
                        if([gameField check1x1SpaceWalkable: newX :newY])
                        {
                            aNode = [PathFindNode node];
                            aNode->nodeX = newX;
                            aNode->nodeY = newY;
                            aNode->parentNode = currentNode;
                            aNode->cost = currentNode->cost + 1;
                            
                            //Compute your cost here. This demo app uses a simple manhattan
                            //distance, added to the existing cost
                            aNode->cost += [gameField distanceBetweenPointsA:ccp(newX, newY) B:ccp(endX, endY)];
                            //////////
                            
                            [openList addObject: aNode];
                        }
                    }
                }
            }
		}		
	}
	printf("**** NO PATH FOUND *****\n");
    return nil;
}

@end
