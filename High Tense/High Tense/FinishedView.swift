import SwiftUI
import SwiftData

struct FinishedView: View {
	@Environment(\.colorScheme) private var colorScheme
	@State private var timer: Timer?
	@State private var confettiAmount: Int = 1
	@State private var meetPickle: Bool = false
	
	private var topStartingBackgroundColor: Color = Color(red: 248/255, green: 255/255, blue: 171/255)
	private var topEndingBackgroundColor: Color = Color(red: 232/255, green: 240/255, blue: 147/255)
	
	private var backStartingBackgroundColor: Color = Color(red: 162/255, green: 184/255, blue: 250/255)
	private var backEndingBackgroundColor: Color = Color(red: 137/255, green: 166/255, blue: 251/255)
	
	private var systemAlternate: Color {
		colorScheme == .dark ? .white : .black
	}
	
	
	
	var body: some View {
		ZStack {
			LinearGradient(colors: [backStartingBackgroundColor, backEndingBackgroundColor], startPoint: .topLeading, endPoint: .bottomTrailing)
				.ignoresSafeArea()
			
			VStack {
				UnevenRoundedRectangle(cornerRadii: .init(bottomLeading: 35, bottomTrailing: 35))
					.fill(LinearGradient(colors: [topStartingBackgroundColor, topEndingBackgroundColor], startPoint: .topLeading, endPoint: .bottomTrailing))
					.frame(height: 300)
					.shadow(radius: 10, y: 25)
					.overlay {
						VStack(spacing: 25) {
							
							Text("Yippee!!!")
								.font(.system(size: 50))
								.foregroundStyle(.black)
							
							Text(String(repeating: " 🎉 ", count: confettiAmount))
								.font(.system(size: 70))
								.padding(.horizontal)
							
						}.padding(.top, 30)
					}.ignoresSafeArea()
				
				Spacer()
				
				VStack(spacing: 0) {
					Text("Celebrate with")
					
					Text("Friends!")
						.foregroundStyle(.red)
						.bold()
						.italic()
					
				}.font(.system(size: 40))
				
				Spacer()
				
				Button {
					meetPickle.toggle()
				} label: {
					RoundedRectangle(cornerRadius: 25)
						.fill(Color.green)
						.shadow(radius: 10, y: 10)
						.overlay {
							
							Text("Meet Pickle Again")
								.font(.system(size: 21, weight: .semibold))
								.foregroundStyle(.black)
								.multilineTextAlignment(.center)
							
						}
						.frame(width: 150, height: 80)
				}
				
				Spacer()
				
				ShareLink(items: ["I just finished a whole bunch of work. Want to hang out sometime?"]) {
					RoundedRectangle(cornerRadius: 25)
						.fill(Color(UIColor.systemBackground))
						.shadow(radius: 10, y: 10)
						.overlay {
							
							Image(systemName: "square.and.arrow.up.fill")
								.font(.system(size: 25))
								.foregroundStyle(systemAlternate)
							
						}
						.frame(width: 150, height: 80)
				}.padding(.bottom, 25)
				
				Spacer()
			}
			.onAppear {
				increasingConfettis()
			}
			.onDisappear {
				resetConfettis()
			}
		}
		.sheet(isPresented: $meetPickle) {
			PickleIntroView()
		}
	}
	
	private func increasingConfettis() {
		confettiAmount = 1
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
			if confettiAmount < 3 {
				withAnimation(.easeOut) {
					confettiAmount += 1
				}
			} else {
				timer?.invalidate()
			}
		}
	}
	
	private func resetConfettis() {
		timer?.invalidate()
		timer = nil
		confettiAmount = 1
	}
	
}

#Preview {
	FinishedView()
}
