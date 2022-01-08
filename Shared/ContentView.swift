//
//  ContentView.swift
//

import SwiftUI
import CoreData

enum TimeOfDay {
    case morning
    case day
    case evening
    case night
    case none
}

struct ContentView: View {

    let currentTime = Date()
    let timeOfDay: TimeOfDay = .none

    var body: some View {
        //TODO: make sure date updates, currently doesn't change
        ZStack {
            //Background Color
            Group {
                LinearGradient(gradient: Gradient(colors: [.red, .yellow]), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            Circle().path(in: CGRect(x: 0, y: 0, width: 100, height: 100))
                .foregroundColor(.orange)
                .animation(.spring()) //TODO: have fun w/ this

            Text("it's currently \(currentTime, formatter: itemFormatter)")
                .rotationEffect(Angle(degrees: 72))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .animation(.easeInOut) //TODO: make wiggly if possible

        }
    }

    //TODO: return cool gradient based on what bucket time of day you're in
//    func backgroundGradientForTimeOfDay() -> LinearGradient {
//
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
