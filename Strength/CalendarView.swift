//
//  CalendarView.swift
//  Strength
//
//  Created by James Pollington on 11/04/2022.
//

import SwiftUI
import Introspect
import CoreData

struct CalendarView: View {
    @State var currentDate: Date = Date()
    @FetchRequest(entity: Workout.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Workout.started, ascending: false)]) var workouts: FetchedResults<Workout>
    
    init(sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<Workout>(entityName: Workout.entity().name ?? "Workout" )
        fetchRequest.sortDescriptors = [sortDescriptor]

        _workouts = FetchRequest(fetchRequest: fetchRequest)
    }
    
    // Month update on arrow button click
    @State var currentMonth: Int = 0
    var body: some View {
        ScrollView(){
            VStack(spacing: 35){
                
                let days: [String] = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        Text(extraDate()[0])
                            .font(.caption)
                            .fontWeight(.semibold)
                        Text(extraDate()[1])
                            .font(.title2.bold())
                    }
                    
                    Spacer(minLength: 0)
                    
                    Button {
                        withAnimation{
                            currentMonth -= 1
                        }
                    }label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Button {
                        withAnimation{
                            currentMonth += 1
                        }
                    }label: {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 0){
                    ForEach(days, id: \.self) {day in
                        Text(day)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                //Lazy Grid
                
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(extractDate()){value in
                        CardView(value: value)
                            .background(
                            Capsule()
                                .fill(Color("TabIcon"))
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                                .scaleEffect(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.25)){
                                    currentDate = value.date
                                }
                            }
                    }
                }
                
                VStack(spacing: 20 ){
                    Text("Workouts")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if workouts.first(where: { workout in
                        return isSameDay(date1: workout.started!, date2: currentDate)
                    }) != nil{
                        ForEach(workouts){workout in
                            if isSameDay(date1: workout.started!, date2: currentDate){
                                ZStack {
                                    Rectangle()
                                       .foregroundColor(Color("ListItem"))
                                       .cornerRadius(20)
//                                       .shadow(color: Color("Shadow"), radius: 3, x: 0, y: 3)
                                       .padding(-7)
//                                       .overlay(
//                                            RoundedRectangle(cornerRadius: 20)
//                                            .stroke(Color("Shadow"), lineWidth: 2)
//                                            .padding(-7)
//                                            )
                                    HStack{
                                        WorkoutRow(workout: workout)
                                            .foregroundColor(.black)
                                        Image(systemName: "chevron.right")
                                    }
                                }
                                .padding(.vertical, 8)
                                
//                                VStack(alignment: .leading, spacing: 10){
//                                    Text(workout.name!)
//                                        .font(.title2.bold())
//                                }
//                                .padding(.vertical, 10)
//                                .padding(.horizontal)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(
//                                    Color.pink
//                                        .opacity(0.5)
//                                        .cornerRadius(10)
//                                )
                            }
                        }
                        
                    } else {
                        Text("No Workout Found")
                    }
                    Spacer(minLength: 120)
                }
                .padding()
                
            }
            .onChange(of: currentMonth){newValue in
                // updating month
                
                currentDate = getCurrentMonth()
            }
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue)->some View {
        VStack{
            if value.day !=  -1 {
                if let workout = workouts.first(where: { workout in
                    return isSameDay(date1: workout.started!, date2: value.date)
                }){
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: workout.started!, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: workout.started!, date2: currentDate) ? .white : Color("TabIcon"))
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? .white : .primary)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }

    // checking dates
    func isSameDay(date1: Date, date2: Date)-> Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    //extracting Year and Month for display
    
    func extraDate()->[String]{
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY MMMM"
        let date = formatter.string(from: currentDate)
        return date.components(separatedBy: " ")

    }

    func getCurrentMonth()-> Date{
        let calendar = Calendar.current
        
        // Getting current month date
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else{
            return Date()
        }
        return currentMonth
    }
    func extractDate()->[DateValue]{
        
        let calendar = Calendar.current
        
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekday - 1{
            days.insert(DateValue(day: -1, date: Date()), at: 0)
        }
        
        return days
    }
}

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}

extension Date{
    func getAllDates()->[Date]{
        let calendar = Calendar.current
        
        //getting start Date
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
        
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
