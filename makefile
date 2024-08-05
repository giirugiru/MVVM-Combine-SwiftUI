generate_project:
	xcodegen generate
	pod install --verbose
	open MVVM-Combine-SwiftUI.xcworkspace
