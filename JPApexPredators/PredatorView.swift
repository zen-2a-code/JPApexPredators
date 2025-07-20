//
//  PredatorView.swift
//  JPApexPredators
//
//  Created by Stoyan Hristov on 29.06.25.
//

import SwiftUI
import MapKit

struct PredatorView: View {
    var allPredators = Predators()
    @State var isSateliteViewActive = false
    @State var position: MapCameraPosition
    
    var body: some View {   
        Map(position: $position) {
            ForEach (allPredators.allApexPredators) {
                predator in
                
                Annotation(predator.name, coordinate: predator.location) {
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .shadow(color: .white, radius: 3)
                        .scaleEffect(x: -1)
                }
            }
        }
        .mapStyle(isSateliteViewActive ?  .imagery(elevation: .realistic)
                  : .standard(elevation: .realistic))
        .overlay (alignment: .bottomTrailing) {
            Button {
                isSateliteViewActive.toggle()
            } label: {
                Image(systemName: isSateliteViewActive ? "globe.americas.fill" : "globe.americas")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .padding(3)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 3))
                    .padding()
            }
        }
        .toolbarBackground(.automatic)
    }
}

#Preview {
    PredatorView(position: .camera(MapCamera(
        centerCoordinate: Predators().apexPredators[2].location,
        distance: 1000,
        heading: 250,
        pitch: 80)))
    .preferredColorScheme(.dark)
}
