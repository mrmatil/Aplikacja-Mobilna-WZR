//
//  SwipableTBController.swift
//  Aplikacja Mobilna WZR
//
//  Created by Mateusz Łukasiński on 20/08/2019.
//  Copyright © 2019 Mateusz Łukasiński. All rights reserved.
//

import Foundation
import SwipeableTabBarController

class SwipableTBController: SwipeableTabBarController {
    override func viewDidLoad() {
        swipeAnimatedTransitioning?.animationType = SwipeAnimationType.sideBySide
        isSwipeEnabled = false
    }
}
