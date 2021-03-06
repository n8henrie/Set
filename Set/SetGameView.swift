//
//  ContentView.swift
//  Set
//
//  Created by Nathan Henrie on 20210617.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SetGame

    var body: some View {
        GeometryReader {geometry in
            let visible_cards = viewModel.cards.filter { card in
                card.visible
            }

            NavigationView {
                Grid(visible_cards) { card in
                    CardView(card: card, geometry: geometry)
                        .onTapGesture {
                            viewModel.choose(card: card)
                        }.animation(.easeIn.delay(delayForCard(card)))
                }
            }
        }
    }
    private func delayForCard(_ card: GameModel.Card) -> Double {
        if let idx = viewModel.cards.firstIndex(matching: card) {
            return Double(idx) * 0.1
        }
        return 0
    }
}


struct CardView: View {
    let card: GameModel.Card
    let geometry: GeometryProxy

    @State var should_offset = true

    var body: some View {
        ZStack {
            if card.selected {
                RoundedRectangle(cornerRadius: card_corner_radius).fill(card_background_color).opacity(foreground_opacity).padding(5)
                RoundedRectangle(cornerRadius: card_corner_radius).fill(Color.white).padding(10)
            }
            RoundedRectangle(cornerRadius: card_corner_radius).fill(card_background_color).opacity(background_opacity).padding(5)
            VStack(spacing: 1) {
                ForEach (0..<card.num_shapes) { _ in
                    get_shape()
                }
            }.padding(15)
        }.padding(5)
        .offset(
            x: should_offset ? randomOffset(more_than: geometry.size.width) : 0,
            y: should_offset ? randomOffset(more_than: geometry.size.height) : 0)
        .animation(.spring())
        .onAppear {
            should_offset = false
        }
    }

    private func randomOffset(more_than: CGFloat) -> CGFloat {
        print(more_than)
        let minimum = Int(more_than) + 1
        let base = Int.random(in: minimum..<2*minimum)
        let multiplier = [-1, 1].randomElement()!;
        return CGFloat(base * multiplier)
    }

    
    @ViewBuilder
    private func get_shape() -> some View {
        switch card.shape {
        case .diamond(let s):
            shade(s)
        case .squiggle(let s):
            shade(s)
        case .oval(let s):
            shade(s)
        }
    }
    
    @ViewBuilder
    private func shade<T>(_ shape: T) -> some View
    where T: Shape {
        let color = get_color()
        switch card.shading {
        case .open: shape.stroke(lineWidth: 1).fill(color)
        case .solid: shape.fill(color)
        case .striped: StripedShape(shape: shape, color: color, background: card_background_color)
        }
    }
    
    func get_color() -> Color {
        switch card.color {
        case .red:
            return .red
        case .purple:
            return .purple
        case .green:
            return .green
        }
    }

    //        @ViewBuilder
    //        private func fill() -> some View {
    //            switch card.shading {
    //            case .solid: card
    //            case .striped: card
    //            case .open: card
    //            }
    //        }
}


private func fontSize(for size: CGSize) -> CGFloat {
    0.65 * min(size.width, size.height)
}


struct StripedShape<T>: View where T: Shape {
    let shape: T
    let color: Color
    let background: Color
    
    var body: some View {
        GeometryReader { rect in
            let width = rect.size.width
            let height = rect.size.height
            HStack(spacing: 0) {
                ForEach(0..<30) { number in
                    color.opacity(0)
                    color.frame(width: 2)
                }
            }
            // expand size due to account for rotation
            .frame(width: width * 2, height: height * 2)
            .rotationEffect(Angle.degrees(45))
            
            // restore initial size
            .frame(width: width, height: height)
            .clipShape(shape)
            .overlay(shape.stroke(color, lineWidth: 2))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game =  SetGame()
        //        game.choose(card: game.cards[0])
        return ContentView(viewModel: game)
    }
}

let card_background_color = Color.blue
let background_opacity = 0.2
let foreground_opacity = 0.8
let card_corner_radius = CGFloat(5)
