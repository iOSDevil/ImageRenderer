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
									ShareLink(
										item: Image(uiImage: screenshotimage!),
										preview: SharePreview(
											"Share Title",
											image: Image(uiImage: screenshotimage!)
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
								//						renderer.scale = 3.0
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
