//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <Foundation/Foundation.h>

/**
 The RCCBathtubData class stores information about the simulated bathtub and calclualtes its stats at any given time.
 */

@interface RCCBathtubData : NSObject

# pragma mark - Properties

// Water tap data

/**
 Temperature of the water flowing out of the cold water tap.
 */
@property (strong) NSNumber *waterTapColdWaterTemp;

/**
 Temperature of the water flowing out of the hot water tap.
 */
@property (strong) NSNumber *waterTapHotWaterTemp;

/**
 Amount of water flowing out of the cold water tap in liters/s.
 */
@property (strong) NSNumber *waterTapColdWaterFlowMax;

/**
 Amount of water flowing out of the hot water tap in liters/s.
 */
@property (strong) NSNumber *waterTapHotWaterFlowMax;

// Bathtub data

/**
 Maximum amount of water the bathtub can safely contain.
 */
@property (strong) NSNumber *bathTubWaterAmountMax;

// Stats

/**
 Total amount of water that is flown during the simulation. This property is beeing updated in repeatedly in fixed time intervals during a running simulation (see
 method [RCCRemoteBathtubController startUpdatingStatsWithTimeInterval:]). This property is meant to be observed via KVO.
 */
@property (strong) NSNumber *totalFlownWater;

/**
 Temperature of the total sum of water in the virtual bathtub at the time this value was updated the last time during a running simulation. This property is meant to be observed via KVO.
 */
@property (strong) NSNumber *totalTemperature;

# pragma mark - Setters

/**
 Sets the amount of cold water that is flowing out of the cold water tap.
 @param amount Amount of water: 0 = tap is closed, 1  = water flowing at full rate specified in @property waterTapColdWaterFlowMax
 */

- (void)setColdWaterFlow:(NSNumber *)amount;

/**
 Sets the amount of cold water that is flowing out of the hot water tap.
 @param amount Amount of water: 0 = tap is closed, 1  = water flowing at full rate specified in @property waterTapHotWaterFlowMax
 */

- (void)setHotWaterFlow:(NSNumber *)amount;

# pragma mark - Stats

/**
 Calculates the total amount of water that is flown during the simulation. This method is only meant to be used by the RCCRemoteBathtubController class.
 @return Total amount of water that is flown until this method was called.
 */

- (NSNumber *)calculateTotalFlownWater;

/**
 Calculates the total temperature of all the total sum of water that is flown during the simulation. This method is only meant to be used by the RCCRemoteBathtubController class.
 @return Temperature of the total amount of water that is flown until this method was called.
 */

- (NSNumber *)calculateTotalTemperature;

@end