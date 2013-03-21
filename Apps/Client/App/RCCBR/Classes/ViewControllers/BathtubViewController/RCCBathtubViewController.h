//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Apple
#import <UIKit/UIKit.h>

// Vendor
// Views
#import "DPMeterView.h"
#import "MHRotaryKnob.h"
#import "MeterView.h"

@interface RCCBathtubViewController : UIViewController

#pragma mark - Properties

// IBOutlets
// Meter
@property (strong) IBOutlet UILabel      *temperatureLabel;
@property (strong) IBOutlet MeterView    *meter;
// Gauge
@property (strong) IBOutlet DPMeterView  *gauge;
// Knobs
@property (strong) IBOutletCollection(MHRotaryKnob) NSArray *knobs;
@property (strong) IBOutlet MHRotaryKnob *coldWaterKnob;
@property (strong) IBOutlet MHRotaryKnob *hotWaterKnob;
@end

@interface RCCBathtubViewController(RotaryKnobActions)
@end