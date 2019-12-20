//
//  BaseViewController.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 02/07/2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppTheme.background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Remove 'Back' button title
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
}
