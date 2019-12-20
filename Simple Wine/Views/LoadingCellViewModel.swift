//
//  LoadingCellViewModel.swift
//  Simple Wine
//
//  Created by Aynur Galiev on 26.марта.2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation
import UIKit

enum LoadingCellState: Equatable {
    case inProgress, error
}

struct LoadingCellViewModel: CellViewModel {
    
    static func == (lhs: LoadingCellViewModel, rhs: LoadingCellViewModel) -> Bool {
        return lhs.state == rhs.state
    }

    //Input
    var state: LoadingCellState {
        didSet {
            stateChanged?(state)
        }
    }
    var tryAgainAction: (() -> Void)?
    var stateChanged: ((LoadingCellState) -> Void)?
    
    init(state: LoadingCellState) {
        self.state = state
    }
    
    static var cellIdentifier: String {
        return String(describing: LoadingCell.self)
    }
    
    func height(for width: CGFloat) -> CGFloat {
        return LoadingCell.cellHeight(for: self, width: width)
    }
}
