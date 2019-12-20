//
//  SystemDeviceModule.swift
//  Simple Wine
//
//  Created by Ivan Babich on 24/10/2018.
//  Copyright © 2018 Aynur Galiev. All rights reserved.
//

import Foundation

final class SystemDeviceModule: NSObject {
    
    var didStaticLoad: ((String?) -> Void)?
    var didStaticLoadFail: ((SWError) -> Void)?
    private var systemDevice = SystemDevicePlainModel(device: "")
    private var staticURL: String?
    private var wineshopService: WineshopService!
    private var task: URLSessionTask? {
        willSet { task?.cancel() }
    }
    
    init(wineshopService: WineshopService = WineshopServiceImplementation()) {
        self.wineshopService = WineshopServiceImplementation()
    }
    
    func loadSystemDevice(completion: @escaping((String?, Error?) -> Void)) {
        self.task = wineshopService.fetchAvailableSystemDevice(onSuccess: {(response, task, data) in
            guard let task = task, task.state != .canceling else { return }
            completion(response.value?.device, nil)
        }) {(error, task, data) in
            guard let task = task, task.state != .canceling else { return }            
            completion(nil, error)
        }
    }
    
    func loadURL() {
        self.task = wineshopService.fetchAvailableConfig(onSuccess: { [weak self] (response, task, data) in
            guard let sself = self, let task = task, task.state != .canceling, let config = response.value else { return }
            STATIC_URL = config.staticURL
            sself.didStaticLoad?(config.staticURL)
        }) { [weak self] (error, task, data) in
            guard let sself = self, let task = task, task.state != .canceling else { return }
            sself.didStaticLoadFail?(error)
        }
    }
    
}
