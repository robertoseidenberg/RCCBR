//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <Foundation/Foundation.h>

#pragma mark - Constants

#define kRCCBathtubDataFlowTagCold @0
#define kRCCBathtubDataFlowTagHot  @1

/**
 A RCCWaterFlow object defines a flow of water with a steady rate and a steady temperature that happened over a specific amount of time.
 */

@interface RCCWaterFlow : NSObject

#pragma mark - Properties

/**
 Tag specifying the type of flow (kRCCBathtubDataFlowTagCold or kRCCBathtubDataFlowTagHot)
 */

@property (strong) NSNumber *tag;

/**
 Rate of the flow in liters/s
 */

@property (strong) NSNumber *rate;

/**
 Water temperature
 */

@property (strong) NSNumber *temperature;

# pragma mark - Initialization

/**
 Creates and initializes a new RCCWaterFlow object.
 @param rate Rate of the flow in liters/s
 @param tag Tag specifying the type of flow (kRCCBathtubDataFlowTagCold or kRCCBathtubDataFlowTagHot)
 @param temp Water temperature
 */

+ (instancetype)flowWithRate:(NSNumber *)rate tag:(NSNumber *)tag temperature:(NSNumber *)temp;

/**
 Initializes a new RCCWaterFlow object.
 @param rate Rate of the flow in liters/s
 @param tag Tag specifying the type of flow (kRCCBathtubDataFlowTagCold or kRCCBathtubDataFlowTagHot)
 @param temp Water temperature
 */

- (instancetype)initWithRate:(NSNumber *)rate tag:(NSNumber *)tag temperature:(NSNumber *)temp;

# pragma mark - Utility

// Start/stop flow

/**
 Starts the virtual water flow with the specified value (means: turn on the tap)
 */

- (void)start;

/**
 Stops the virtual water flow with the specified value (means: turn on the tap)
 */

- (void)stop;

// Flow state

/**
 A Boolean value indicating whether the water is flowing (means: the tap is running).
 @return BOOL isActive
 */

- (BOOL)isActive;

/**
 Amount of water that is flown until this methods was called.
 @return NSNumber 
 */

- (NSNumber *)flownWater;

@end