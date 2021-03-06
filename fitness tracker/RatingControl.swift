//
//  RatingControl.swift
//  fitness tracker
//
//  Created by Cara E Comfort on 7/19/17.
//  Copyright © 2017 Cara E Comfort. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    // MARK: Initializatoin
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    // MARK: Private Methods. Private methods can only be called by code within the declaring class
    private func setupButtons() {
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledLotus = UIImage(named: "filledLotus", in: bundle, compatibleWith: self.traitCollection)
        let emptyLotus = UIImage(named:"emptyLotus", in: bundle, compatibleWith: self.traitCollection)
        let highlightedLotus = UIImage(named:"highlightedLotus", in: bundle, compatibleWith: self.traitCollection)
        
        for _ in 0..<starCount {
        let button = UIButton()
            
            // Set the button images
            button.setImage(emptyLotus, for: .normal)
            button.setImage(filledLotus, for: .selected)
            button.setImage(highlightedLotus, for: .highlighted)
            button.setImage(highlightedLotus, for: [.highlighted, .selected])
        
        
        // constraints -> define the button as a fixed-size object in your layout (44 point x 44 point).
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
        // Setup the button action
        button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
        
        // add button to the stack
        addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
        print("Button pressed 👍")
        
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
        }
    }
}
