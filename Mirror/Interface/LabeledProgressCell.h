//
//  LabeledProgressCell.h
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "WindowAdaptedCell.h"

/**
 * A `ProjectLabeledProgressCell` represents a cell for displaying a progress bar and a label covering that bar.
 */
@interface LabeledProgressCell : WindowAdaptedTextFieldCell {
    
@public
    float progress;
    
}

@end
