DroppyMenuViewController
========================

A swift dropping menu controller.  
  
Auto generates the menu view by its view controllers.  
  
Drops down from top of the screen with UIDynamics animation.

Can be used with either storyboards or manual.

Demo
----

![alt tag]()

Installing
----------

### Manual

Copy & paste DroppyMenuViewController subfolder to your project.

### Cocoapods

Its not ready yet.

``` ruby
	pod 'DroppyMenuViewController', '~> 0.1'
```

Usage
-----

### Storyboard

Create your view controllers in your storyboard and make sure give them a `Storyboard Identifier` and `Title` (for the menu item).
Create a subclass of `DroppyMenuViewController` and in its `viewDidLoad:` method, setup `self.viewControllers` property

``` swift
	class MenuViewController: DroppyMenuViewController {

	    override func viewDidLoad() {
	        super.viewDidLoad()

	        let first = getViewController("First")
	        let second = getViewController("Second")
	        let third = getViewController("Third")
	        
	        viewControllers = [first, second, third]
	    }
	    
	    func getViewController (storyboardIdentifier: String) -> UIViewController {
	        return UIStoryboard (name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(storyboardIdentifier) as! UIViewController
	    }
	}

```

### Manual

In your `AppDelegate`'s `application:didFinishLaunchingWithOptions:` method, create your view controllers.  
Then create a `DroppyMenuViewController` with that view controllers.  
Initilize `window` property and set rootViewController as your menu controller.
   
``` swift
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let first = FirstViewController ()
        let second = SecondViewController ()
        let third = ThirdViewController ()
        
        let menuController = DroppyMenuViewController (viewControllers: [first, second, third])
        
        window = UIWindow (frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = menuController
        window!.makeKeyAndVisible()
        
        return true
    }
```
