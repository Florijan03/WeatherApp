import UIKit
import SwiftUI

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func navigateBack()
    func showWeatherDetails(from view: AnyView, with weatherData: WeatherResponse)
}

class Router: AppRouterProtocol {
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        self.navigationController.navigationBar.tintColor = .black
    }
    
    func setStartScreen(in window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let locationListView = LocationListView(viewModel: WeatherViewModel(router: self))
        let hostingController = UIHostingController(rootView: locationListView)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func navigateBack() {
        navigationController.popViewController(animated: true)
    }
    
    func showWeatherDetails(from view: AnyView, with weatherData: WeatherResponse) {
        let detailsView = DetailsView(weatherData: weatherData)
        let hostingController = UIHostingController(rootView: detailsView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}
