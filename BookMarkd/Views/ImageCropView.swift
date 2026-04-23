//
//  ImageCropView.swift
//  BookMarkd
//
//  Created by Tejeshwer Singh on 23/04/26.
//

import SwiftUI
import AVFoundation

struct ImageCropView: View {
    let original: UIImage
    let aspectRatio: CGSize // e.g., CGSize(width: 3, height: 4) for book cover
    let onCancel: () -> Void
    let onCropped: (UIImage) -> Void

    @State private var scale: CGFloat = 1
    @State private var offset: CGSize = .zero

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black.ignoresSafeArea()

                // Crop box
                let cropRect = cropFrame(in: geo.size, aspectRatio: aspectRatio)

                // Image under crop box with pinch/zoom/pan
                ZoomableImage(image: Image(uiImage: original),
                              scale: $scale,
                              offset: $offset)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()

                // Dimmed overlay except crop area
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .mask(
                        CropMask(cropRect: cropRect)
                            .fill(style: FillStyle(eoFill: true))
                    )
                    .allowsHitTesting(false)

                // Crop border
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: cropRect.width, height: cropRect.height)
                    .position(x: cropRect.midX, y: cropRect.midY)

                // Controls
                VStack {
                    Spacer()
                    HStack {
                        Button("Cancel", action: onCancel)
                            .foregroundStyle(.white)

                        Spacer()

                        Button("Use Photo") {
                            let cropped = renderCroppedImage(from: original,
                                                             in: geo.size,
                                                             cropRect: cropRect,
                                                             scale: scale,
                                                             offset: offset)
                            onCropped(cropped)
                        }
                        .foregroundStyle(.white)
                    }
                    .padding()
                }
            }
        }
    }

    private func cropFrame(in container: CGSize, aspectRatio: CGSize) -> CGRect {
        // Centered crop rect with target aspect ratio, fitting within the container
        let containerAR = container.width / container.height
        let targetAR = aspectRatio.width / aspectRatio.height

        let width: CGFloat
        let height: CGFloat
        if containerAR > targetAR {
            // container is wider; limit by height
            height = container.height * 0.7
            width = height * targetAR
        } else {
            // container is taller; limit by width
            width = container.width * 0.9
            height = width / targetAR
        }

        let origin = CGPoint(x: (container.width - width) / 2,
                             y: (container.height - height) / 2)
        return CGRect(origin: origin, size: CGSize(width: width, height: height))
    }

    private func renderCroppedImage(from image: UIImage,
                                    in container: CGSize,
                                    cropRect: CGRect,
                                    scale: CGFloat,
                                    offset: CGSize) -> UIImage {
        // Convert crop rect from view space to image space, considering zoom/pan
        // First, compute how the image is laid out in the container at current transform
        let imageSize = image.size
        let fittedRect = AVMakeRect(aspectRatio: imageSize, insideRect: CGRect(origin: .zero, size: container))

        // Apply user transforms relative to the fitted rect
        // Effective image frame on screen:
        let transformedOrigin = CGPoint(
            x: fittedRect.origin.x + offset.width,
            y: fittedRect.origin.y + offset.height
        )
        let transformedSize = CGSize(
            width: fittedRect.size.width * scale,
            height: fittedRect.size.height * scale
        )
        let imageFrame = CGRect(origin: transformedOrigin, size: transformedSize)

        // Map cropRect to image pixel space
        let xRatio = imageSize.width / imageFrame.width
        let yRatio = imageSize.height / imageFrame.height

        let cropInImageSpace = CGRect(
            x: (cropRect.minX - imageFrame.minX) * xRatio,
            y: (cropRect.minY - imageFrame.minY) * yRatio,
            width: cropRect.width * xRatio,
            height: cropRect.height * yRatio
        ).integral

        guard let cgImage = image.cgImage?.cropping(to: cropInImageSpace) else {
            return image
        }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}

// A simple zoom/pan image view
struct ZoomableImage: View {
    let image: Image
    @Binding var scale: CGFloat
    @Binding var offset: CGSize

    @GestureState private var gestureScale: CGFloat = 1
    @GestureState private var gestureOffset: CGSize = .zero

    var body: some View {
        image
            .resizable()
            .scaledToFit()
            .scaleEffect(scale * gestureScale)
            .offset(x: offset.width + gestureOffset.width,
                    y: offset.height + gestureOffset.height)
            .gesture(
                SimultaneousGesture(
                    DragGesture().updating($gestureOffset) { value, state, _ in
                        state = value.translation
                    }.onEnded { value in
                        offset.width += value.translation.width
                        offset.height += value.translation.height
                    },
                    MagnificationGesture().updating($gestureScale) { value, state, _ in
                        state = value
                    }.onEnded { value in
                        scale *= value
                        scale = max(1, min(scale, 5)) // clamp zoom
                    }
                )
            )
    }
}

// Mask that creates a hole at cropRect
struct CropMask: Shape {
    let cropRect: CGRect
    func path(in rect: CGRect) -> Path {
        var p = Path(rect)
        p.addRoundedRect(in: cropRect, cornerSize: CGSize(width: 8, height: 8))
        return p
    }
}
