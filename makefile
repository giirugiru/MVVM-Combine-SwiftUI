generate_project:
	pod install --verbose
	xcodegen generate
	open MVVM-Combine-SwiftUI.xcworkspace
