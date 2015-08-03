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
    
    Defines the point size of the space at the start of the layout
    
    */
    public var leadingMargin: CGFloat = 0 {
        didSet {
            if let constraint = spacingConstraints.first {
                constraint.constant = leadingMargin
            }
        }
    }
    
    /**
    
    Defines the point size of the border along the leading side of the layout
    
    */
    public var leadingSideMargin: CGFloat = 0 {
        didSet {
            for hConstraint in leadingSideConstraints {
                hConstraint.constant = leadingSideMargin
            }
        }
    }
    
    /**
    
    Defines the point size of the border along the trailing side of the layout
    
    */
    public var trailingSideMargin: CGFloat = 0 {
        didSet {
            for hConstraint in trailingSideConstraints {
                hConstraint.constant = trailingSideMargin
            }
        }
    }

    /**
    
    Defines the spacing in between individual members of the layout
    
    */
    public var spacing: CGFloat = 0.0 {
        didSet {
            for var i = 1; i < spacingConstraints.count; i++ {
                spacingConstraints[i].constant = spacing
            }
        }
    }
    
    /**

    The number of members currently added to the layout

    */
    public var memberCount: Int {
        get {
            return members.count
        }
    }
    
    var members: [UIView] = []
    var spacingConstraints: [NSLayoutConstraint] = []
    var leadingSideConstraints: [NSLayoutConstraint] = []
    var trailingSideConstraints: [NSLayoutConstraint] = []
    var memberSizes: [NSLayoutConstraint] = []
    
    /**
    
    Initialize the linear layout with zero margin and spacing.

    */
    public convenience init() {
        self.init(leadingMargin: 0, leadingSideMargin: 0, trailingSideMargin: 0, spacing: 0)
    }
    
    /**
    
    Initialize the linear layout with the specified margin and spacing.
    
    :param: leadingMargin The point size of the space at the start of the layout
    :param: sideMargins The point size of the borders along the sides of the layout
    :param: spacing The spacing in between individual members of the layout
    
    */
    public init(leadingMargin: CGFloat, leadingSideMargin: CGFloat, trailingSideMargin: CGFloat, spacing: CGFloat) {
        super.init(frame: CGRectZero)
        self.leadingMargin = leadingMargin
        self.leadingSideMargin = leadingSideMargin
        self.trailingSideMargin = trailingSideMargin
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
            removeConstraint(spacingConstraints[adjustedPosition])
            spacingConstraints.removeAtIndex(adjustedPosition)
        }
        addConstraints(installSideConstraintsForMember(member, position: adjustedPosition))
        addConstraints(installSpacingConstraintsForMember(member, position: adjustedPosition))
        members.insert(member, atIndex: adjustedPosition)
        memberSizes.insert(NSLayoutConstraint(), atIndex: adjustedPosition)
    }
    
    /**
    
    Remove the specified member from the layout.
    
    Other members of the layout will be shifted to the empty space.
    
    :param: member The member to remove. If it isn't present, nothing happens.
    
    */
    public func removeMember(member: UIView) {
        for var i = 0; i < members.count; i++ {
            if members[i] == member {
                removeMemberAtPosition(i)
                return
            }
        }
    }
    
    /**

    Remove the member residing at the specified index in the layout.
    
    If there is nothing at the specified position, nothing happens.
    
    :param: position The zero-based position in the layout at which the member to be removed is found
    
    */
    public func removeMemberAtPosition(position: Int) {
        if position == NSNotFound || position > members.count - 1 { return }
        removeConstraint(leadingSideConstraints[position])
        leadingSideConstraints.removeAtIndex(position)
        removeConstraint(trailingSideConstraints[position])
        trailingSideConstraints.removeAtIndex(position)
        removeConstraint(spacingConstraints[position])
        spacingConstraints.removeAtIndex(position)
        if position < members.count - 1 {
            removeConstraint(spacingConstraints[position])
            spacingConstraints.removeAtIndex(position)
        }
        members[position].removeFromSuperview()
        members.removeAtIndex(position)
        memberSizes.removeAtIndex(position)
        if position < members.count {
            addConstraint(installSpacingBeforeConstraintForMember(members[position], position: position))
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
        let member = members[position]
        member.removeConstraint(memberSizes[position])
        removeConstraint(memberSizes[position])
        let constraint = sizeConstraintForMember(member, relativeToLayout: relativeToLayout, size: size)
        if relativeToLayout {
            addConstraint(constraint)
        } else {
            member.addConstraint(constraint)
        }
        memberSizes[position] = constraint
    }
    
    func installSideConstraintsForMember(member: UIView, position: Int) -> [AnyObject] {
        let leading = leadingSideConstraintForMember(member)
        let trailing = trailingSideConstraintForMember(member)
        leadingSideConstraints.insert(leading, atIndex: position)
        trailingSideConstraints.insert(trailing, atIndex: position)
        return [leading, trailing]
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
        spacingConstraints.insert(constraint, atIndex: position)
        return constraint
    }
    
    func installSpacingAfterConstraintForMember(member: UIView, position: Int) -> NSLayoutConstraint {
        let constraint = spacingToNextConstraintForMember(member, position: position)
        spacingConstraints.insert(constraint, atIndex: position + 1)
        return constraint
    }
    
    func leadingSideConstraintForMember(member: UIView) -> NSLayoutConstraint {
        assertionFailure("Abstract method called.")
        return NSLayoutConstraint()
    }
    
    func trailingSideConstraintForMember(member: UIView) -> NSLayoutConstraint {
        assertionFailure("Abstract method called.")
        return NSLayoutConstraint()
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
