import SwiftUI
import SpriteKit

struct MyTreeView: View {
    var scene: SKScene {
        let scene = SKScene(fileNamed: "GameScene")
        scene!.size = CGSize(width: 750, height: 1334) 
        scene?.scaleMode = .aspectFit
        return scene!
    }
    
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clear)
    }
}

#Preview {
    MyTreeView()
}
