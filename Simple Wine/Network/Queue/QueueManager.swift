//
//  QueueManager.swift
//  Simple Wine
//
//  Created by Dmitry Laenko on 18.10.2019.
//  Copyright © 2019 Aynur Galiev. All rights reserved.
//

import Foundation

class QueueManager {

    static let instance = QueueManager()
    
    typealias CompletionBlock = (Data?, URLResponse?, Error?) -> Swift.Void
    class Item {
        var request: URLRequest
        var completion: CompletionBlock
        var status: Status = .wait
        var task: URLSessionDataTask?
        
        init(request: URLRequest, completion: @escaping CompletionBlock) {
            self.request = request
            self.completion = completion
        }
    }
    
    enum Status {
        case wait, progress
    }

    private var session: URLSession
    private var queue = [Item]()
    
    let limit = 5
    
    init() {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.httpMaximumConnectionsPerHost = 5
        sessionConfig.timeoutIntervalForRequest = 300.0
        sessionConfig.timeoutIntervalForResource = 900.0
        session = URLSession(configuration: sessionConfig)
    }
    
    
    func push(request: URLRequest, completionHandler: @escaping CompletionBlock) -> URLSessionDataTask{
        let item = Item(request: request, completion: completionHandler)
        let task = session.dataTask(with: item.request) { [weak self] (data, urlResponse, error) in
            print("<<< \(request.url?.absoluteString.removingPercentEncoding ?? "")")
            item.completion(data, urlResponse, error)
            self?.remove(item: item)
            self?.execute()
        }
        item.task = task
        queue.append(item)
        execute()
        return task
    }
        
}

private extension QueueManager {
    
    func execute(){
        guard count() < limit else { return }
        guard let item = first() else { return }
        guard let task = item.task, task.state != .canceling else {
            remove(item: item)
            return
        }
        item.status = .progress
        print(">>> \(item.request.url?.absoluteString.removingPercentEncoding ?? "")")
        item.task?.resume()
    }
    
    func count() -> Int {
        return (queue.filter { $0.status == .progress }).count
    }
    
    func first() -> Item? {
        return queue.first { $0.status == .wait }
    }
    
    func remove(item: Item){
        if let index = (queue.firstIndex { $0.status == .progress && $0.request == item.request }) {
            queue.remove(at: index)
        }
    }
}
