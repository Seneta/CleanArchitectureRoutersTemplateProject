//
//  DIContainer.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation
import UIKit

final class AppDIContainer {

    // DIContainers of scenes
    func makeMoviesSceneDIContainer() -> ItemsSceneDIContainer {
        return ItemsSceneDIContainer()
    }
    
    
    
}
