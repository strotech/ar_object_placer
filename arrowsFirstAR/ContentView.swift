//Created by me on 11/10/20

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct ContentView : View {
    @State private var isPlacementEnabled = false
    @State private var selectedModel:Model?
    @State private var modelConfirmedForPlacement:Model?
    
    private var models:[Model] = {
        let fileManager=FileManager.default
        guard let path=Bundle.main.resourcePath,let files = try? fileManager.contentsOfDirectory(atPath: path) else {
            return []
        }
        var availableModels:[Model] = []
        for fileName in files where fileName.hasSuffix("usdz"){
            var availableModelName=fileName.replacingOccurrences(of: ".usdz", with: "")
            let model=Model(modelName: availableModelName)
            availableModels.append(model)
        }
        return availableModels
    }()
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(modelSelectedForPlacement: self.$modelConfirmedForPlacement)
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, modelSelectedForPlacement: self.$modelConfirmedForPlacement)
            } else {
                ModelPickerView(isPlacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectedModel, models:self.models)
            }
            
            
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelSelectedForPlacement:Model?
    
    func makeUIView(context: Context) -> ARView {
        
//        let arView = ARView(frame: .zero)
        
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection=[.horizontal,.vertical]
//        config.environmentTexturing = .automatic
//        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
//            config.sceneReconstruction = .mesh
//        }
//        arView.session.run(config)
        
        let arView = FocusARView(frame: .zero)

        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model=self.modelSelectedForPlacement {
            
            if let modelEntity = model.modelEntity {
                print("DEBUG : MODEL SELECTED FOR PLACEMENT : \(model.modelName)")
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                uiView.scene.addAnchor(anchorEntity)
            } else {
                print("DEBUG : MODEL SELECTED FOR PLACEMENT : \(model.modelName)")
            }
            DispatchQueue.main.async {
                self.modelSelectedForPlacement = nil
            }
            
        }
    }
    
}



struct ModelPickerView: View{
    @Binding var isPlacementEnabled:Bool
    @Binding var selectedModel:Model?
    
    var models:[Model]
    
    var body: some View {
        ScrollView(.horizontal,showsIndicators:false) {
            HStack(spacing:30){
                ForEach(0..<self.models.count){
                    index in
                    Button(action: {
                        print("DEBUG: selected model with name \(self.models[index].modelName)")
                        self.selectedModel=self.models[index]
                        self.isPlacementEnabled = true
                    }){
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height:80)
                            .aspectRatio(1/1,contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}

struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selectedModel:Model?
    @Binding var modelSelectedForPlacement:Model?
    var body: some View {
        HStack{
            Button(action:{
                print("DEBUG:Cancel")
                self.resetPlacementParameters()
            }){
                Image(systemName: "xmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            Button(action:{
                print("DEBUG:Confirm")
                self.modelSelectedForPlacement=self.selectedModel
                self.resetPlacementParameters()
            }){
                Image(systemName: "checkmark")
                    .frame(width: 60, height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    func resetPlacementParameters() {
        self.isPlacementEnabled = false
        self.selectedModel = nil
    }
}


#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
