//
//  CustomPathView.swift
//  AwardsCollectionApp
//
//  Created by Андрей Парчуков on 26.09.2022.
//

import SwiftUI

struct PlanetView: View {
    
    private let backgroundColor: Color = Color(red: 36/255, green: 39/255, blue: 54/255)
    private let leftColor: Color = Color(red: 153/255, green: 212/255, blue: 249/255)
    private let rightColor: Color = Color(red: 223/255, green: 111/255, blue: 246/255)
    
    var body: some View {
        LinearGradient(
            colors: [leftColor, rightColor],
            startPoint: UnitPoint(x: 0.35, y: 0.15),
            endPoint: UnitPoint(x: 0.9, y: 0.9)
        )
        .mask {
            PlanetPath()
        }
        .background(RoundedRectangle(cornerRadius: 30).fill(backgroundColor))
        .padding(10)
    } // body
    
}

struct PlanetPath: View {
    
    @State private var animating = false
    
    var body: some View {
        GeometryReader { geometry in
            
            let width: CGFloat = geometry.size.width
            let height: CGFloat = geometry.size.height
            let size: CGFloat = min(width, height)
            let middle: CGFloat = size / 2
            
            let firstRadius: Double = middle * 0.27
            let secondRadius: Double = middle * 0.6
            let thirdRadius: Double = middle * 0.87
            
            let satelliteRadius: Double = thirdRadius - secondRadius
            
            let firstOrbitStartAngle: Double = 225.0 + satelliteRadius * 180.0 / Double.pi / secondRadius
            let firstOrbitEndAngle: Double = 225.0 - satelliteRadius * 180.0 / Double.pi / secondRadius
            
            let secondOrbitStartAngle: Double = 45.0 - satelliteRadius * 180.0 / Double.pi / thirdRadius
            let secondOrbitEndAngle: Double = 45.0 + satelliteRadius * 180.0 / Double.pi / thirdRadius
            
            let firstPlanetX: Double = middle + secondRadius * cos(135.0 * Double.pi / 180.0)
            let firstPlanetY: Double = middle - secondRadius * sin(135.0 * Double.pi / 180.0)
            
            let secondPlanetX: Double = middle + thirdRadius * cos(315.0 * Double.pi / 180.0)
            let secondPlanetY: Double = middle - thirdRadius * sin(315.0 * Double.pi / 180.0)
            
            // MARK: - Sun Rays
            Circle()
                .stroke(
                    style: StrokeStyle(
                        lineWidth: animating ? 12 : 0,
                        lineCap: .butt,
                        dash: [5, 2 * Double.pi * firstRadius / 9 - 5],
                        dashPhase: 0
                    )
                )
                .frame(width: firstRadius * 2 + 6, height: firstRadius * 2 + 6)
                .position(x: middle, y: middle)
                .animation(.linear.delay(1.1), value: animating)
            
            // MARK: - First Planet
            Circle()
                .stroke(lineWidth: 6)
                .frame(width: satelliteRadius, height: satelliteRadius)
                .scaleEffect(animating ? 1.0 : 0.0)
                .position(x: firstPlanetX, y: firstPlanetY)
                .animation(
                    .spring(
                        response: 0.55,
                        dampingFraction: 0.5,
                        blendDuration: 0
                    )
                    .delay(0.7),
                    value: animating
                )
            
            // MARK: - Second Planet
            Circle()
                .stroke(lineWidth: 6)
                .frame(width: satelliteRadius, height: satelliteRadius)
                .scaleEffect(animating ? 1.0 : 0.0)
                .position(x: secondPlanetX, y: secondPlanetY)
                .animation(
                    .spring(
                        response: 0.55,
                        dampingFraction: 0.5,
                        blendDuration: 0
                    )
                    .delay(0.7),
                    value: animating
                )
            
            // MARK: - Sun
            Path { path in
                path.addArc(center: CGPoint(x: middle, y: middle), radius: firstRadius, startAngle: .degrees(0), endAngle: .degrees(360), clockwise: true)
            }
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: CGLineCap.round))
            
            // MARK: - First Orbit
            Path { path in
                path.addArc(
                    center: CGPoint(x: middle, y: middle),
                    radius: secondRadius,
                    startAngle: .degrees(firstOrbitStartAngle),
                    endAngle: .degrees(firstOrbitEndAngle),
                    clockwise: false
                )
            }
            .trim(from: 0, to: animating ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: CGLineCap.round))
            
            // MARK: - Second Orbit
            Path { path in
                path.addArc(
                    center: CGPoint(x: middle, y: middle),
                    radius: thirdRadius,
                    startAngle: .degrees(secondOrbitStartAngle),
                    endAngle: .degrees(secondOrbitEndAngle),
                    clockwise: true
                )
            }
            .trim(from: 0, to: animating ? 1 : 0)
            .stroke(style: StrokeStyle(lineWidth: 6, lineCap: CGLineCap.round))
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.7).delay(0.15)) {
                animating = true
            }
        }
    } // body
}

struct CustomPathView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetView()
            .frame(width: 200, height: 200)
    }
}
