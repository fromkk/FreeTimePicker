//
//  AdBanner.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/02/16.
//  Copyright © 2020 fromKK. All rights reserved.
//

#if !targetEnvironment(macCatalyst)
    import GoogleMobileAds
#endif
import SwiftUI
import UIKit

#if !targetEnvironment(macCatalyst)
    final class AdBannerViewController: UIViewController {
        private lazy var request = GADRequest()

        var adUnitID: String? {
            didSet {
                bannerView.adUnitID = adUnitID
                bannerView.load(request)
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            bannerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(bannerView)
            NSLayoutConstraint.activate([
                bannerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                bannerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
            if adUnitID != nil {
                bannerView.load(request)
            }
        }

        lazy var bannerView: GADBannerView = {
            let bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView.adUnitID = adUnitID
            bannerView.rootViewController = self
            return bannerView
        }()
    }

#else
    final class AdBannerViewController: UIViewController {
        var adUnitID: String?
    }
#endif

struct AdBannerView: UIViewControllerRepresentable {
    let adUnitID: String?
    func makeUIViewController(context _: UIViewControllerRepresentableContext<AdBannerView>) -> AdBannerViewController {
        let vc = AdBannerViewController()
        vc.view.backgroundColor = .clear
        vc.adUnitID = adUnitID
        return vc
    }

    func updateUIViewController(_: AdBannerViewController, context _: UIViewControllerRepresentableContext<AdBannerView>) {
        // nothing todo
    }
}
