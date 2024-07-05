//
//  progressView.swift
//  sadb
//
//  Created by Studente on 05/07/24.
//

import SwiftUI
import UIKit

struct progressView: View {

    var body: some View {
            VStack {
                // Top header
                HStack {
                    Spacer()
                    Text("Progressi")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.top, 20)
                
                // Savings and days without smoking
                HStack {
                    VStack {
                        Text("€")
                            .font(.largeTitle)
                        Text("120")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Text("Denaro risparmiato")
                            .font(.caption)
                    }
                    Spacer()
                    VStack {
                        Text("🕒")
                            .font(.largeTitle)
                        Text("12")
                            .font(.system(size: 50))
                            .fontWeight(.bold)
                        Text("Giorni senza fumare")
                            .font(.caption)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                // Weekly chart placeholder
                VStack {
                    Image(systemName: "chart.pie")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    Text("Grafico settimanale")
                        .font(.headline)
                }
                .padding(.top, 20)
                
                // Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        // Action for Obbiettivi raggiunti
                    }) {
                        Text("Obbiettivi raggiunti")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action for Lista dei desideri
                    }) {
                        Text("Lista dei desideri")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        // Action for Benefici sulla salute
                    }) {
                        Text("Benefici sulla salute")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Bottom navigation bar

            }
        }
    }

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the view controllers
        let diaryVC = UIViewController()
        diaryVC.view.backgroundColor = .white
        diaryVC.tabBarItem = UITabBarItem(title: "Diario", image: UIImage(systemName: "list.bullet"), tag: 0)
        
        let myTreeVC = UIViewController()
        myTreeVC.view.backgroundColor = .white
        myTreeVC.tabBarItem = UITabBarItem(title: "Il mio albero", image: UIImage(systemName: "leaf"), tag: 1)
        
        let progressVC = UIViewController()
        progressVC.view.backgroundColor = .white
        progressVC.tabBarItem = UITabBarItem(title: "Progressi", image: UIImage(systemName: "sparkles"), tag: 2)
        
        // Set the view controllers of the tab bar
        self.viewControllers = [diaryVC, myTreeVC, progressVC]
        
        // Customize the tab bar appearance
        self.tabBar.tintColor = UIColor.systemGreen
        self.tabBar.unselectedItemTintColor = UIColor.gray
    }
}


    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
#Preview {
    progressView()
}
