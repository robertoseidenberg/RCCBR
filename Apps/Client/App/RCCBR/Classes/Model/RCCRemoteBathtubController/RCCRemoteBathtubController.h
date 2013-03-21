//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <Foundation/Foundation.h>

// App classes
// Model
#import "RCCBathtubData.h"

/**
 The RCCRemoteBathtubController acts as the only interface in order to monitor the state of a remote bathtub.
 You do not instantiate a RCCBAthtubData object directly. Instead you acces this object as a property in an newly instantiated RCCRemoteBathtubController.
 RCCUbiquitousObjectsController handles fetching of data from the server and updating the RCCBAthtubData object which contains all the information about the remote bathtub.
 The RCCBAthtubData object is beeing exposed as a property and can be observed in order to react on changes of the data.
 
 RCCRemoteBathtubController must not be initialized with any other but method initWithURL:
 */

@interface RCCRemoteBathtubController : NSObject

#pragma mark - Properties

@property (strong) RCCBathtubData *bathtubData;

# pragma mark - Initialization

/**
 Returns a newly initialized RCCRemoteBathtubController instance for the specified url. RCCRemoteBathtubController must not be initialized with any other but this method.
 
 @param url The URL to connect to.
 @return Newly initialized (RCCRemoteBathtubController *) instance
 */

- (instancetype)initWithURL:(NSURL *)url;

# pragma mark - Online methods

/**
 Connects to the specified URL.
 @param block Callback block. The block is beeing called with an RCCBathtubData object on success and an NSError object in case of error. One of those values is always nil
 */

- (void)connectWithBlock:(void (^)(RCCBathtubData *data, NSError *error))block;

/**
 Starts the simulation of stats for the virtual bathtub model. Simulated stats are the water temperature and the total amount of flown water (see class RCCBathtubData). The simulation updates the bathtubData property of RCCRemoteBathtubController repeatedly after the specified time interval.
 @param interval Elapsed time interval in seconds before the @property (strong) bathtubData is beeing updated.
 */

- (void)startUpdatingStatsWithTimeInterval:(NSTimeInterval)interval;

/**
 Stops updating the bathtubData property of RCCRemoteBathtubController immediately.
 */

- (void)stopUpdatingStats;

@end