import SpriteKit

class GameScene: SKScene {
    
    //var wallpaper=SKSpriteNode()
    var mountain1 = SKSpriteNode()
    var mountain2 = SKSpriteNode()
    var character = SKSpriteNode()
    var sky = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        mountain1=childNode(withName: "mountain1") as! SKSpriteNode
        mountain2=childNode(withName: "mountain2") as! SKSpriteNode
        character=childNode(withName: "character") as! SKSpriteNode
        sky=childNode(withName: "sky1") as! SKSpriteNode
        
        // Creare l'animazione del personaggio che cammina
        var walkFrames: [SKTexture] = []
        for i in 1...6 { // Supponendo che ci siano 4 frame di cammino
            walkFrames.append(SKTexture(imageNamed: "figure_\(i)"))
        }
        
        let walkAnimation = SKAction.animate(with: walkFrames, timePerFrame: 0.2)
        let repeatWalk = SKAction.repeatForever(walkAnimation)
        character.run(repeatWalk)
        
        // Calcolare il movimento diagonale
        let moveDistance = mountain1.size.width
        let moveDuration = TimeInterval(10) // Durata del movimento
        
        // Calcolare i componenti x e y del movimento diagonale verso il basso a sinistra
        let angle = mountain1.zRotation
        let dx = -moveDistance * cos(angle)
        let dy = -moveDistance * sin(angle)
        
        // Creare l'animazione dello sfondo che si muove diagonalmente verso il basso a sinistra
        let moveDiagonal = SKAction.moveBy(x: dx, y: dy, duration: moveDuration)
        let resetPosition = SKAction.moveBy(x: -dx, y: -dy, duration: 0)
        
        // Creare una sequenza di azioni per il movimento continuo
        let moveSequence1 = SKAction.sequence([moveDiagonal, resetPosition])
        let moveSequence2 = SKAction.sequence([moveDiagonal, resetPosition])
        
        let repeatMove1 = SKAction.repeatForever(moveSequence1)
        let repeatMove2 = SKAction.repeatForever(moveSequence2)
        
        // Eseguire le azioni
        mountain1.run(repeatMove1)
        mountain2.run(repeatMove2)
    }
    
    override func update(_ currentTime: TimeInterval) {
          
        updateSky()
       }
    
    func updateSky() {
           
    }
    
}
