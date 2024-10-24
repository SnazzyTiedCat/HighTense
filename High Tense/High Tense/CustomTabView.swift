import SwiftUI

struct CustomTabView: View {
	@Environment(\.colorScheme) private var colorScheme
	@Binding var selectedTab: Int
	@Binding var collapseTab: Bool
	
	@State private var tabTapped: Bool = false
	@State private var lastTap = Date()
	@State private var collapseTappedOnce: Bool = false
	var animation: Namespace.ID
	
	private var systemAlternate: Color {
		colorScheme == .dark ? .white : .black
	}
	
	var body: some View {
		ZStack {
			
			if collapseTab {
				
					UnevenRoundedRectangle(cornerRadii: .init(topLeading: 25, topTrailing: 25))
						.fill(RadialGradient(colors: [.gray, .black], center: .center, startRadius: 3, endRadius: 60))
						.stroke(systemAlternate, style: StrokeStyle(lineWidth: 2))
						.offset(y: 2)
						.overlay {
							
							Image(systemName: "arrow.up.left.and.arrow.down.right")
								.font(.system(size: 25))
								.foregroundStyle(.red)
							
						}
						.frame(width: 100, height: 60)
						.ignoresSafeArea()
						.onTapGesture {
							handleCollapseTaps()
						}
				
			} else {
				
				VStack(spacing: 0) {
						UnevenRoundedRectangle(cornerRadii: .init(topLeading: 25, topTrailing: 25))
							.frame(minWidth: 75, maxWidth: 100, minHeight: 40, maxHeight: collapseTappedOnce ? 60 : 40)
							.overlay {
								
								VStack(spacing: 3) {
									
									Image(systemName: "arrow.up.right.and.arrow.down.left")
										.font(.system(size: collapseTappedOnce ? 13 : 20))
										.foregroundStyle(.red)
									
									Text("Collapse")
										.font(.system(size: collapseTappedOnce ? 13 : 1))
										.foregroundStyle(.red)
								}
							}
							.onTapGesture {
								handleCollapseTaps()
							}.sensoryFeedback(.impact(weight: .light), trigger: collapseTab)
					
					RoundedRectangle(cornerRadius: 30)
						.fill(.black)
						.frame(height: 80)
						.overlay {
							
							HStack(spacing: 0) {
								
								TabButton(image: "checklist", selectedColor: Color.planColor, title: "Plan", index: 0, leftCornerRadius: 25, selectedTab: $selectedTab, animation: animation)
								
								TabButton(image: "pencil.and.list.clipboard", selectedColor: Color.executionColor, title: "Execution", index: 1, selectedTab: $selectedTab, animation: animation)
								
								TabButton(image: "person.wave.2.fill", selectedColor: Color.finishedColor, title: "Finished", index: 2, rightCornerRadius: 25, selectedTab: $selectedTab, animation: animation)
								
							}
							.onTapGesture {
								tabTapped.toggle()
							}
							.sensoryFeedback(.impact(weight: .light), trigger: tabTapped)
						}.frame(height: 80)
				}
			}
		}.padding(.horizontal)
	}
	
	private func handleCollapseTaps() {
		lastTap = Date()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
			if Date().timeIntervalSince(lastTap) >= 3 {
				withAnimation(.easeInOut(duration: 0.5)) {
					collapseTappedOnce.toggle()
				}
			}
		}
		
		if collapseTappedOnce {
			
			withAnimation(.easeOut(duration: 0.5)) {
				collapseTab.toggle()
			}
		} else {
			
			withAnimation(.easeOut(duration: 0.3)) {
				collapseTappedOnce.toggle()
			}
		}
	}
}

private struct TabButton: View {
	@Environment(\.colorScheme) private var colorScheme
	
	private var systemAlternate: Color {
		colorScheme == .dark ? .white : .black
	}
	
	var image: String
	var selectedColor: Color
	var title: String
	var index: Int
	var leftCornerRadius: CGFloat = 0
	var rightCornerRadius: CGFloat = 0
	
	@Binding var selectedTab: Int
	var animation: Namespace.ID
	
	var body: some View {
		
		UnevenRoundedRectangle(cornerRadii: .init(topLeading: leftCornerRadius, bottomLeading: leftCornerRadius, bottomTrailing: rightCornerRadius, topTrailing: rightCornerRadius))
			.fill(systemAlternate)
			.overlay {
				VStack(spacing: 8) {
					
					Image(systemName: image)
						.font(.system(size: 23))
						.matchedGeometryEffect(id: image, in: animation)
					
					Text(title)
						.font(.system(size: 12, weight: .semibold, design: .monospaced))
					
				}
			}
			.foregroundStyle(selectedTab == index ? Color(UIColor.systemBackground) : .gray)
			.frame(height: 80)
			.onTapGesture {
				withAnimation(.bouncy) {
					selectedTab = index
				}
			}
		
	}
}
