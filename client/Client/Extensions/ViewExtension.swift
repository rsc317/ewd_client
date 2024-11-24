//
//  ViewExtension.swift
//  client
//
//  Created by Emircan Duman on 24.11.24.
//

import SwiftUI

extension View {
 
    func navigationBarTitleColor(_ color: Color) -> some View {
        return self.modifier(NavigationBarTitleColorModifier(color: color))
    }
}
 
struct NavigationBarTitleColorModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .onAppear {
                let coloredAppearance = UINavigationBarAppearance()
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(color)]
                UINavigationBar.appearance().standardAppearance = coloredAppearance
            }
    }
}
