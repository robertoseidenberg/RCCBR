//
//  Created by Roberto Seidenberg
//  All rights reserved
//

// Header
#import "SBGUIViewUtilities.h"

@implementation UIView (Utilities)

// Utility
- (NSArray *)allSubViews {

	NSMutableArray *mArray = [[NSMutableArray alloc] init];
	[mArray addObject:self];
	for (UIView *subview in self.subviews) {
		[mArray addObjectsFromArray:(NSArray*)[subview allSubViews]];
	}
	return [NSArray arrayWithArray:mArray];
}

// Localization
- (void)localizeSubviews {
	
	// Walks view hirarchy and replaces keys by values from Localizable.strings file
	for (id aView in [self allSubViews]) {
		
		// Found UILabel
		if ([aView isKindOfClass:[UILabel class]]) {
			if ([[aView text] length]) {
				if ([aView respondsToSelector:@selector(setText:)]) {
					[aView setText:NSLocalizedString([aView text], nil)];
				}
			}
		}
		
		// Found UIButton
		if ([aView isKindOfClass:[UIButton class]]) {
			if ([[aView currentTitle] length]) {
				if ([aView respondsToSelector:@selector(setTitle:forState:)]) {
					[aView setTitle:NSLocalizedString([aView currentTitle], nil) forState:UIControlStateNormal];
				}
			}
		}
	}
}

@end