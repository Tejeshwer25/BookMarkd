//
//  GenrePreferencesScreen.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 21/02/26.
//

import SwiftUI

enum BookGenre: String, CaseIterable, Identifiable {
    case literaryFiction = "Literary Fiction"
    case contemporaryFiction = "Contemporary Fiction"
    case fantasy = "Fantasy"
    case scienceFiction = "Science Fiction"
    case romance = "Romance"
    case mystery = "Mystery"
    case thriller = "Thriller"
    case historicalFiction = "Historical Fiction"
    case horror = "Horror"
    
    case biographyMemoir = "Biography & Memoir"
    case selfHelp = "Self-Help"
    case psychology = "Psychology"
    case philosophy = "Philosophy"
    case businessFinance = "Business & Finance"
    case history = "History"
    case science = "Science"
    
    case youngAdult = "Young Adult"
    case classics = "Classics"
    case personalDevelopment = "Personal Development"
    case spirituality = "Spirituality"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .literaryFiction:
            return "book.closed"
        case .contemporaryFiction:
            return "text.book.closed"
        case .fantasy:
            return "sparkles"
        case .scienceFiction:
            return "atom"
        case .romance:
            return "heart"
        case .mystery:
            return "magnifyingglass"
        case .thriller:
            return "bolt"
        case .historicalFiction:
            return "clock.arrow.circlepath"
        case .horror:
            return "moon.stars"
        case .biographyMemoir:
            return "person.crop.rectangle"
        case .selfHelp:
            return "figure.mind.and.body"
        case .psychology:
            return "brain.head.profile"
        case .philosophy:
            return "lightbulb"
        case .businessFinance:
            return "chart.line.uptrend.xyaxis"
        case .history:
            return "scroll"
        case .science:
            return "flask"
        case .youngAdult:
            return "person.2"
        case .classics:
            return "books.vertical"
        case .personalDevelopment:
            return "arrow.up.circle"
        case .spirituality:
            return "leaf"
        }
    }
}

struct GenrePreferencesScreen: View {
    @StateObject private var viewModel: GenrePreferenceViewModel
    
    init(preferenceRepository: any UserPreferenceRepository) {
        self._viewModel = StateObject(wrappedValue: GenrePreferenceViewModel(preferenceRepository: preferenceRepository))
    }
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Refine Your Collection")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.serif)
            Text("Choose the literary worlds you wish to inhabit. \nYour library will evolve to reflect your tastes.")
                .font(.callout)
                .fontDesign(.serif)
                .italic()
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search for your genre...", text: $viewModel.searchedGenre)
            }
            .fontDesign(.serif)
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray)
            }
            .padding(.top, 25)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(self.viewModel.genres) { genre in
                        Button {
                            withAnimation {
                                self.viewModel.toggleGenreSelection(genre: genre)
                            }
                        } label: {
                            VStack(alignment: .center, spacing: 15) {
                                Image(systemName: genre.icon)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                
                                Text(genre.rawValue)
                                    .font(.headline)
                                    .fontDesign(.serif)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(self.viewModel.isGenreSelected(genre: genre) ? Color.secondaryBrand : .clear,
                                            lineWidth: 1)
                                    .fill(Color.secondaryBrand.opacity(0.1))
                            }
                            .padding(.horizontal, 5)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.top, 25)
            }
            .scrollIndicators(.hidden)
            
            Button {
                do {
                    try self.viewModel.saveGenresToStorage()
                } catch {
                    
                }
            } label: {
                Text("Save Changes")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.PRIMARY_BRAND)
                    }
            }
            .opacity(self.viewModel.shouldEnableSaveButton() ? 1 : 0.3)
            .disabled(!self.viewModel.shouldEnableSaveButton())
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .navigationTitle("Genre Preferences")
        .onAppear {
            do {
                try self.viewModel.loadGenresFromStore()
            } catch { }
        }
    }
}
