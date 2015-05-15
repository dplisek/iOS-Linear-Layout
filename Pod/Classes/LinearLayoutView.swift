//
//  LinearLayoutView.swift
//  LinearLayoutTesting
//
//  Created by Dominik Plisek on 11/03/15.
//  Copyright (c) 2015 Dominik Plisek. All rights reserved.
//

import UIKit

/**

An abstract superclass of linear layouts. Do not instantiate.

You can define layouts of this type so that you can add and remove members
to them not caring if they are horizontal or vertical. 

But you have to instantiate either the HorizontalLinearLayoutView 
or the VerticalLinearLayoutView.

*/
public class LinearLayoutView: UIView {
    
    /**
    
    Defines the width of the border around the entire layout
    
    */
    public var margin: CGFloat = 0.0 {
        didSet {
            if spacingConstraints.count > 0 {
                if let constraint = spacingConstraints[0] as? NSLayoutConstraint {
                    constraint.constant = margin
                }
            }
            for hConstraint in sideConstraints {
                if let hConstraint = hConstraint as? NSLayoutConstraint {
                    hConstraint.constant = margin
                }
            }
        }
    }
    
    /**
    
    Defines the spacing in between individual members of the layout
    
    */
    public var spacing: CGFloat = 0.0 {
        didSet {
            for constraint in spacingConstraints {
                if spacingConstraints.indexOfObject(constraint) > 0 {
                    if let constraint = constraint as? NSLayoutConstraint {
                        constraint.constant = spacing
                    }
                }
            }
        }
    }

    let members = NSMutableArray()
    let spacingConstraints = NSMutableArray()
    let sideConstraints = NSMutableArray()
    let memberSizes = NSMutableArray()
    
    /**
    
    Initialize the linear layout with zero margin and spacing.

    */
    public convenience init() {
        self.init(margin: 0, spacing: 0)
    }
    
    /**
    
    Initialize the linear layout with the specified margin and spacing.
    
    :param: margin The width of the border around the entire layout
    :param: spacing The spacing in between individual members of the layout
    
    */
    public init(margin: CGFloat, spacing: CGFloat) {
        super.init(frame: CGRectZero)
        self.margin = margin
        self.spacing = spacing
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
    
    Add a view at the end of the layout.

    :param: member The view to add. Any constraints held by the view will be removed.
    
    */
    public func addMember(member: UIView) {
        addMember(member, position: members.count)
    }
    
    /**
    
    Add a view at a specific position in the layout.

    Existing members of the layout will be adjusted to fit the new member.
    Adding to a position beyong the current end position will cause 
    the member to be added to the end position.
    
    :param: member The view to add. Any constraints held by the view will be removed.
    :param: position The zero-based position in the layout at which the member will reside
    
    */
    public func addMember(member: UIView, position: Int) {
        let adjustedPosition = position > members.count ? members.count : position;
        member.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(member)
        if adjustedPosition < members.count {
            if let constraint = spacingConstraints[adjustedPosition] as? NSLayoutConstraint {
                removeConstraint(constraint)
            }
            spacingConstraints.removeObjectAtIndex(adjustedPosition)
        }
        addConstraints(installSideConstraintsForMember(member, position: adjustedPosition))
        addConstraints(installSpacingConstraintsForMember(member, position: adjustedPosition))
        members.insertObject(member, atIndex: adjustedPosition)
        memberSizes.insertObject(NSLayoutConstraint(), atIndex: adjustedPosition)
    }
    
    /**
    
    Remove the specified member from the layout.
    
    Other members of the layout will be shifted to the empty space.
    
    :param: member The member to remove. If it isn't present, nothing happens.
    
    */
    public func removeMember(member: UIView) {
        removeMemberAtPosition(members.indexOfObject(member))
    }
    
    /**

    Remove the member residing at the specified index in the layout.
    
    If there is nothing at the specified position, nothing happens.
    
    :param: position The zero-based position in the layout at which the member to be removed is found
    
    */
    public func removeMemberAtPosition(position: Int) {
        if position == NSNotFound || position > members.count - 1 { return }
        if let constraints = sideConstraints[position] as? [NSLayoutConstraint] {
            removeConstraints(constraints)
        }
        sideConstraints.removeObjectAtIndex(position)
        if let constraint = spacingConstraints[position] as? NSLayoutConstraint {
            removeConstraint(constraint)
        }
        spacingConstraints.removeObjectAtIndex(position)
        if position < members.count - 1 {
            if let constraint = spacingConstraints[position] as? NSLayoutConstraint {
                removeConstraint(constraint)
            }
            spacingConstraints.removeObjectAtIndex(position)
        }
        members[position].removeFromSuperview()
        members.removeObjectAtIndex(position)
        memberSizes.removeObjectAtIndex(position)
        if position < members.count {
            if let member = members[position] as? UIView {
                addConstraint(installSpacingBeforeConstraintForMember(member, position: position))
            }
        }
    }
    
    /**
    
    Sets the size of an already added member at the specified position.
    
    The method only sets the height on a vertical layout or the width on a horizontal layout. 
    The size can be relative to the size of the layout or it can be an absolute value.
    
    :param: position The zero-based position in the layout at which the member to be sized is found
    :param: relativeToLayout Whether the specified size is absolute or relative to the layout
    :param: size The width in a horizontal layout or the height in a vertical layout
    
    */
    public func setSizeOfMemberAtPosition(position: Int, relativeToLayout: Bool, size: Float) {
        if position == NSNotFound || position > members.count - 1 { return }
        if let member = members[position] as? UIView {
            if let constraint = memberSizes[position] as? NSLayoutConstraint {
                member.removeConstraint(constraint)
                removeConstraint(constraint)
            }
            let constraint = sizeConstraintForMember(member, relativeToLayout: relativeToLayout, size: size)
            if relativeToLayout {
                addConstraint(constraint)
            } else {
                member.addConstraint(constraint)
            }
            memberSizes[position] = constraint
        }
    }
    
    func installSideConstraintsForMember(member: UIView, position: Int) -> [AnyObject] {
        let constraints = sideConstraintsForMember(member)
        sideConstraints.insertObject(constraints, atIndex: position)
        return constraints
    }
    
    func installSpacingConstraintsForMember(member: UIView, position: Int) -> [AnyObject] {
        var constraints = [installSpacingBeforeConstraintForMember(member, position: position)]
        if (position < members.count) {
            constraints.append(installSpacingAfterConstraintForMember(member, position: position))
        }
        return constraints
    }
    
    func installSpacingBeforeConstraintForMember(member: UIView, position: Int) -> NSLayoutConstraint {
        var constraint: NSLayoutConstraint
        switch position {
        case 0:
            constraint = spacingToContainerConstraintForMember(member)
        default:
            constraint = spacingToPreviousConstraintForMember(member, position: position)
        }
        spacingConstraints.insertObject(constraint, atIndex: position)
        return constraint
    }
    
    func installSpacingAfterConstraintForMember(member: UIView, position: Int) -> NSLayoutConstraint {
        let constraint = spacingToNextConstraintForMember(member, position: position)
        spacingConstraints.insertObject(constraint, atIndex: position + 1)
        return constraint
    }
    
    func sideConstraintsForMember(member: UIView) -> [AnyObject] {
        assertionFailure("Abstract method called.")
        return []
    }
    
    func spacingToContainerConstraintForMember(member: UIView) -> NSLayoutConstraint {
        assertionFailure("Abstract method called.")
        return NSLayoutConstraint()
    }
    
    func spacingToPreviousConstraintForMember(member: UIView, position: Int) -> NSLayoutConstraint {
        assertionFailure("Abstract method called.")
        return NSLayoutConstraint()
    }
    
    func spacingToNextConstraintForMember(member: UIView, position: Int) -> NSLayoutConstraint {
        assertionFailure("Abstract method called.")
        return NSLayoutConstraint()
    }
    
    func sizeConstraintForMember(member: UIView, relativeToLayout: Bool, size: Float) -> NSLayoutConstraint {
        assertionFailure("Abstract method called.")
        return NSLayoutConstraint()
    }
}

public extension UIView {
    
    /**
    
    If the view is a member of a linear layout, remove it.
    
    If the view is not a member of a linear layout, nothing happens, 
    it is not removed from its superview.
    
    */
    public func removeFromLinearLayout() {
        if let linearLayout = superview as? LinearLayoutView {
            linearLayout.removeMember(self)
        }
    }
    
}
