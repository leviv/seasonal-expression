//
//  ContentView.swift
//

import SwiftUI
//import CoreData
import Combine

enum TimeOfDay {
    case dawn
    case morning
    case day
    case evening
    case dusk
    case night
}

private var summerSolstice: Date = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    return formatter.date(from: "2022/06/21")!
}()

// this might be the dumbest possible way to do this i honestly couldn't tell u
final class UpdateObject: ObservableObject {
    @Published var time = Date()
    @Published var angle: Double = 0 //sorry i know technically this shouldn't be here
    var timeOfDay: TimeOfDay = .day

    private let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .default).autoconnect()
    private var timerObserver: AnyCancellable?

    init() {
        timerObserver = timer.sink { [unowned self] _ in
            self.time = Date()
            //lol this doesn't work at all
            self.angle = self.angle > 360 ? self.angle - 360 + 5 : self.angle + 5
        }
        timeOfDay = bucketTimeOfDay()
    }

    private func bucketTimeOfDay() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: time)
        //would be cool if these values were dynamic
        if hour < 6 {
            return .night
        } else if hour < 8 {
            return .dawn
        } else if hour < 12 {
            return .morning
        } else if hour < 16 {
            return .day
        } else if hour < 18 {
            return .evening
        } else if hour < 20 {
            return .dusk
        } else {
            return .night
        }
    }
}

struct ContentView: View {

    @ObservedObject var update = UpdateObject()

    var body: some View {
        ZStack {
            //Background Color
            Group {
                LinearGradient(gradient: Gradient(colors: backgroundGradientForTimeOfDay(timeOfDay: update.timeOfDay)), startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            }
            //these are just here for fun lol ignore em
            Circle()
                .fill(
                    AngularGradient(gradient: Gradient(colors: [.red, .yellow, .green, .blue, .purple, .red]), center: .center)
                )
                .animation(.spring()) //TODO: have fun w/ this
            Ellipse()
                .path(in: CGRect(x: 0, y: 0, width: 50, height: 50))
            ////////////////////////////////

            let daysLeft = Int(Date().distance(to: summerSolstice) / (60 * 60 * 24))
            VStack {
                Spacer()
                VStack {
                    Text("today is \(Date(), formatter: dateFormatter)")
                    Text("\(daysLeft) days until summer solstice")
                }
                .lineLimit(1)
            }
            .foregroundColor(.white)

            Text("it's currently \(update.time, formatter: timeFormatter)")
                .rotationEffect(Angle(degrees: update.angle))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }

    private func backgroundGradientForTimeOfDay(timeOfDay: TimeOfDay) -> [Color] {
        switch timeOfDay { //maybe make some colors here for fun
        case .dawn: return [.black, .red, .yellow]
        case .morning: return [.red, .yellow]
        case .day: return [.blue, .yellow]
        case .evening: return [.purple, .orange]
        case .dusk: return [.black, .purple, .orange, .yellow]
        case .night: return [.black, .black, .black, .blue]
        }
    }

    private func path(in rect: CGRect) -> Path {
        var path = Path()
        let center:CGPoint = CGPoint(x: rect.midX,y: rect.midY)
        path.move(to: CGPoint(x: center.x + 64, y: center.y))
        path.addArc(center: center, radius: 64, startAngle: .degrees(0),   endAngle: .degrees(360), clockwise: false)
        return path
    }
}

private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .medium
    return formatter
}()

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
