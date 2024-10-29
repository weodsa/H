import SwiftUI

// MARK: - Model
struct WaterIntake {
    var intake: Double = 0.0
    var goal: Double = 2.7
}

// MARK: - ViewModel
class WaterIntakeViewModel: ObservableObject {
    @Published var waterData = WaterIntake()
    
    @AppStorage("waterIntake") private var storedIntake: Double = 0.0
    @AppStorage("goal") private var storedGoal: Double = 2.7

    init() {
        waterData.intake = storedIntake
        waterData.goal = storedGoal
    }
    
    var imageName: String {
        switch waterData.intake {
        case 0:
            return "zzz"
        case 1.0..<1.5:
            return "tortoise.fill"
        case 1.5..<waterData.goal:
            return "hare.fill"
        case waterData.goal:
            return "hands.clap.fill"
        default:
            return "zzz"
        }
    }
    
    var progressColor: Color {
        waterData.intake >= waterData.goal ? .bluu : .bluu
    }
    
    func updateWaterIntake(by amount: Double) {
        waterData.intake = min(waterData.intake + amount, waterData.goal)
        storedIntake = waterData.intake
    }
}

// MARK: - View
struct WaterIntakeView: View {
    @StateObject private var viewModel = WaterIntakeViewModel()
    
    var body: some View {
        VStack {
            Text("Today's Water Intake")
                .font(.body)
                .foregroundStyle(.gray)
                .padding(.top, -80)
                .padding(.leading,-170)
            Text("\(String(format: "%.1f", viewModel.waterData.intake)) liter / \(viewModel.waterData.goal, specifier: "%.1f") liter")
                .font(.title2)
                .bold()
                .padding(.top, -70)
                .padding(.leading,-170)
            ZStack {
                Circle()
                    .stroke(lineWidth: 30)
                    .foregroundColor(Color(.systemGray6))
                    .frame(width: 270, height: 270)
                    
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(viewModel.waterData.intake / viewModel.waterData.goal, 1.0)))
                    .stroke(viewModel.progressColor, style: StrokeStyle(lineWidth: 30, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 270, height: 270)
                    .animation(.linear, value: viewModel.waterData.intake)
                
                Image(systemName: viewModel.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color.yellow)
            }
            .padding()
            
            VStack {
                Text("\(String(format: "%.1f", viewModel.waterData.intake)) L")
                    .font(.title3)
                    .fontWeight(.bold)
                    .frame(height: 150)
                    .padding(.bottom,-70)
                Stepper("", onIncrement: {
                    viewModel.updateWaterIntake(by: 0.675)
                }, onDecrement: {
                    viewModel.updateWaterIntake(by: -0.675)
                })
                .labelsHidden()
                .padding()
            }
        }
        .padding()
    }
}

#Preview {
    WaterIntakeView()
}
