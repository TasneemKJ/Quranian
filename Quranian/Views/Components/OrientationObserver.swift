//
//  OrientationObserver.swift
//  Quranian
//
//  Created by Tasnim Almousa on 07/04/2025.
//


import Combine
import SwiftUI

class OrientationObserver: ObservableObject {
    @Published var orientation: UIDeviceOrientation = UIDevice.current.orientation

    private var cancellable: AnyCancellable?

    init() {
        cancellable = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            .sink { [weak self] _ in
                self?.orientation = UIDevice.current.orientation
            }
    }
}