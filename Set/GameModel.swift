//
//  SetGameModel.swift
//  Set
//
//  Created by Nathan Henrie on 20210617.
//

//import Foundation

struct GameModel {
    private(set) var cards: Array<Card>
    
    init() {
        var cards = [Card]()
        var counter = 0
        for shape: CardShape in [.diamond(Diamond()), .squiggle(Squiggle()), .oval(Oval())] {
            for shading: Shading in [.solid, .striped, .open] {
                for color: ShapeColor in [.red, .green, .purple] {
                    for num_shapes in 1...3 {
                        let card = Card(
                            num_shapes: num_shapes, shape: shape, shading: shading, color: color,
                            id: counter
                        )
                        cards.append(card)
                        counter+=1
                    }
                }
            }
        }
        
        cards.shuffle()
        self.cards = cards
    }
    
    mutating func choose(card: Card) {
        if let idx = cards.firstIndex(matching: card) {
            let selected_count = cards.filter({ $0.selected }).count
            switch selected_count {
            case 0...2:
                cards[idx].selected = !cards[idx].selected
                fallthrough
            case 2:
                if is_match() {
                    print("celebrate!")
                }
            default:
                if cards[idx].selected {
                    cards[idx].selected = false
                }
            }
        }
    }
    
    mutating func createSetGame() {
        for idx in 0..<12 {
            cards[idx].visible = true
        }
    }
    
    func is_match() -> Bool {
        let selected_cards = cards.filter({ $0.selected })
        guard selected_cards.count == 3 else {
            return false
        }
        print("matched!")
        return true
    }
    
    struct Card: Identifiable {
        let num_shapes: Int
        let shape: CardShape
        let shading: Shading
        let color: ShapeColor
        let id: Int
        var visible = false
        var selected = false
    }
}


enum ShapeColor {
    case red, green, purple
}

enum Shading {
    case solid
    case striped
    case open
}

enum CardShape {
    case diamond(Diamond)
    case squiggle(Squiggle)
    case oval(Oval)
}
