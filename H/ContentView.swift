import SwiftUI

struct ContentView: View {
    @State private var bodyWeight: String = ""

    var body: some View {
        NavigationView { // إضافة NavigationView
            VStack(alignment: .leading) {
                Spacer()
                Image(systemName: "drop.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 75)
                    .foregroundColor(Color.bluu) // تصحيح اسم اللون
                    .font(.system(size: 40))
                    .padding(.top)
                    .padding(10)
                
                Text("Hydrate")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(-20)
                    .padding(30)
                    .padding(10)
                
                Text("Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated.")
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.leading,10)
                    .padding(.vertical,10)
                    
            
                HStack {
                    Spacer()
                    TextField(" Body weight Value", text: $bodyWeight)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        .padding(.trailing)
                }
                .padding(.all, 15.0)
                Spacer()
                
                NavigationLink(destination: NotificationPreferencesView()) {
                    Text("Next")
                        .foregroundStyle(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.bluu) // تصحيح اسم اللون
                        .cornerRadius(15)
                }
                .padding()
            }
            .padding(15)
        } // غلق NavigationView
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
