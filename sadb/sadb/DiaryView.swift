import SwiftUI

struct DiaryView: View {
    @State private var selectedDate = Date()
    @State private var diaryEntries: [String: [String]] = [:]
    @State private var showingSheet = false
    @State private var entryToEdit: String? = nil
    
    // New AppStorage variable for cigarettes data
    @AppStorage("cigarettesData") private var cigarettesDataJSON: String = "{}"
    
    @State private var cigarettesData: [String: String] = [:]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Il mio diario")
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
                        VStack(alignment: .leading) {
                            Text(entry)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .border(Color.gray, width: 1)
                            
                            HStack {
                                Button(action: {
                                    entryToEdit = entry
                                    showingSheet = true
                                }) {
                                    Text("Modifica")
                                        .foregroundColor(.blue)
                                }
                                .padding(.leading)
                                
                                Button(action: {
                                    deleteEntry(entry)
                                }) {
                                    Text("Elimina")
                                        .foregroundColor(.red)
                                }
                                .padding(.leading)
                            }
                        }
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
                entryToEdit = nil
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
                DiaryEntryView(entry: entryToEdit ?? "", saveAction: { newEntry, smoked, cigarettes in
                    if entryToEdit == nil {
                        addEntry(newEntry, smoked, cigarettes)
                    } else {
                        updateEntry(newEntry, smoked, cigarettes)
                    }
                    saveDiaryEntries()
                    showingSheet = false
                })
            }
                        
        }
        .background(Color.green.opacity(0.1))
        .onAppear {
            loadDiaryEntries()
            loadCigarettesData()
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
    
    func addEntry(_ newEntry: String, _ smoked: Bool, _ cigarettes: String) {
        let dateKey = formattedDate(selectedDate)
        if diaryEntries[dateKey] == nil {
            diaryEntries[dateKey] = []
        }
        var fullEntry = newEntry
        if smoked {
            fullEntry += "\nHai fumato oggi: Sì\nQuante sigarette: \(cigarettes)"
            cigarettesData[dateKey] = cigarettes
        } else {
            fullEntry += "\nHai fumato oggi: No"
            cigarettesData[dateKey] = "0"
        }
        diaryEntries[dateKey]?.append(fullEntry)
        saveCigarettesData()
    }
    
    func updateEntry(_ updatedEntry: String, _ smoked: Bool, _ cigarettes: String) {
        let dateKey = formattedDate(selectedDate)
        guard let entries = diaryEntries[dateKey] else { return }
        if let index = entries.firstIndex(of: entryToEdit!) {
            var fullEntry = updatedEntry
            if smoked {
                fullEntry += "\nHai fumato oggi: Sì\nQuante sigarette: \(cigarettes)"
                cigarettesData[dateKey] = cigarettes
            } else {
                fullEntry += "\nHai fumato oggi: No"
                cigarettesData[dateKey] = "0"
            }
            diaryEntries[dateKey]?[index] = fullEntry
            saveCigarettesData()
        }
    }
    
    func deleteEntry(_ entry: String) {
        let dateKey = formattedDate(selectedDate)
        guard let entries = diaryEntries[dateKey] else { return }
        if let index = entries.firstIndex(of: entry) {
            diaryEntries[dateKey]?.remove(at: index)
            cigarettesData[dateKey] = nil
            saveDiaryEntries()
            saveCigarettesData()
        }
    }
    
    func saveCigarettesData() {
        let data = try? JSONEncoder().encode(cigarettesData)
        cigarettesDataJSON = String(data: data!, encoding: .utf8) ?? "{}"
    }
    
    func loadCigarettesData() {
        if let data = cigarettesDataJSON.data(using: .utf8),
           let savedData = try? JSONDecoder().decode([String: String].self, from: data) {
            cigarettesData = savedData
        }
    }
}

struct DiaryEntryView: View {
    @State var entry: String
    @State private var smokedToday: Bool = false
    @State private var cigarettesSmoked: String = ""
    var saveAction: (String, Bool, String) -> Void
    
    var body: some View {
        
        Text("Scrivi la tua annotazione")
            .font(.title)
            .padding()

        VStack {
            Toggle(isOn: $smokedToday) {
                Text("Hai fumato oggi?")
            }
            .padding()
            
            if smokedToday {
                TextField("Quante sigarette hai fumato oggi?", text: $cigarettesSmoked)
                    .padding()
                    .border(Color.gray, width: 1)
                    .keyboardType(.numberPad)
                    .onChange(of: cigarettesSmoked) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            cigarettesSmoked = filtered
                        }
                    }
            }

            
            TextEditor(text: $entry)
                .padding()
                .border(Color.gray, width: 2)
                .frame(height: 200)
            Button(action: {
                saveAction(entry, smokedToday, cigarettesSmoked)
            }) {
                Text("Salva")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
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
        let dateKey = formattedDate(date)
        return diaryEntries[dateKey]?.isEmpty == false
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

