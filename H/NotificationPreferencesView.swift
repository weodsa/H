import SwiftUI
import UserNotifications

// MARK: - Model
struct NotificationPreferences {
    var startHour: String = ""
    var startAMPM: String = "AM"
    var endHour: String = ""
    var endAMPM: String = "AM"
    var selectedInterval: Int = 15
}

// MARK: - ViewModel
class NotificationPreferencesViewModel: ObservableObject {
    @Published var preferences = NotificationPreferences()
    @Published var showAlert = false
    
    let intervals = [15, 30, 60, 90, 120, 180, 240, 300]
    
    func displayInterval(interval: Int) -> String {
        if interval < 60 {
            return "\(interval)\nMins"
        } else {
            let hours = interval / 60
            return "\(hours)\nHours"
        }
    }
    
    func handleStartAction() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.scheduleNotifications()
            } else {
                print("Permission not granted for notifications")
            }
        }
    }
    
    private func scheduleNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        guard let startHour = convertTo24HourFormat(hour: preferences.startHour, ampm: preferences.startAMPM),
              let endHour = convertTo24HourFormat(hour: preferences.endHour, ampm: preferences.endAMPM) else {
            print("Invalid start or end time")
            return
        }
        
        let interval = preferences.selectedInterval * 60
        var currentTime = startHour * 60 * 60
        let endTime = endHour * 60 * 60
        
        while currentTime < endTime {
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "Water Intake Reminder"
            notificationContent.body = "It's time to drink water and stay hydrated!"
            notificationContent.sound = .default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(currentTime), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            
            currentTime += interval
        }
        
        DispatchQueue.main.async {
            self.showAlert = true
        }
    }
    
    private func convertTo24HourFormat(hour: String, ampm: String) -> Int? {
        guard let hourInt = Int(hour) else { return nil }
        return ampm == "PM" && hourInt != 12 ? hourInt + 12 : (ampm == "AM" && hourInt == 12 ? 0 : hourInt)
    }
}

// MARK: - View
struct NotificationPreferencesView: View {
    @StateObject private var viewModel = NotificationPreferencesViewModel()
    
    var body: some View {
        VStack {
            Text("Notification Preferences")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 20)
                .padding(.leading,-114)
            VStack(alignment: .leading, spacing: 7) {
                Text("The start and End hour")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.leading,-37)
                Text("Specify the start and end time to receive the notifications")
                    .foregroundColor(.gray)
                    .font(.callout)
                    .padding(.leading,-35)
            }
            .padding(.bottom, 10)
            
            VStack {
                HStack {
                    Text("Start hour")
                    Spacer()
                    HStack {
                        TextField("3:00", text: $viewModel.preferences.startHour)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Picker("", selection: $viewModel.preferences.startAMPM) {
                            Text("AM").tag("AM")
                            Text("PM").tag("PM")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 90)
                    }
                }
                .padding(.bottom, 15)
                
                HStack {
                    Text("End hour")
                    Spacer()
                    HStack {
                        TextField("3:00", text: $viewModel.preferences.endHour)
                            .keyboardType(.numberPad)
                            .frame(width: 60)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Picker("", selection: $viewModel.preferences.endAMPM) {
                            Text("AM").tag("AM")
                            Text("PM").tag("PM")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 90)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text("Notification interval")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                Text("How often would you like to receive notifications within the specified time interval")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .padding(.bottom, 15)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 15) {
                    ForEach(viewModel.intervals, id: \.self) { interval in
                        Button(action: {
                            viewModel.preferences.selectedInterval = interval
                        }) {
                            Text(viewModel.displayInterval(interval: interval))
                                .frame(minWidth: 80, minHeight: 80)
                                .background(viewModel.preferences.selectedInterval == interval ? Color.bluu : Color(.systemGray6))
                                .foregroundColor(viewModel.preferences.selectedInterval == interval ? .white : .black)
                                .cornerRadius(15)
                        }
                    }
                }
            }
            
            Spacer()

            Button(action: {
                viewModel.handleStartAction()
            }) {
                Text("Start")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.bluu)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.horizontal)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text("Preferences Saved"),
                    message: Text("Your notification preferences have been updated."),
                    dismissButton: .default(Text("OK"))
                )
            }

            NavigationLink(destination: WaterIntakeView()) {
                Text("View Water Intake")
                    .foregroundColor(.bluu)
                    .padding(.top, 10)
            }
        }
        .padding()
    }
}

extension Color {
    static let blue = Color.blue
}
// MARK: - Preview
struct NotificationPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationPreferencesView()
    }
}

