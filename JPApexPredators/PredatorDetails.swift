//
//  PredatorDetails.swift
//  JPApexPredators
//
//  Created by Stoyan Hristov on 23.06.25.
//

import SwiftUI
import MapKit

struct PredatorDetails: View {
    var predator: ApexPredator
    @State var position: MapCameraPosition
    @Namespace var namespace
    
    var body: some View {
        GeometryReader {geo in
            ScrollView {
                ZStack (alignment: .bottomTrailing) {
                    // background image
                    Image(predator.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .overlay{
                            LinearGradient(stops: [Gradient.Stop(color: .clear, location: 0.9), Gradient.Stop(color: .black, location: 1)], startPoint: .top, endPoint: .bottom)
                        }
                    NavigationLink {
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(x: -1)
                            
                        
                    } label: {
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width / 1.5, height: geo.size.height / 3.7)
                            .scaleEffect(x: -1)
                            .shadow(color: .black, radius: 7)
                            .offset(y: 20)
                    }
                }
                
                // Dino Name
                VStack (alignment: .leading){
                    Text(predator.name)
                        .font(.largeTitle)
                    
                    // Current location Apple Maps integration
                    NavigationLink{
                        PredatorView(position: .camera(MapCamera(
                            centerCoordinate: predator.location,
                            distance: 1000,
                            heading: 250,
                            pitch: 80)))
                        .navigationTransition(.zoom(sourceID: 1, in: namespace))
                        
                    } label: {
                        Map(position: $position) {
                            Annotation(predator.name, coordinate: predator.location) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .symbolEffect(.pulse)
                            }
                            .annotationTitles(.hidden)
                        }
                        .frame(height: 125)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "greaterthan")
                                .imageScale(.large)
                                .font(.title3)
                        }
                        .overlay(alignment: .topLeading) {
                            Text("Current location")
                                .padding([.leading, .bottom], 5)
                                .padding(.trailing, 8)
                                .background(.black.opacity(0.33))
                                .clipShape(.rect(bottomTrailingRadius: 15))
                        }
                        .clipShape(.rect(cornerRadius: 15))
                    }.matchedTransitionSource(id: 1, in: namespace)
                    
                    // Apears in
                    Text("Appears In:")
                        .font(.title3)
                        .padding(.top, 15)
                    
                    ForEach(predator.movies, id: \.self) { movie in
                        Text("•" + movie)
                            .font(.subheadline)
                        
                    }
                    // Movie moments
                    Text("Movie Moments: ")
                        .font(.title)
                        .padding(.top, 15)
                    ForEach(predator.movieScenes) {scene in
                        Text(scene.movie)
                            .font(.title2)
                            .padding(.vertical, 1)
                        
                        Text(scene.sceneDescription)
                            .padding(.bottom, 15)
                    }
                    
                    // Link to page
                    // Link to webpage
                    Text ("Read More:")
                        .font(.caption)
                    
                    Link(predator.link, destination: URL(string: predator.link)!)
                        .font(.caption)
                        .foregroundStyle(Color.blue)
                }
                .padding()
                .padding(.bottom, 10)
                .frame(width: geo.size.width, alignment: .leading)
                .toolbarBackground(.automatic)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    let predator = Predators().allApexPredators[2]
    NavigationStack {
        PredatorDetails(predator:  predator, position:  .camera(
            MapCamera(centerCoordinate: predator.location, distance: 30000
                     )))
            .preferredColorScheme(.dark)
    }
}
