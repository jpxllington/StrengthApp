//
//  ContentView.swift
//  Strength
//
//  Created by James Pollington on 04/03/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var selection = 1
    @State private var showActiveWorkout: Bool = false

    var body: some View {
        TabView(selection: $selection){
            
            WorkoutMenu(tabSelection: $selection, activeWorkout: $showActiveWorkout)
                .tabItem{
                    Image(systemName: "flame")
                    Text("New Workout")
                }.tag(0)
            if showActiveWorkout {
                Text("Active Workout")
                    .tabItem{
                        Image(systemName: "figure.walk")
                        Text("Active Workout")
                    }.tag(3)
            }
            SummaryPage()
                .tabItem{
                    Image(systemName: "house.fill")
                    Text("Summary")
                }.tag(1)
            WorkoutHistoryView(sortDescriptor: NSSortDescriptor(keyPath: \Workout.started, ascending: false))
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }.tag(2)
                
        }
       
    }
}

// Colours top navigation bar across all screens

//extension UINavigationController {
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//
//    let standard = UINavigationBarAppearance()
//    standard.backgroundColor = .red //When you scroll or you have title (small one)
//
//    let compact = UINavigationBarAppearance()
//    compact.backgroundColor = .green //compact-height
//
//    let scrollEdge = UINavigationBarAppearance()
//    scrollEdge.backgroundColor = .blue //When you have large title
//
//    navigationBar.standardAppearance = standard
//    navigationBar.compactAppearance = compact
//    navigationBar.scrollEdgeAppearance = scrollEdge
// }
//}

extension UIApplication {
    var key: UIWindow? {
        self.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first
    }
}


extension UIView {
    func allSubviews() -> [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            let rec = subview.allSubviews()
            subs.append(contentsOf: rec)
        }
        return subs
    }
}
    

struct TabBarModifier {
    static func showTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    static func hideTabBar() {
        UIApplication.shared.key?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        })
    }
}

struct ShowTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.showTabBar()
        }
    }
}
struct HiddenTabBar: ViewModifier {
    func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.hideTabBar()
        }
    }
}

extension View {
    
    func showTabBar() -> some View {
        return self.modifier(ShowTabBar())
    }

    func hiddenTabBar() -> some View {
        return self.modifier(HiddenTabBar())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
