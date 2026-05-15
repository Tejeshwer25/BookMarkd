import SwiftUI
import UIKit

struct CameraCaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var camera = CameraManager()
    
    let onImageCaptured: (UIImage) -> Void
    
    var body: some View {
        VStack {
            CameraPreviewView(session: camera.session)
                .frame(maxWidth: .infinity, minHeight: 650)
                .clipShape(.containerRelative)
                .padding()
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .frame(width: 80, height: 80)
                        .glassEffect()
                }
                
                Spacer()
                
                Button {
                    camera.capturePhoto()
                } label: {
                    Circle()
                        .fill(.white)
                        .frame(width: 80, height: 80)
                        .overlay {
                            Circle()
                                .stroke(.black, lineWidth: 2)
                        }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 50)
        }
        .onAppear {
            camera.startSession()
        }
        .onDisappear {
            camera.stopSession()
        }
        .onChange(of: camera.capturedImage) { old, new in
            guard let new else { return }
            
            onImageCaptured(new)
            dismiss()
        }
    }
}

