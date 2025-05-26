//
//  ConfirmationSlider.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 26.05.25.
//

import SwiftUI

struct ConfirmationSlider: View {
    // MARK: - Customizable Properties
    var text: String = "Slide to confirm"
    var foregroundColor: Color = .blue
    var backgroundColor: Color = Color(.white)
    var thumbColor: Color = .white
    var action: () -> Void

    // MARK: - Internal State
    @State private var slideOffset: CGSize = .zero
    @State private var sliderWidth: CGFloat = 0
    @State private var isSlidingComplete: Bool = false

    // MARK: - Constants
    private let thumbWidth: CGFloat = 60 // Width of the draggable thumb
    private let horizontalPadding: CGFloat = 10
    private let animationDuration: Double = 0.3

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // MARK: Background Track
                RoundedRectangle(cornerRadius: 30)
                    .fill(backgroundColor)
                    .stroke(Color.accentColor, lineWidth: 1)
                    .frame(height: 60)
                    .onAppear {
                        sliderWidth = geometry.size.width - horizontalPadding * 2 // Adjust for padding on both sides
                    }

                // MARK: Progress Overlay (Optional, for visual feedback)
                RoundedRectangle(cornerRadius: 30)
                    .fill(foregroundColor.opacity(0.3)) // Lighter shade of the foreground color
                    .frame(width: max(thumbWidth, slideOffset.width + thumbWidth), height: 60) // Expands with slide

                // MARK: Draggable Thumb
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(foregroundColor)
                        .frame(width: thumbWidth, height: 60) // Slightly smaller than track for visual pop
                        .overlay(
                            Image(systemName: isSlidingComplete ? "checkmark.circle.fill" : "arrow.right")
                                .font(.title2)
                                .foregroundColor(thumbColor)
                        )
                }
                .offset(x: slideOffset.width)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translation = value.translation.width
                            let newOffset = translation + (isSlidingComplete ? sliderWidth - thumbWidth : 0) // Maintain position if already complete

                            // Clamp the offset to stay within the slider bounds
                            self.slideOffset.width = min(max(0, newOffset), sliderWidth - thumbWidth)

                            // Check for completion
                            if self.slideOffset.width >= sliderWidth - thumbWidth - 5 { // Add a small tolerance
                                if !isSlidingComplete {
                                    withAnimation(.spring()) {
                                        isSlidingComplete = true
                                        self.slideOffset.width = sliderWidth - thumbWidth // Snap to end
                                    }
                                    action() // Trigger the action
                                }
                            } else {
                                // If user drags back, reset completion status
                                if isSlidingComplete {
                                    isSlidingComplete = false
                                }
                            }
                        }
                        .onEnded { value in
                            if !isSlidingComplete {
                                // If not complete, animate back to start
                                withAnimation(.spring(response: animationDuration, dampingFraction: 0.7)) {
                                    self.slideOffset = .zero
                                }
                            } else {
                                // If complete and lifted finger, reset visually after action
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // Give a moment for action to register
                                    withAnimation(.spring(response: animationDuration, dampingFraction: 0.7)) {
                                        self.slideOffset = .zero
                                        self.isSlidingComplete = false
                                    }
                                }
                            }
                        }
                )

                // MARK: Slider Text
//                if !isSlidingComplete {
//                    Text(text)
//                        .foregroundColor(.white)
//                        .font(.headline)
//                        .padding(.leading, thumbWidth + horizontalPadding) // Position after the thumb
//                        .opacity(1.0 - (slideOffset.width / (sliderWidth - thumbWidth))) // Fade out as thumb moves
//                } else {
//                    // Confirmation Text (Optional, when complete)
//                    Text("Confirmed!")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                        .transition(.opacity) // Smooth transition for text
//                        .padding(.leading, horizontalPadding * 2) // Adjust positioning
//                }
            }
            .padding(.horizontal, horizontalPadding)
            .frame(height: 60) // Fixed height for the entire slider
        }
        .frame(height: 60) // Enforce height for GeometryReader parent
    }
}
