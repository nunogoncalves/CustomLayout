//
//  AppDelegate.swift
//  CustomLayout
//
//  Created by Nuno Gonçalves on 24/06/2017.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

public extension UIView {
    
    public func pinToEdges(of view: UIView,
                           top: CGFloat = 0,
                           leading: CGFloat = 0,
                           bottom: CGFloat = 0,
                           trailing: CGFloat = 0) {
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing)
            ])
        
    }
    
}

public let strings = [
    "1 - I am so blue I'm greener than purple.",
    "2 - I stepped on a Corn Flake, now I'm a Cereal Killer",
    "3 - Llamas eat sexy paper clips",
    "4 - Banana error.",
    "5 - Everyday a grape licks a friendly cow",
    "6 - On a scale from one to ten what is your favourite colour of the alphabet.",
    "7 - The sparkly lamp ate a pillow then punched Larry.",
    "8 - Look, a distraction!",
    "9 - Screw world peace, I want a pony",
    "10 - What do you think about the magical yellow unicorn who dances on the rainbow with a spoonful of blue cheese dressing?",
    "11 - If your canoe is stuck in a tree with the headlights on, how many pancakes does it take to get to the moon?",
    "12 - There's a purple mushroom in my backyard, screaming Taco's!",
    "13 - Oh no, you're one of THEM!!!!",
    "14 - When life gives you lemons, chuck them at people you hate",
    "15 - A Zebra licked a DVD",
    "16 - A hotdog on a bridge",
    "17 - My nose is a communist.",
    "18 - Cheese grader shaved my butt skin off",
    "19 - Metallica ate a hairy garilla with purple nipples then swaped a red tyre with a fire breathing goat last Tuesday at breakfast",
]

//public let strings = [
//    "1 - .",
//    "2 - .",
//    "3 - .",
//    "4 - .",
//    "5 - .",
//    "6 - .",
//    "7 - .",
//    "8 - .",
//    "9 - .",
//    "10 - .",
//    "11 - .",
//    "12 - .",
//    "13 - .",
//    "14 - .",
//    "15 - .",
//    "16 - .",
//    "17 - .",
//    "18 - .",
//    "19 - ."
//]

