import UIKit // button/sliders...

class ViewController: UIViewController
{
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards:Int{
        get{
            return (cardButtons.count+1)/2
        }
    }
    
    private(set) var flipCount = 0{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel(){
        let attributes: [NSAttributedString.Key:Any] = [
            .strokeColor:#colorLiteral(red: 1, green: 0.6589637607, blue: 0.2246833519, alpha: 1),
            .strokeWidth:5.0
        ]
        let attributedString = NSAttributedString(string: "Flips = \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
     

    @IBOutlet private weak var flipCountLabel: UILabel!{
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    

    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of:sender){
            game.chooseCard(at:cardNumber) /* 이 버튼이 선택되었다 */
            updateViewFromModel()
            /* 버튼이 선택되는 것 (Model)에 의해, View가 바뀌어야 하는데
            그렇다고 Model에서 View로 바로 얘기할 순 없는것이므로
            Controller측에서 updateViewFromModel 같은 함수로
            View를 업데이트해주겠다는 상황*/
        }
        else{
            print("Chosen Card is not in cardButttons")
        }
        
    }

    private func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
            else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.6589637607, blue: 0.2246833519, alpha: 0):#colorLiteral(red: 1, green: 0.6589637607, blue: 0.2246833519, alpha: 1)
            }
        }
    }
    
    //private var emojiChoices = ["😍","👻","🎃","🍡","🍭","🍬","🍫","🍩","🦇"]
    private var emojiChoices = "😍👻🎃🍡🍭🍬🍫🍩🦇"
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card)->String {
        if emoji[card]==nil, emojiChoices.count > 0{
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.giveMeRandom)
            emoji[card] = String(emojiChoices.remove(at:randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
}

extension Int{
    var giveMeRandom:Int{
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
