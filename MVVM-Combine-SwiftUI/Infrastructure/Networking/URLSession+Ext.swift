//
//  URLSession+Ext.swift
//  MVVM-Combine-SwiftUI
//
//  Created by Gilang Sinawang on 24/06/24.
//

import Foundation
import Combine

extension URLSession {
    func downloadTaskPublisher(for url: URL) -> URLSession.DownloadTaskPublisher {
        return DownloadTaskPublisher(request: URLRequest(url: url), session: self)
    }
    
    func uploadTaskPublisher(for request: URLRequest, from bodyData: Data) -> URLSession.UploadTaskPublisher {
        return UploadTaskPublisher(request: request, session: self, bodyData: bodyData)
    }
}

extension URLSession {
    struct DownloadTaskPublisher: Publisher {
        typealias Output = (url: URL, response: URLResponse)
        typealias Failure = URLError
        
        let request: URLRequest
        let session: URLSession
        
        func receive<S>(subscriber: S) where S : Subscriber, S.Failure == URLError, S.Input == (url: URL, response: URLResponse) {
            let subscription = DownloadTaskSubscription(subscriber: subscriber, session: session, request: request)
            subscriber.receive(subscription: subscription)
        }
        
        private final class DownloadTaskSubscription<S: Subscriber>: Subscription where S.Input == (url: URL, response: URLResponse), S.Failure == URLError {
            private var subscriber: S?
            private var task: URLSessionDownloadTask?
            
            init(subscriber: S, session: URLSession, request: URLRequest) {
                self.subscriber = subscriber
                self.task = session.downloadTask(with: request) { [weak self] url, response, error in
                    guard let self = self else { return }
                    if let url = url, let response = response {
                        _ = self.subscriber?.receive((url, response))
                        self.subscriber?.receive(completion: .finished)
                    } else if let error = error as? URLError {
                        self.subscriber?.receive(completion: .failure(error))
                    }
                }
            }
            
            func request(_ demand: Subscribers.Demand) {
                task?.resume()
            }
            
            func cancel() {
                task?.cancel()
            }
        }
    }
    
    struct UploadTaskPublisher: Publisher {
        typealias Output = (data: Data, response: URLResponse)
        typealias Failure = URLError
        
        let request: URLRequest
        let session: URLSession
        let bodyData: Data
        
        func receive<S>(subscriber: S) where S : Subscriber, S.Failure == URLError, S.Input == (data: Data, response: URLResponse) {
            let subscription = UploadTaskSubscription(subscriber: subscriber, session: session, request: request, bodyData: bodyData)
            subscriber.receive(subscription: subscription)
        }
        
        private final class UploadTaskSubscription<S: Subscriber>: Subscription where S.Input == (data: Data, response: URLResponse), S.Failure == URLError {
            private var subscriber: S?
            private var task: URLSessionUploadTask?
            
            init(subscriber: S, session: URLSession, request: URLRequest, bodyData: Data) {
                self.subscriber = subscriber
                self.task = session.uploadTask(with: request, from: bodyData) { [weak self] data, response, error in
                    guard let self = self else { return }
                    if let data = data, let response = response {
                        _ = self.subscriber?.receive((data, response))
                        self.subscriber?.receive(completion: .finished)
                    } else if let error = error as? URLError {
                        self.subscriber?.receive(completion: .failure(error))
                    }
                }
            }
            
            func request(_ demand: Subscribers.Demand) {
                task?.resume()
            }
            
            func cancel() {
                task?.cancel()
            }
        }
    }
}
