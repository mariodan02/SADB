import SwiftUI

struct diaryView: View {
    @State private var selectedDate = Date()
    @State private var diaryEntries: [String: String] = [:]
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            // Top header
            HStack {
                Spacer()
                Text("Diario / Percorso")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.top, 50)
            
            // Calendar View
            CalendarView(selectedDate: $selectedDate, diaryEntries: $diaryEntries)
                .padding(.vertical, 20)
            
            // Display Diary Entries
            ScrollView {
                Text(diaryEntries[formattedDate(selectedDate)] ?? "Nessuna annotazione per questo giorno.")
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .border(Color.gray, width: 1)
            }
            .frame(height: 200)
            .padding(.horizontal, 20)
            
            Button(action: {
                showingSheet = true
            }) {
                Text("Aggiungi una nuova annotazione")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showingSheet) {
                DiaryEntryView(entry: "", saveAction: { newEntry in
                    diaryEntries[formattedDate(selectedDate)] = newEntry
                    saveDiaryEntries()
                    showingSheet = false
                })
            }
            
            // Previous Entries List
            List {
                ForEach(diaryEntries.keys.sorted(by: >), id: \.self) { key in
                    HStack {
                        Text(key)
                            .fontWeight(.bold)
                        Spacer()
                        Text(diaryEntries[key] ?? "")
                    }
                    .padding(.vertical, 5)
                    .onTapGesture {
                        selectedDate = dateFromString(key)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Custom tab bar
            CustomTabBar()
        }
        .onAppear {
            loadDiaryEntries()
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func dateFromString(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.date(from: dateString) ?? Date()
    }
    
    func saveDiaryEntries() {
        UserDefaults.standard.setValue(diaryEntries, forKey: "diaryEntries")
    }
    
    func loadDiaryEntries() {
        if let savedEntries = UserDefaults.standard.dictionary(forKey: "diaryEntries") as? [String: String] {
            diaryEntries = savedEntries
        }
    }
}

struct DiaryEntryView: View {
    @State var entry: String
    var saveAction: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Scrivi la tua annotazione")
                .font(.title)
                .padding()
            
            TextEditor(text: $entry)
                .padding()
                .border(Color.gray, width: 1)
                .frame(height: 200)
            
            Button(action: {
                saveAction(entry)
            }) {
                Text("Salva")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var diaryEntries: [String: String]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<daysInMonth(), id: \.self) { day in
                VStack {
                    Text("\(day + 1)")
                        .padding()
                        .background(Calendar.current.isDate(selectedDate, equalTo: dateFor(day), toGranularity: .day) ? Color.blue : Color.clear)
                        .cornerRadius(5)
                        .onTapGesture {
                            selectedDate = dateFor(day)
                        }
                    
                    if hasEntry(for: dateFor(day)) {
                        Circle()
                            .fill(randomColor())
                            .frame(width: 8, height: 8)
                            .padding(.top, 4)
                    }
                }
            }
        }
        .padding()
    }
    
    func daysInMonth() -> Int {
        let range = Calendar.current.range(of: .day, in: .month, for: Date())
        return range?.count ?? 0
    }
    
    func dateFor(_ day: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: Date())
        components.day = day + 1
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func hasEntry(for date: Date) -> Bool {
        return diaryEntries[formattedDate(date)] != nil
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func randomColor() -> Color {
        let colors: [Color] = [.red, .green, .blue, .yellow, .purple, .orange]
        return colors.randomElement() ?? .black
    }
}

struct CustomTabBar: View {
    var body: some View {
        HStack {
            Button(action: {
                // Azione per il tab "Diario"
                print("Diario tab clicked")
            }) {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Diario")
                }
                .padding()
                .foregroundColor(.green)
            }
            Spacer()
            Button(action: {
                // Azione per il tab "Il mio albero"
                print("Il mio albero tab clicked")
            }) {
                VStack {
                    Image(systemName: "leaf")
                    Text("Il mio albero")
                }
                .padding()
                .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {
                // Azione per il tab "Progressi"
                print("Progressi tab clicked")
            }) {
                VStack {
                    Image(systemName: "sparkles")
                    Text("Progressi")
                }
                .padding()
                .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
        .background(Color.white.shadow(radius: 2))
    }
}

#Preview {
    diaryView()
}
