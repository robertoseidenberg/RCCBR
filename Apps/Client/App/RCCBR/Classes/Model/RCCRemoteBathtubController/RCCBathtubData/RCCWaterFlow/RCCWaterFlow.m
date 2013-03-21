//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCWaterFlow.h"

@interface RCCWaterFlow()

#pragma mark - Properties (private)

@property (strong) NSDate   *startTime;
@property (strong) NSDate   *stopTime;

@end

@implementation RCCWaterFlow

#pragma mark - Initialization

+ (instancetype)flowWithRate:(NSNumber *)rate tag:(NSNumber *)tag temperature:(NSNumber *)temp {
	
	return [[self alloc] initWithRate:rate tag:(NSNumber *)tag temperature:temp];
}
- (instancetype)initWithRate:(NSNumber *)rate tag:(NSNumber *)tag temperature:(NSNumber *)temp {
	
	// It's not allowed to call this method with a nil argument
	ZAssert(rate, @"VIOLATION: Method argument (NSNumber *)rate: %@", rate);
	ZAssert(temp, @"VIOLATION: Method argument (NSNumber *)temp: %@", temp);
	
	self = [super init];
	if (self) {
		self.tag         = tag;
		self.rate        = rate;
		self.temperature = temp;
		self.startTime   = [NSDate date];
	}
	return self;
}

# pragma mark - Utility

// Start/stop flow
- (void)start {
	
	self.startTime = [NSDate date];
}
- (void)stop {
	
	self.stopTime = [NSDate date];
}

// Flow state
- (BOOL)isActive {
	
	return (!self.stopTime);
}
- (NSNumber *)flownWater {
	
	// Use current time if flow did not stop yet
	NSDate *stop; if (self.stopTime) {stop = self.stopTime;} else {stop = [NSDate date];}
	
	// Calculate how many seconds the flow is active
	double seconds = [stop timeIntervalSinceDate:self.startTime];
	
	// Calculate amount of water
	double amount = seconds * [self.rate doubleValue];
	
	// Returns amount of water in liters
	return [NSNumber numberWithDouble:amount];
}

@end