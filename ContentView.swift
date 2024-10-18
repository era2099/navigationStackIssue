//
//  ContentView.swift
//  NavigationStackBug
//
//  Created by Eduardo Ruiz Alfaro on 18/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabBarView()
    }
}

struct TabBarView: View {
    @ObservedObject var tabBarVC = TabBarViewController()

    var body: some View {
        TabView(selection: $tabBarVC.selectedTab) {
            Text("HomeView")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(TabBarViewController.Tab.home)
            
            SettingsView(settingsVC: tabBarVC.settingsVC)
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(TabBarViewController.Tab.settings)
        }
        .onChange(of: tabBarVC.selectedTab) { oldValue, newValue in
            tabBarVC.settingsVC.clearNavigationPath()
        }
    }
}

struct SettingsView: View {
    @ObservedObject var settingsVC: SettingsViewController

    var body: some View {
        NavigationStack(path: $settingsVC.navigationPath) {
            List {
                Button("View One") {
                    settingsVC.navigateTo(destination: .viewOne)
                }
                
                Button("View Two") {
                    settingsVC.navigateTo(destination: .viewTwo)
                }
                
                Button("View Three") {
                    settingsVC.navigateTo(destination: .viewThree)
                }
            }
            .navigationDestination(for: SettingsViewController.Destination.self) { destination in
                switch destination {
                case .viewOne:
                    Text("View One")
                case .viewTwo:
                    Text("View Two")
                case .viewThree:
                    Text("View Three")
                }
            }
        }
    }
}

class TabBarViewController: ObservableObject {
    enum Tab {
        case home
        case settings
    }

    @Published var selectedTab: Tab = .home
    @Published var settingsVC: SettingsViewController = .init()
}

class SettingsViewController: ObservableObject {
    enum Destination {
        case viewOne
        case viewTwo
        case viewThree
    }
    
    @Published var navigationPath: NavigationPath = .init()
    
    func navigateTo(destination: Destination) {
        self.navigationPath.append(destination)
    }
    
    func clearNavigationPath() {
        self.navigationPath = .init()
    }
}

#Preview {
    ContentView()
}
