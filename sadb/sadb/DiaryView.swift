import SwiftUI

struct DiaryView: View {
    @State private var selectedDate = Date()
    @State private var diaryEntries: [String: [String]] = [:]
    @State private var showingSheet = false
    @State private var entryToEdit: String? = nil
    @State private var cigarettesSmokedDiary: Int = 0
    @StateObject private var diaryModel = DiaryViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                // Top header
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
                
                // Total Cigarettes Smoked
                Text("Totale sigarette fumate: \(cigarettesSmokedDiary)")
                    .font(.title2)
                    .padding(.vertical, 10)
                
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
                .padding([.horizontal, .bottom], 20)
                .disabled(isFutureDate(selectedDate))
                .sheet(isPresented: $showingSheet) {
                    DiaryEntryView(entry: entryToEdit ?? "", saveAction: { newEntry, smoked, cigarettes, date in
                        if entryToEdit == nil {
                            addEntry(newEntry, smoked, cigarettes)
                        } else {
                            updateEntry(newEntry, smoked, cigarettes)
                        }
                        saveDiaryEntries()
                        showingSheet = false
                    }, selectedDate: selectedDate)
                }
                
            }
        }
        .background(Color.green.opacity(0.1))
        .onAppear {
            loadDiaryEntries()
        }
    }
    
    // Formatting date functions
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
    
    // Load and save functions
    func saveDiaryEntries() {
        let data = try? JSONEncoder().encode(diaryEntries)
        UserDefaults.standard.setValue(data, forKey: "diaryEntries")
        UserDefaults.standard.setValue(cigarettesSmokedDiary, forKey: "cigarettesSmokedDiary")
    }
    
    func loadDiaryEntries() {
        if let data = UserDefaults.standard.data(forKey: "diaryEntries"),
           let savedEntries = try? JSONDecoder().decode([String: [String]].self, from: data) {
            diaryEntries = savedEntries
        }
        cigarettesSmokedDiary = UserDefaults.standard.integer(forKey: "cigarettesSmokedDiary")
    }
    
    func isFutureDate(_ date: Date) -> Bool {
        return date > Date()
    }
    
    // Entry functions
    func addEntry(_ newEntry: String, _ smoked: Bool, _ cigarettes: String) {
        let dateKey = formattedDate(selectedDate)
        if diaryEntries[dateKey] == nil {
            diaryEntries[dateKey] = []
        }
        var fullEntry = newEntry
        if smoked {
            fullEntry += "\nHai fumato oggi: Sì\nQuante sigarette: \(cigarettes)"
            cigarettesSmokedDiary += Int(cigarettes) ?? 0
        } else {
            fullEntry += "\nHai fumato oggi: No"
        }
        diaryEntries[dateKey]?.append(fullEntry)
    }
    
    func updateEntry(_ updatedEntry: String, _ smoked: Bool, _ cigarettes: String) {
        let dateKey = formattedDate(selectedDate)
        guard let entries = diaryEntries[dateKey], let index = entries.firstIndex(of: entryToEdit!) else { return }

        // Extract the old cigarette count and update the diary entries
        if let oldEntryCigarettes = extractCigaretteCount(from: entries[index]) {
            cigarettesSmokedDiary -= oldEntryCigarettes
        }
        
        // Prepare the new entry
        var fullEntry = updatedEntry
        let newCigarettesSmoked = Int(cigarettes) ?? 0
        if smoked {
            fullEntry += "\nHai fumato oggi: Sì\nQuante sigarette: \(newCigarettesSmoked)"
        } else {
            fullEntry += "\nHai fumato oggi: No"
        }

        // Update the local entries and the total count
        diaryEntries[dateKey]?[index] = fullEntry
        cigarettesSmokedDiary += newCigarettesSmoked
        
        // Update the database with the new value
        diaryModel.updateDiaryEntry(for: selectedDate, newCigarettesSmoked: newCigarettesSmoked) { success in
            if success {
                print("Entry successfully updated in database")
            } else {
                print("Failed to update entry in database")
            }
        }
    }

    func deleteEntry(_ entry: String) {
        let dateKey = formattedDate(selectedDate)
        guard let entries = diaryEntries[dateKey] else { return }
        if let index = entries.firstIndex(of: entry) {
            // Extract the number of cigarettes from the entry
            let cigarettesSmoked = extractCigaretteCount(from: entries[index]) ?? 0
            
            // Update local data
            diaryEntries[dateKey]?.remove(at: index)
            if diaryEntries[dateKey]?.isEmpty == true {
                diaryEntries.removeValue(forKey: dateKey)
            }
            
            // Update the total cigarettes count
            cigarettesSmokedDiary -= cigarettesSmoked
            
            // Save the updated entries to local storage
            saveDiaryEntries()
            
            // Remove the entry from the database
            diaryModel.deleteDiaryEntry(for: selectedDate, cigarettesSmoked: cigarettesSmoked) { success in
                if success {
                    print("Entry successfully deleted from database")
                } else {
                    print("Failed to delete entry from database")
                }
            }
        }
    }

    func extractCigaretteCount(from entry: String) -> Int? {
        let pattern = "Quante sigarette: (\\d+)"
        if let range = entry.range(of: pattern, options: .regularExpression),
           let match = entry[range].split(separator: " ").last {
            return Int(match)
        }
        return nil
    }
}
struct DiaryEntryView: View {
    @State var entry: String
    @State private var smokedToday: Bool = false
    @State private var cigarettesSmoked: String = "0"
    @State private var showAlert: Bool = false
    
    var saveAction: (String, Bool, String, Date) -> Void
    @StateObject private var diaryModel = DiaryViewModel()
    var selectedDate: Date

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
                VStack(alignment: .leading) {
                    Text("Quante sigarette hai fumato oggi?")
                        .padding(.bottom, 2)
                    
                    TextField("", text: $cigarettesSmoked)
                        .padding()
                        .border(Color.gray, width: 1)
                        .keyboardType(.numberPad)
                        .onTapGesture {
                            // Svuota il campo se contiene ancora lo 0
                            if cigarettesSmoked == "0" {
                                cigarettesSmoked = ""
                            }
                        }
                        .onChange(of: cigarettesSmoked) { newValue in
                            if !newValue.isEmpty && Int(newValue) == nil {
                                showAlert = true
                                cigarettesSmoked = newValue.filter { $0.isNumber }
                            }
                        }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            VStack(alignment: .leading) {
                            Text("Inserisci qui la tua annotazione...")
                                .padding(.bottom, 2)
                TextEditor(text: $entry)
                    .padding(.horizontal)
                    .border(Color.gray, width: 2)
                    .frame(height: 200)
                            
                        }
                        .padding(.horizontal)
            
            Button(action: {
                // Pass the selected date along with other values
                saveAction(entry, smokedToday, cigarettesSmoked, selectedDate)
                if let numCigarettes = Int(cigarettesSmoked) {
                    diaryModel.pushNewValue(currentDate: selectedDate, cigSmokedToday: numCigarettes)
                }
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
        .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Errore"),
                        message: Text("Per favore, inserisci solo numeri nel campo delle sigarette fumate."),
                        dismissButton: .default(Text("OK"))
                    )
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

