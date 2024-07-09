import SwiftUI

struct DiaryView: View {
    @State private var selectedDate = Date()
    @State private var diaryEntries: [String: [String]] = [:]
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
            
            // Month Navigation
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: selectedDate) ?? Date()
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                Text(monthYearString(from: selectedDate))
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .month, value: 1, to: selectedDate) ?? Date()
                }) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal, 20)
            
            // Calendar View
            CalendarView(selectedDate: $selectedDate, diaryEntries: $diaryEntries)
            
            // Display Diary Entries
            ScrollView {
                if let entries = diaryEntries[formattedDate(selectedDate)], !entries.isEmpty {
                    ForEach(entries, id: \.self) { entry in
                        Text(entry)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .border(Color.gray, width: 1)
                    }
                } else {
                    Text("Nessuna annotazione per questo giorno.")
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color.gray, width: 1)
                }
            }
            .frame(height: 250)
            .padding(.horizontal, 20)
            
            Button(action: {
                showingSheet = true
            }) {
                Text("Aggiungi una nuova annotazione")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFutureDate(selectedDate) ? Color.gray : Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            .disabled(isFutureDate(selectedDate))
            .sheet(isPresented: $showingSheet) {
                DiaryEntryView(entry: "", saveAction: { newEntry in
                    if diaryEntries[formattedDate(selectedDate)] == nil {
                        diaryEntries[formattedDate(selectedDate)] = []
                    }
                    diaryEntries[formattedDate(selectedDate)]?.append(newEntry)
                    saveDiaryEntries()
                    showingSheet = false
                })
            }
                        
        }
        .background(Color.green.opacity(0.1))
        .onAppear {
            loadDiaryEntries()
        }
        .tabItem {
            Label("Diario", systemImage: "list.bullet")
        }
            .tag(0)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func saveDiaryEntries() {
        let data = try? JSONEncoder().encode(diaryEntries)
        UserDefaults.standard.setValue(data, forKey: "diaryEntries")
    }
    
    func loadDiaryEntries() {
        if let data = UserDefaults.standard.data(forKey: "diaryEntries"),
           let savedEntries = try? JSONDecoder().decode([String: [String]].self, from: data) {
            diaryEntries = savedEntries
        }
    }
    
    func isFutureDate(_ date: Date) -> Bool {
        return date > Date()
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
    }
}

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Binding var diaryEntries: [String: [String]]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 7)
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<daysInMonth(), id: \.self) { day in
                VStack {
                    Text("\(day + 1)")
                        .padding(10)
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
        let range = Calendar.current.range(of: .day, in: .month, for: selectedDate)
        return range?.count ?? 0
    }
    
    func dateFor(_ day: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
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

#Preview {
    DiaryView()
}


