import UIKit

class ViewController: UIViewController,
    UIViewControllerTransitioningDelegate {
    
    var animator = ModalWithPopAnimator()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnATapped(sender: AnyObject) {
        var vc = SomeViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = self
        var button = sender as UIButton
        self.animator.startPoint = self.getCenterPointFromView(button)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func BtnATapped(sender: AnyObject) {
        var vc = SomeViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = self
        var button = sender as UIButton
        self.animator.startPoint = self.getCenterPointFromView(button)
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func btnCTapped(sender: AnyObject) {
        var vc = SomeViewController()
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
        vc.transitioningDelegate = self
        var button = sender as UIButton
        self.animator.startPoint = self.getCenterPointFromView(button)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func getCenterPointFromView(view :UIView) -> CGPoint {
        var rect = view.convertRect(view.bounds, toView: nil)
        return CGPointMake(rect.origin.x + rect.size.width / 2,
                            rect.origin.y + rect.size.height / 2)
    }
    
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isReverse = false
        return self.animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.animator.isReverse = true
        return self.animator
    }
}

