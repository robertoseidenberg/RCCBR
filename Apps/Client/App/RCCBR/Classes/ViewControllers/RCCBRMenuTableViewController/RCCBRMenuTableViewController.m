//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "RCCBRMenuTableViewController.h"

// MARK: Vendor
#import "SBGUIViewUtilities.h"

@implementation RCCBRMenuTableViewController(Private)

# pragma mark - Utility (private)

- (void)localizeVC {
	
	// Localize title
	self.title = NSLocalizedString(@"kRCCBRMenuTableViewControllerTitle", nil);
	
	// Localize views
	[self.view localizeSubviews];
	
	// Localize cells
	for (UITableViewCell *cell in self.cells) {[cell localizeSubviews];}
}

@end

@implementation RCCBRMenuTableViewController

# pragma mark - Template methods

- (void)viewDidLoad {	
	[super viewDidLoad];

	// Localize
	[self localizeVC];
}

@end
