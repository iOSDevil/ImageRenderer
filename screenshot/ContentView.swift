	//
	//  ContentView.swift
	//  screenshot
	//

import SwiftUI

struct helloWorldView: View {
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)
			Text("Hello, world!")
		}
	}
}

	/// A struct that holds png image data.
struct PNG {
	private let data: Data
	
	init(_ data: Data) {
		self.data = data
	}
}

	// Transferable conformance, providing a DataRepresentation for ImageData.
@available(iOS 16.0, *)
extension PNG: Transferable {
	
	static var transferRepresentation: some TransferRepresentation {
		
		DataRepresentation<PNG>(contentType: .png) { imageData in
			imageData.data
		} importing: { data in
			PNG(data)
		}
	}
}

struct ContentView: View {
	@State private var screenshotimage: UIImage?
	@State private var screenshot: Bool = false
	@State private var showsharesheet: Bool = false
	@State private var sharescreenshot: Bool = false
	@State private var imageToShare: Image?
	
	var body: some View {
		NavigationStack {
			helloWorldView()
				.padding()
				.toolbar {
					ToolbarItem(placement: .automatic) {
						Button("Share") {
							showsharesheet.toggle()
						}
					}
				}
				.sheet(isPresented: self.$showsharesheet) {
					NavigationStack {
						ScrollView {
							Section {
								if screenshotimage != nil {
									Image(uiImage: screenshotimage!)
									
									let photo = PNG((screenshotimage?.pngData())!) // create transferable 'image'
																				   //									let photo: Photo = Photo(image: Image(uiImage: screenshotimage!), caption: "test") // first attempt, results in low quality
									
									ShareLink(
										item: photo,
										preview: SharePreview(
											"Share Title",
											image: photo
										)
									) {
										Label("Share Image", systemImage: "square.and.arrow.up")
											.foregroundColor(.white)
											.padding()
											.background(.blue.gradient.shadow(.drop(radius: 1, x: 2, y: 2)), in: RoundedRectangle(cornerRadius: 5))
									}
								} else {
									Text("Creating image..")
								}
							}
						}
						.toolbar {
							ToolbarItem(placement: .automatic) {
								Button("Dismiss") {
									showsharesheet = false
								}
							}
						}
						.navigationTitle("Preview")
						.navigationBarTitleDisplayMode(.inline)
					}
					.presentationDetents([.medium, .large])
					.onAppear() {
						screenshot.toggle()
					}
					.onChange(of: screenshot, perform: { _ in
						Task {
							let renderer =  ImageRenderer(content:helloWorldView())
							renderer.scale = UIScreen.main.scale
							screenshotimage = renderer.uiImage
						}
					})
				}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
