//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCRemoteBathtubController.h"

// Vendor
// Model
#import "AFNetworking.h"

@interface RCCRemoteBathtubController()

#pragma mark - Properties (private)

@property (strong) NSURL   *url;
@property (weak)   NSTimer *timer;

@end

@implementation RCCRemoteBathtubController (Private)

# pragma mark - Timer (private)

- (void)tick {
	
	if (self.bathtubData.waterTapColdWaterTemp &&
		self.bathtubData.waterTapColdWaterFlowMax &&
		self.bathtubData.waterTapHotWaterTemp &&
		self.bathtubData.waterTapHotWaterFlowMax) {
		
		// Calculate values
		self.bathtubData.totalFlownWater  = [self.bathtubData calculateTotalFlownWater];
		self.bathtubData.totalTemperature = [self.bathtubData calculateTotalTemperature];
	}
}

@end

@implementation RCCRemoteBathtubController

# pragma mark - Initialization

- (instancetype)init {
	
	// It's not allowed to call this method with a nil argument
	ZAssert(NO, @"VIOLATION: RCCRemoteBathtubController instance must only be initialized using this method: - (id)initWithURL:(NSURL *)url");
	
	return nil;
}
- (instancetype)initWithURL:(NSURL *)url {
	
	// It's not allowed to call this method with a nil argument
	ZAssert(url, @"VIOLATION: Method argument (NSURL *)url: %@", url);
	
	self = [super init];
	if (self) {
		
		// Store server URL
		self.url = url;
		
		// Init bathtub data object
		// All information about the apparatus is going to be stored in it
		self.bathtubData = [RCCBathtubData new];
	}
	return self;
}

# pragma mark - Online methods

- (void)connectWithBlock:(void (^)(RCCBathtubData *data, NSError *error))block {
	
	// It's not allowed to call this method with a nil argument
	ZAssert(block, @"VIOLATION: Method argument (void (^)(RCCBathtubData *btData, NSError *error))block: %@", block);
	
	// Setup URLRequest
	NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
		
	// Setup data handling blocks
	__block  RCCBathtubData *bTubData = self.bathtubData;
	AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		
		// Populate object with data
		// Cold water
		// bTubData.waterTapColdWaterFlowMax = @8;
		bTubData.waterTapColdWaterFlowMax = [JSON valueForKeyPath:@"cold_water_flow_max"];
		bTubData.waterTapColdWaterTemp    = [JSON valueForKeyPath:@"cold_water"];

		// Hot water
		// bTubData.waterTapHotWaterFlowMax = @8;
		bTubData.waterTapHotWaterFlowMax = [JSON valueForKeyPath:@"hot_water_flow_max"];
		bTubData.waterTapHotWaterTemp    = [JSON valueForKeyPath:@"hot_water"];
		
		// Max amount of water in tub
		bTubData.bathTubWaterAmountMax = [JSON valueForKeyPath:@"bathtub_water_amount_max"];
		
		// This could be easily enriched with more data in case the server would return it
		// If it would do so this method could as well be called in fixed time intervals
		// in order to sync the state of the real bathtub with the virtual one in the app
		
		// Call block with object
		block(bTubData, nil);

	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		
		// Call block with error
		block(nil, error);
	}];
	
	// Start fetching
	[operation start];
}
- (void)startUpdatingStatsWithTimeInterval:(NSTimeInterval)interval {
	
	// It's not allowed to call this method with a zero argument
	ZAssert(interval, @"VIOLATION: Method argument (NSTimeInterval)interval must be > 0: %f", interval);
	
	// Init timer that updates stats periodically
	self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(tick) userInfo:nil repeats:YES];
	
	// A branch to code that fetches data from the remote server and updates the local simulation could go here
	// The water flow data is stateless. Additional flow objects can be appended to the local simulation
	// (including negative flows and temperatures) in order to match the remote state.
}
- (void)stopUpdatingStats {
	
	// Stop timer
	if ([self.timer isValid]) [self.timer invalidate];
}

@end