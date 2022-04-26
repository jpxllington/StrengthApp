//
//  ContentView.swift
//  Strength
//
//  Created by James Pollington on 04/03/2022.
//

import SwiftUI
import CoreData
import UIKit

struct ContentView: View{

    
    @State private var selection = "plus"
    @State private var showActiveWorkout: Bool = false

    init() {
//        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().barTintColor = UIColor(named: "Shadow")
//        UITabBar.appearance().backgroundColor = UIColor(named: "Shadow")
        UITabBar.appearance().isHidden = true
    }
    
    @State var xAxis: CGFloat = 0
    @Namespace var animation
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            TabView(selection: $selection){
                
                
                if showActiveWorkout {
                    Text("Active Workout")
    //                    .tabItem{
    //                        Image(systemName: "figure.walk")
    //                        Text("Active Workout")
    //                    }.tag(3)
                }
                SummaryPage()
    //                .tabItem{
    //                    Image(systemName: "house.fill")
    //                    Text("Summary")
    //                }
                    .tag("flame")
                WorkoutMenu()
    //                .tabItem{
    //                    Image(systemName: "flame")
    //                    Text("New Workout")
    //                }
                    .tag("plus")
                WorkoutHistoryView(sortDescriptor: NSSortDescriptor(keyPath: \Workout.started, ascending: false))
    //                .tabItem {
    //                    Image(systemName: "clock.fill")
    //                    Text("History")
    //                }
                    .tag("clock.fill")
                
                IntervalTimer()
    //                .tabItem{
    //                    Text("Interval Timer")
    //                }
                    .tag("timer")
          
                    
            }
//            .tabViewStyle(backgroundColor: Color("Shadow").opacity(0.3),
//                          itemColor: .orange.opacity(0.95),
//                          selectedItemColor: .blue,
//                      badgeColor: .green)
            
            HStack(spacing: 0){
                ForEach(tabs,id: \.self){image in
                    GeometryReader { reader in
                        Button(action: {
                            withAnimation(.spring()){
                                selection = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        }, label: {
                            Image(systemName: image)
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .foregroundColor(selection == image ? Color.red : Color.gray)
                                .padding(selection == image ? 15 : 0)
                                .background(Color("ListItem").opacity(selection == image ? 1 : 0).clipShape(Circle()).shadow(color: Color("Shadow").opacity(0.15), radius: 2, x: 0, y: 8))
                                
//                                .matchedGeometryEffect(id: Image, in: animation)
                                .offset(x: selection == image ? (reader.frame(in: .global).minX - reader.frame(in: .global).midX) : 0, y: selection == image ? -50 : 0)
                        })
                        .onAppear(perform: {
                            if image == tabs.first{
                                xAxis = reader.frame(in: .global).minX
                            }
                        })
                    }
                    .frame(width: 25, height: 30)
                    
                    if image != tabs.last{Spacer(minLength: 0)}
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
            .background(Color("ListItem").clipShape(CustomShape(xAxis: xAxis)).cornerRadius(12).shadow(color: Color("Shadow").opacity(0.35), radius: 11, x: 0, y: 8))
            
            .padding(.horizontal)
            .padding(.bottom, 40)
            
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
}

var tabs = ["plus", "flame", "clock.fill", "timer"]


struct CustomShape: Shape {
    
    var xAxis: CGFloat
    
    var animatableData: CGFloat{
        get{return xAxis}
        set{xAxis = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path{path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = xAxis
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center - 25, y: 0)
            let control2 = CGPoint(x: center - 25, y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 25, y: 35)
            let control4 = CGPoint(x: center + 25, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
            
        }
    }
}
// Colours top navigation bar across all screens

//extension UINavigationController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//
//    let standard = UINavigationBarAppearance()
//        standard.backgroundColor = Color("Shadow").uiColor //When you scroll or you have title (small one)
//
//    let compact = UINavigationBarAppearance()
//        compact.backgroundColor = Color("Shadow").uiColor //compact-height
//
//    let scrollEdge = UINavigationBarAppearance()
//        scrollEdge.backgroundColor = Color("Shadow").uiColor //When you have large title
//
//    navigationBar.standardAppearance = standard
//    navigationBar.compactAppearance = compact
//    navigationBar.scrollEdgeAppearance = scrollEdge
//    
// }
//}



//
//extension Color {
//  var uiColor: UIColor? {
//    if #available(iOS 14.0, *) {
//      return UIColor(self)
//    } else {
//      let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
//      var hexNumber: UInt64 = 0
//      var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
//      let result = scanner.scanHexInt64(&hexNumber)
//      if result {
//        r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//        g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//        b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//        a = CGFloat(hexNumber & 0x000000ff) / 255
//        return UIColor(red: r, green: g, blue: b, alpha: a)
//      } else {
//        return nil
//      }
//    }
//  }
//}
//
//extension View {
//  func tabViewStyle(backgroundColor: Color? = nil,
//                    itemColor: Color? = nil,
//                    selectedItemColor: Color? = nil,
//                    badgeColor: Color? = nil) -> some View {
//    onAppear {
//      let itemAppearance = UITabBarItemAppearance()
//      if let uiItemColor = itemColor?.uiColor {
//        itemAppearance.normal.iconColor = uiItemColor
//        itemAppearance.normal.titleTextAttributes = [
//          .foregroundColor: uiItemColor
//        ]
//      }
//      if let uiSelectedItemColor = selectedItemColor?.uiColor {
//        itemAppearance.selected.iconColor = uiSelectedItemColor
//        itemAppearance.selected.titleTextAttributes = [
//          .foregroundColor: uiSelectedItemColor
//        ]
//      }
//      if let uiBadgeColor = badgeColor?.uiColor {
//        itemAppearance.normal.badgeBackgroundColor = uiBadgeColor
//        itemAppearance.selected.badgeBackgroundColor = uiBadgeColor
//      }
//
//      let appearance = UITabBarAppearance()
//      if let uiBackgroundColor = backgroundColor?.uiColor {
//        appearance.backgroundColor = uiBackgroundColor
//      }
//
//      appearance.stackedLayoutAppearance = itemAppearance
//      appearance.inlineLayoutAppearance = itemAppearance
//      appearance.compactInlineLayoutAppearance = itemAppearance
//
//      UITabBar.appearance().standardAppearance = appearance
//      if #available(iOS 15.0, *) {
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//      }
//    }
//  }
//}
//
//extension UIApplication {
//    var key: UIWindow? {
//        self.connectedScenes
//            .map({$0 as? UIWindowScene})
//            .compactMap({$0})
//            .first?
//            .windows
//            .filter({$0.isKeyWindow})
//            .first
//    }
//}
//
//
//extension UIView {
//    func allSubviews() -> [UIView] {
//        var subs = self.subviews
//        for subview in self.subviews {
//            let rec = subview.allSubviews()
//            subs.append(contentsOf: rec)
//        }
//        return subs
//    }
//}
//
//
//struct TabBarModifier {
//    static func showTabBar() {
//        UIApplication.shared.key?.allSubviews().forEach({ subView in
//            if let view = subView as? UITabBar {
//                view.isHidden = false
//            }
//        })
//    }
//
//    static func hideTabBar() {
//        UIApplication.shared.key?.allSubviews().forEach({ subView in
//            if let view = subView as? UITabBar {
//                view.isHidden = true
//            }
//        })
//    }
//}
//
//struct ShowTabBar: ViewModifier {
//    func body(content: Content) -> some View {
//        return content.padding(.zero).onAppear {
//            TabBarModifier.showTabBar()
//        }
//    }
//}
//struct HiddenTabBar: ViewModifier {
//    func body(content: Content) -> some View {
//        return content.padding(.zero).onAppear {
//            TabBarModifier.hideTabBar()
//        }
//    }
//}
//
//extension View {
//
//    func showTabBar() -> some View {
//        return self.modifier(ShowTabBar())
//    }
//
//    func hiddenTabBar() -> some View {
//        return self.modifier(HiddenTabBar())
//    }
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
