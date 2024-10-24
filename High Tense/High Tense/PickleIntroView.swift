import SwiftUI

struct PickleIntroView: View {
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.dismiss) private var dismiss
	@State private var pickleGradientTap: Bool = false
	
	private var backgroundColor: Color {
		colorScheme == .light ? Color(red: 235/255, green: 235/255, blue: 235/255) : Color(red: 35/255, green: 35/255, blue: 35/255)
	}
	
	private var systemAlternate: Color {
		colorScheme == .dark ? .white : .black
	}
	var body: some View {
		ZStack {
			backgroundColor
				.ignoresSafeArea()
			
			VStack {
				Spacer()
				
				Text("Welcome!")
					.font(.system(size: 35, weight: .bold))
					.padding(.bottom, 15)
				
				VStack {
					Text("This is your study buddy, ") +
					
					Text("Pickle")
						.foregroundStyle(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
						.bold()
						.italic()
					
					+ Text(".\nShe will be here keeping you company and judging as you work.")
					
					+ Text("\nBe careful though, she isn't just any typical cat!")
				}
				.font(.system(size: 21))
				.padding(.horizontal)
				.multilineTextAlignment(.center)
				.lineSpacing(5)
				
				Spacer()
				
				Button(action: gradientTap) {
					ZStack {
						RoundedRectangle(cornerRadius: 25)
							.fill(Color.executionColor)
							.stroke(systemAlternate, style: .init(lineWidth: 3))
						
						Image("HappyPickle")
							.resizable()
							.scaledToFit()
							.padding()
						
						LinearGradient(colors: [Color.blue, Color.purple], startPoint: .topLeading, endPoint: .bottomTrailing)
							.clipShape(RoundedRectangle(cornerRadius: 25))
							.opacity(pickleGradientTap ? 0.8 : 0)
					}
				}
				.frame(width: 250, height: 250)
				.padding()
				
				Spacer()
				
				Button {
					dismiss()
				} label: {
					Circle()
						.fill(systemAlternate)
						.frame(width: 50, height: 50)
						.overlay {
							Image(systemName: "xmark")
								.font(.system(size: 20))
								.foregroundStyle(Color(UIColor.systemBackground))
						}
				}
				Spacer()
			}
			
		}
	}
	private func gradientTap() {
		withAnimation(.easeIn(duration: 0.5)) {
			pickleGradientTap.toggle()
			
			withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
				pickleGradientTap.toggle()
			}
		}
	}
}


#Preview {
	PickleIntroView()
}
