//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCBathtubData.h"

// Inherited classes
#import "RCCWaterFlow.h"

@interface RCCBathtubData()

#pragma mark - Properties (private)

@property (strong) NSMutableArray *waterFlows;

@end

@implementation RCCBathtubData(Private)

# pragma mark - Utility (private)

- (void)saveWaterFlow:(NSNumber *)rate withTag:(NSNumber *)tag temperature:(NSNumber *)temp {
	
	// Find recent flow with tag
	NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"tag == %@",tag];
	RCCWaterFlow *recentFlow = [[self.waterFlows filteredArrayUsingPredicate:predicate] lastObject];
	
	// Stop recent flow if it is still active
	if ([recentFlow isActive]) [recentFlow stop];

	// Store new flow object
	if ([rate floatValue]) {
		RCCWaterFlow *flow = [RCCWaterFlow flowWithRate:rate tag:tag temperature:temp];
		[self.waterFlows addObject:flow];
	}
}

@end

@implementation RCCBathtubData

# pragma mark - Initialization

- (instancetype)init {
	
	self = [super init];
	if (self) {
		
		// Init flow array
		self.waterFlows = [NSMutableArray array];
	}
	return self;
}

# pragma mark - Setters

- (void)setColdWaterFlow:(NSNumber *)amount {
	
	// It's not allowed to call this method with a nil argument
	ZAssert((([amount floatValue] >= 0.0f) && ([amount floatValue] <= 1.0f)), @"VIOLATION: Method argument (percentage = %@) must not exceed 1 or unerrun 0.", amount);
	
	// Store water flow
	NSNumber *flowRate = [NSNumber numberWithDouble:([self.waterTapColdWaterFlowMax floatValue] * [amount doubleValue])];
	[self saveWaterFlow:flowRate withTag:kRCCBathtubDataFlowTagCold temperature:self.waterTapColdWaterTemp];
}
- (void)setHotWaterFlow:(NSNumber *)amount {
	
	// It's not allowed to call this method with a nil argument
	ZAssert((([amount floatValue] >= 0.0f) && ([amount floatValue] <= 1.0f)), @"VIOLATION: Method argument (percentage = %@) must not exceed 1 or unerrun 0.", amount);
	
	// Store water flow
	NSNumber *flowRate = [NSNumber numberWithDouble:([self.waterTapHotWaterFlowMax doubleValue] * [amount doubleValue])];
	[self saveWaterFlow:flowRate withTag:kRCCBathtubDataFlowTagHot temperature:self.waterTapHotWaterTemp];
}

# pragma mark - Stats

- (NSNumber *)calculateTotalFlownWater {
	
	double total = 0.0;
	for (RCCWaterFlow *flow in self.waterFlows) {
		total += [[flow flownWater] doubleValue];
	}
	
	// Returns amount of water in liters
	return [NSNumber numberWithDouble:total];
}
- (NSNumber *)calculateTotalTemperature {
	
	// Division of these values returns the temperature in degrees C
	CGFloat divident = 0.0f;
	CGFloat divisor = 0.0f;
	
	for (RCCWaterFlow *flow in self.waterFlows) {
		
		// Dividient
		// Amount roughly equals weight in kg
		CGFloat amount = [[flow flownWater] floatValue];
		// Temperature in degrees C
		CGFloat temperature = [[flow temperature] floatValue];
		// Multiply
		divident += (amount * temperature);
		
		// Divisor
		// Amount roughly equals weight in kg
		divisor += amount;
	}
	
	CGFloat temperature = (divident / divisor);
	
	return [NSNumber numberWithDouble:temperature];
}

@end