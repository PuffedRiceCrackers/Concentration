//
//  Concentration.swift
//  lastConcentration
//
//  Created by PuffedRiceCracker on 3/23/19.
//  Copyright © 2019 PuffedRiceCracker. All rights reserved.
//

import Foundation

struct Concentration
{
    /* 이걸 private해서 읽지도 못하게 하면 viewController에서 card를 display도 못할 것.
    다만 isMatched, isFaceUp등은 Concentration 의 역할이기 때문에 private(set)이 적절 */
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard:Int?{
        get{
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    /* public 하게 놔두어야 viewController에서 이 카드가 chooseCard되었음을 model에게 보낼 수가 있음 */
    mutating func chooseCard(at index:Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index):chosen index not in the card")
        if !cards[index].isMatched{
            /* 어떤 카드가 faceUp 되어있는 경우에 하나 고른 경우 */
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }
            /* 모두가 faceDown 인 상태에서 하나 고른 경우 */
            else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    /* public 하게 놔두어야 game을 만들 수 있음 */
    init(numberOfPairsOfCards:Int)
    {
        assert(numberOfPairsOfCards>0, "Concentration.init : \(numberOfPairsOfCards) is passed")
        for _ in 0..<numberOfPairsOfCards{
            let card = Card()
            cards += [card, card]
        }
    }
    
}

extension Collection{
    var oneAndOnly:Element?{
        return count == 1 ? first : nil
    }
}
