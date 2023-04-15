//
//  Publisher+WeakAssign.swift
//  NYTimes
//
//  Created by Hoang Nguyen Ngoc on 2/14/23.
//

import Foundation
import Combine

extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(
        to keyPath: ReferenceWritableKeyPath<T, Output>,
        on object: T
    ) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
