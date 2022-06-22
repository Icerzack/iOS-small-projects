//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    override func loadView() {
        let redView = UIView()
        view.addSubview(redView)
        redView.backgroundColor = .red
        redView.frame.size = CGSize(width:(300),height:(300))
        
        let greenView=UIView()
        greenView.backgroundColor = .green
        greenView.frame.origin = CGPoint(x:50,y:50)
        greenView.frame.size = CGSize(width:(200),height:(200))
        greenView.bounds.origin = CGPoint(x:(0),y:(0))
        redView.addSubview(greenView)
                                 
        let blueView=UIView()
        blueView.backgroundColor = .blue
        blueView.frame.origin = .zero
        blueView.frame.size = CGSize(width:(100),height:(100))
        greenView.addSubview(blueView)
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
