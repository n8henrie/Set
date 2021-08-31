//
//  CardShapes.swift
//  Set
//
//  Created by Nathan Henrie on 20210623.
//

import SwiftUI

// shape (diamond, squiggle, oval), shading (solid, striped, or open), and color (red, green, or purple)
struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // VStack, make height depend on width alone
        // to make a constant height irrespective of
        // number of shapes
        let width = rect.size.width * 0.4
        let height = rect.size.width * 0.1
        
        var p = Path()
        p.addLines(
            [
                (0, height),
                (width, 0),
                (0, -height),
                (-width, 0),
            ].map {(xd, yd) -> CGPoint in
                CGPoint(x: center.x + xd, y: center.y + yd)
            }
        )
        p.closeSubpath()
        return p
    }
}

struct Squiggle: Shape {
    func path(in rect: CGRect) -> Path {
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        // VStack, make height depend on width alone
        // to make a constant height irrespective of
        // number of shapes
        let width = rect.size.width * 0.4
        let height = width
        
        func control(op: (CGFloat, CGFloat) -> CGFloat, heightFactor: CGFloat = 1) -> CGPoint {
            
            return CGPoint(
                x: op(center.x, width),
                y: op(center.y, height * heightFactor)
            )
        }
        
        let start = CGPoint(x: center.x - width, y: center.y)
        let end = CGPoint(x: center.x + width, y: center.y)
        
        var p = Path()
        
        p.move(to: start)
        p.addCurve(to: end, control1: control(op: -), control2: control(op: +))
        p.addCurve(to: start, control1: control(op: +, heightFactor: 1.5), control2: control(op: -, heightFactor: 1.5))
        return p
    }
}

struct Oval: Shape {
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        // VStack, make height depend on width alone
        // to make a constant height irrespective of
        // number of shapes
        let width = rect.size.width * 0.4
        let height = rect.size.width * 0.3
        
        var p = Path()
        let box = CGRect(
            origin: CGPoint(
                x: center.x-width,
                y: center.y-(height*0.5)
            ),
            size: CGSize(
                width: width*2,
                height: height
            )
        )
        p.addEllipse(in: box)
        return p
    }
}

struct StripedRect: Shape {
    func path(in rect: CGRect) -> Path {

        // VStack, make height depend on width alone
        // to make a constant height irrespective of
        // number of shapes
        let width = rect.size.width
        let rect_height = CGFloat(10)

        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))

        for y in stride(from: 0, to: rect.size.height, by: rect_height * 2) {
            p.addRect(CGRect(origin: p.currentPoint!, size: CGSize(width: width, height: rect_height)))
            p.move(to: CGPoint(x: 0, y: y))
        }
        let rotated = p.applying(CGAffineTransform(rotationAngle: 45))
        return rotated
    }
}



struct CardShapes_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ForEach (0..<3) { _ in
                StripedRect().fill(Color.black)
            }
        }
    }
}
