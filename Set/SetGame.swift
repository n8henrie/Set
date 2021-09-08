//
//  SetGame.swift
//  Set
//
//  Created by Nathan Henrie on 20210617.

import SwiftUI



class SetGame: ObservableObject {
    @Published private var model = GameModel()
    
    func createSetGame() {
        self.model = GameModel()
    }
    
    var cards: Array<GameModel.Card>  {
        model.cards
    }
    
    func choose(card: GameModel.Card) {
        model.choose(card: card)
    }
}
