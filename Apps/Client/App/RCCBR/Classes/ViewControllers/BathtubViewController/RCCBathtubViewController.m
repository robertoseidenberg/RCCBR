//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCBathtubViewController.h"

// Vendor
// Model
#import "NSObject+BlockObservation.h"
#import "NSTimer+Blocks.h"
#import "UIColor+CrossFade.h"
#import "SBGUIViewUtilities.h"
// Views
#import "MBHUDView.h"

// App classes
// Model
#import "RCCRemoteBathtubController.h"

#pragma mark - Constants

// Server URL
static NSString* const kRCCRemoteBathtubControllerURL = @"http://93.180.154.134";

// Colors (cold & hot water)
#define kRCCRemoteBathtubControllerColdWaterColor [UIColor colorWithRed:107.0f/255.0f green:202.0f/255.0f blue:256.0f/255.0f alpha:1.0f]
#define kRCCRemoteBathtubControllerHotWaterColor  [UIColor colorWithRed:252.0f/255.0f green:213.0f/255.0f blue:95.0f /255.0f alpha:1.0f]

#pragma mark - Properties (private)

@interface RCCBathtubViewController()

// Model
// Remote controller
@property (strong) RCCRemoteBathtubController *remoteBathtubController;

@end

@implementation RCCBathtubViewController (Private)

#pragma mark - ViewSetup (private)

- (void)setupMeter {

	// Range
	self.meter.value               = 10.0f;
	self.meter.minNumber           = 10.0f;
	self.meter.maxNumber           = 50.0f;
	self.meter.arcLength           = M_PI;
	
	// Look
	self.meter.needle.width        = 0.5f;
	self.meter.needle.length       = 1.0f;
	self.meter.needle.tintColor    = [UIColor orangeColor];
	self.meter.textLabel.textColor = [UIColor clearColor];
	self.meter.textLabel.text      = @"Temperature";
	self.meter.lineWidth           = 0.5f;

	// Hide initially
	self.meter.alpha               = 0.0f;
}
- (void)setupGauge {
	
	// UIApperance
    [[DPMeterView appearance] setTrackTintColor:[UIColor clearColor]];
    [[DPMeterView appearance] setProgressTintColor:[UIColor darkGrayColor]];
	
	// Effects
	[self.gauge startGravity];
}
- (void)setupKnobs {

	// Common properties
	for (MHRotaryKnob *knob in self.knobs) {
		
		knob.interactionStyle = MHRotaryKnobInteractionStyleRotating;
		knob.scalingFactor    = 1.5f;
		knob.minimumValue     = 0.0f;
		knob.maximumValue     = 1.0f;
		knob.value            = 0.0f;
		knob.defaultValue     = knob.value;
		knob.resetsToDefault  = YES;
		knob.backgroundColor  = [UIColor clearColor];
		knob.knobImageCenter  = CGPointMake(49.0f, 49.0f);
		[knob addTarget:self action:@selector(rotaryKnobDidChange:) forControlEvents:UIControlEventTouchUpInside];
	}

	// Images
	// Cold water knob
	[self.coldWaterKnob setKnobImage:[UIImage imageNamed:@"BathtubVCKnobCold.png"] forState:UIControlStateNormal];
	// Hot water knob
	[self.hotWaterKnob setKnobImage:[UIImage imageNamed:@"BathtubVCKnobHot.png"] forState:UIControlStateNormal];
}

@end

@implementation RCCBathtubViewController

#pragma mark - Template methods

- (void)viewDidLoad {
	[super viewDidLoad];

	// Localize title
	self.title = NSLocalizedString(@"kRCCBRMenuTableViewControllerTableCellTitleBathtub", nil);
	
	// Localize views
	[self.view localizeSubviews];
	
	// Setup custom views
	[self setupMeter];
	[self setupGauge];
	[self setupKnobs];
}
- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];

	// Init remote bathtub controller
	__weak RCCBathtubViewController *bself = self;
	self.remoteBathtubController = [[RCCRemoteBathtubController alloc] initWithURL:[NSURL URLWithString:kRCCRemoteBathtubControllerURL]];
	[self.remoteBathtubController connectWithBlock:^(RCCBathtubData *data, NSError *error){
		
		// Inform user on error
		if (error) {
		    MBAlertView *alert = [MBAlertView alertWithBody:NSLocalizedString(@"kRCCBathtubViewControllerConnectionErrorAlertMessage", nil) cancelTitle:nil cancelBlock:nil];
			[alert addButtonWithText:NSLocalizedString(@"kRCCBathtubViewControllerConnectionErrorAlertButtonTitle", nil) type:MBAlertViewItemTypePositive block:^{
				[self.navigationController popViewControllerAnimated:YES];
			}];
			[alert addToDisplayQueue];
			
		// Setup views
		} else {
			
			// Observe stats
			// Total flown water
			__block DPMeterView *bGauge = bself.gauge;
			[data addObserverForKeyPath:@"totalFlownWater" onQueue:nil task:^(id obj, NSDictionary *change) {
				
				// Convert flown water to float
				RCCBathtubData *btData = obj;
				CGFloat flownWater     = [btData.totalFlownWater floatValue];
				
				// Update level
				if  (flownWater > 0) bGauge.progress = (flownWater / [btData.bathTubWaterAmountMax floatValue]);
				
				// Stop if the tub if full
				if (flownWater >= [btData.bathTubWaterAmountMax floatValue]) {
					
					// Stop updating tub stats
					[bself.remoteBathtubController stopUpdatingStats];
					
					// Inform user and pop back
					MBAlertView *alert = [MBAlertView alertWithBody:NSLocalizedString(@"kRCCBathtubViewControllerFinishedAlertMessage", nil) cancelTitle:nil cancelBlock:nil];
					[alert addButtonWithText:NSLocalizedString(@"kRCCBathtubViewControllerFinishedAlertButtonTitle", nil) type:MBAlertViewItemTypePositive block:^{
						[self.navigationController popViewControllerAnimated:YES];
					}];
					[alert addToDisplayQueue];
				}
			}];
			
			// Total temperature
			[data addObserverForKeyPath:@"totalTemperature" onQueue:nil task:^(id obj, NSDictionary *change) {
				
				// Convert temperature to float
				RCCBathtubData *btData   = obj;
				CGFloat temperature = [btData.totalTemperature floatValue];
				
				// Update temperature meter
				// Set current values
				bself.temperatureLabel.text = (temperature > 0) ? [NSString stringWithFormat:@"%.0f", temperature] : @"";
				bself.meter.value           = temperature;
				// Show meter
				if (bself.meter.alpha <= 0.0f) [UIView animateWithDuration:1.0f animations:^(void) {bself.meter.alpha = 1.0f;}];
				
				// Tint color
				CGFloat ratio = (temperature / [bself.remoteBathtubController.bathtubData.waterTapHotWaterTemp floatValue]);
				bself.gauge.progressTintColor = [UIColor colorForFadeBetweenFirstColor:kRCCRemoteBathtubControllerColdWaterColor secondColor:kRCCRemoteBathtubControllerHotWaterColor atRatio:ratio];
			}];
			
			// Kick off stats updates
			[bself.remoteBathtubController startUpdatingStatsWithTimeInterval:0.5];
			
			// Show knobs
			[UIView animateWithDuration:1.0f animations:^(void) {
				
				bself.coldWaterKnob.alpha = 1.0f;
				bself.hotWaterKnob.alpha  = 1.0f;
				
				bself.coldWaterKnob.hidden = NO;
				bself.hotWaterKnob.hidden  = NO;
			}];
		}
	}];
}
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	// Stop updating tub stats
	[self.remoteBathtubController stopUpdatingStats];
}

@end

@implementation RCCBathtubViewController(RotaryKnobActions)


#pragma mark - Rotary knob actions

- (void)rotaryKnobDidChange:(id)sender {
	
	// Typecast
	MHRotaryKnob *knob = sender;
	
	// Turn off knob if value is very low
	CGFloat value = 0.0f;
	if (knob.value >= 0.1) {
		value = knob.value;
	} else {
		[knob setValue:0.0f animated:YES];
	}
	
	// Forward flow to controller
	if (knob == self.coldWaterKnob) {
		[self.remoteBathtubController.bathtubData setColdWaterFlow:[NSNumber numberWithFloat:value]];
	} else {
		[self.remoteBathtubController.bathtubData setHotWaterFlow:[NSNumber numberWithFloat:value]];
	}
}

@end