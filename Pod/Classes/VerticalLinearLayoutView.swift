//
//  VerticalLinearLayoutView.swift
//  LinearLayoutTesting
//
//  Created by Dominik Plíšek on 15/05/15.
//  Copyright (c) 2015 Dominik Plisek. All rights reserved.
//

import UIKit

/**

An implementation that lays members out vertically across its available space.

Use as a regular UIView. Add members using the addMember methods,
remove members using the removeMember method. Members can also be removed
from their parent LinearLayoutView by calling removeFromLinearLayout on them.

The members are regular subviews of the layout and can be treated as such.

*/
public class VerticalLinearLayoutView: LinearLayoutView {

    override func sideConstraintsForMember(member: UIView) -> [AnyObject] {
        return NSLayoutConstraint.constraintsWithVisualFormat(
            "|-\(margin)-[member]-\(margin)-|",
            options: nil,
            metrics: nil,
            views: ["member": member]
        )
    }
    
    override func spacingToContainerConstraintForMember(member: UIView) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: member,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: margin
        )
    }
    
    override func spacingToPreviousConstraintForMember(member: UIView, position: Int) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: member,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: members[position - 1],
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: spacing
        )
    }
    
    override func spacingToNextConstraintForMember(member: UIView, position: Int) -> NSLayoutConstraint {
        return NSLayoutConstraint(
            item: members[position],
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: member,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: spacing
        )
    }
    
    override func sizeConstraintForMember(member: UIView, relativeToLayout: Bool, size: Float) -> NSLayoutConstraint {
        if relativeToLayout {
            return NSLayoutConstraint(
                item: member,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Height,
                multiplier: CGFloat(size),
                constant: 0)
        } else {
            return NSLayoutConstraint(
                item: member,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.Height,
                multiplier: 1.0,
                constant: CGFloat(size))
        }
    }
    
}
