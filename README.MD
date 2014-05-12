Custom Circle Zoom/Fade UIView Controller Transition
=========

This project is created as an example to show how to animate a view and complete a fade transition using iOS7's UIViewControllerTransitioningDelegate || UIViewControllerAnimatedTransitioning protocols.



Version
----

1.0 - Initial Commit

Animation/Transition Process
-----------

Circle Views are created by creating equal height/width UIViews with the layer.cornerRadius set at 1/2 the width. The views are added with AutoLayout constraints. When a circle view is tapped the following occurs:  
- Animate circle to 0.5 transform
- Animate circle to 10 transform
- Begin transition to fade in the next UIViewController

For the reverse the following occurs:  
- Fade original (first) UIViewController back in
- Within viewWillAppear we begin to animate the circle back to its standard form
- Within viewDidAppear we pickup this view and continue the animation to 0.5 transform
- Animate circle to 1.5 transform
- Animate back to standard form

Code Examples
--------------
There are two starting UIViewController examples. One has only one circle and the other has multiple (three circles).  
By default the multi circle view is loaded. Comment out the three lines in App Delegate - `didFinishLaunchingWithOptions` for the single circle view approach.
```
    UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[mainstoryboard instantiateViewControllerWithIdentifier:@"Multi"]];
    
    self.window.rootViewController = navVC;
```


License
----

MIT - http://opensource.org/licenses/MIT  

Please link back to me/this project if you use it in anyway.

Links
----
[Stuart Morris Github]:https://github.com/StuartMorris0
[@MorrisStuart]:http://twitter.com/MorrisStuart
[LinkedIn]:http://uk.linkedin.com/pub/stuart-morris/44/465/125