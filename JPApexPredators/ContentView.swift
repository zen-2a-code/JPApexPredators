//
//  ContentView.swift
//  JPApexPredators
//
//  Created by Stoyan Hristov on 16.06.25.
//

import SwiftUI
import _MapKit_SwiftUI

struct ContentView: View {
    let predators = Predators()

    @State var searchText = ""
    @State var isAlphabeticallyOrdered = false
    @State var currentTypeSelection: APType = .all
    @State var filteredByMovieSelection = "All Movies"
    
//    var filteredDinos: [ApexPredator] {
//        predators.filterByType(by: currentTypeSelection)
//        predators.filterByMovie(by: filteredByMovieSelection)
//        predators.sort(by: isAlphabeticallyOrdered)
//        return predators.search(for: searchText)
//    }
    
    var filteredDinos: [ApexPredator] {
        return predators.filterByType(by: currentTypeSelection)
            .filterByMovie(by: filteredByMovieSelection)
            .sort(by: isAlphabeticallyOrdered)
            .search(for: searchText)
    }
    
    var moviePicker: some View {
        Picker("Filter", selection: $filteredByMovieSelection.animation()) {
            ForEach(predators.allMovies.sorted(), id: \.self) { movie in
                Label(movie, systemImage: "film")
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredDinos) { predator in
                NavigationLink {
                    PredatorDetails(predator: predator, position:
                            .camera(
                                MapCamera(centerCoordinate: predator.location, distance: 30000
                    )))
                } label: {
                    HStack {
                        // Dinosaur image
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .shadow(color: .white, radius: 1)

                        VStack(alignment: .leading) {
                            // name
                            Text(predator.name)
                                .fontWeight(.bold)

                            // type
                            Text(predator.type.rawValue.capitalized)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 13)
                                .padding(.vertical, 5)
                                .background(predator.type.background)
                                .clipShape(.capsule)
                        }
                    }
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            isAlphabeticallyOrdered.toggle()
                        }
                    } label: {
                        Image(
                            systemName: isAlphabeticallyOrdered
                                ? "film" : "textformat"
                        )
                        .symbolEffect(.bounce, value: isAlphabeticallyOrdered)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $currentTypeSelection.animation()) {
                            ForEach(APType.allCases) {
                                type in
                                Label(type.rawValue.capitalized, systemImage: type.icon)
                            }
                        }
                        
                        Menu("Choose a movie") {
                            moviePicker
                        }

                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
