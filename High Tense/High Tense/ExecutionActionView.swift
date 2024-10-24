import SwiftUI

struct ExecutionActionView: View {
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.dismiss) private var dismiss
	@Bindable var task: TaskModel
	
	@Binding var remainingTime: TimeInterval
	@State private var timer: Timer? = nil
	@State private var isRunning = false
	@State private var savedStartTime: Date?
	
	@State private var nextEventTime: TimeInterval = 0
	@State private var pickleEvent: String = "Sleeping Currently..."
	@State private var pickleWidth: CGFloat = 100
	@State private var pickleHeight: CGFloat = 100
	@State private var pickleOpacity: CGFloat = 1
	@State private var pickleScale: CGFloat = 1
	@State private var pickleXOffset: CGFloat = 0
	@State private var pickleYOffset: CGFloat = 0
	@State private var pickleRotation: CGFloat = 0
	
	@State private var sessionComplete: Bool = false
	
	@State private var savedBackgroundTime: Date?
	@State private var startTime: Date = Date()
	
	private var originalTime: TimeInterval { remainingTime }
	private var totalTime: TimeInterval { remainingTime / 5 }
	@State private var nextPickleAdventureThreshold: [TimeInterval] = []
	
	private var systemAlternate: Color {
		colorScheme == .dark ? .white : .black
	}
	
	private var backgroundColor: Color {
		colorScheme == .light ? Color(red: 235/255, green: 235/255, blue: 235/255) : Color(red: 35/255, green: 35/255, blue: 35/255)
	}
	
	var body: some View {
		ZStack {
			backgroundColor
				.ignoresSafeArea()
			
			VStack {
				Button {
					pauseTimer()
					remainingTime = 1800
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
				ZStack {
					RoundedRectangle(cornerRadius: 25)
						.fill(Color.executionColor)
						.stroke(systemAlternate, style: StrokeStyle(lineWidth: 3))
						.frame(width: 150, height: 150)
						.padding(10)
					
					Image("HappyPickle")
						.resizable()
						.scaledToFit()
						.frame(width: pickleWidth, height: pickleHeight)
						.opacity(pickleOpacity)
						.scaleEffect(pickleScale)
						.offset(x: pickleXOffset, y: pickleYOffset)
						.rotationEffect(.degrees(pickleRotation))
						.onTapGesture {
							withAnimation(.easeIn(duration: 0.35)) {
								pickleScale = 0.8
								withAnimation(.easeOut(duration: 0.5).delay(0.5)) {
									pickleScale = 1
								}
							}
						}
					
				}.ignoresSafeArea()
				
				Spacer()
				
				VStack {
					UnevenRoundedRectangle(cornerRadii: .init(topLeading: 25, topTrailing: 25))
						.fill(Color.executionColor)
						.stroke(.black, style: StrokeStyle(lineWidth: 2))
						.brightness(0.1)
						.overlay {
							
							Text(pickleEvent)
								.font(.system(size: 30, weight: .semibold, design: .serif))
								.foregroundStyle(.black)
								.multilineTextAlignment(.leading)
								.padding()
								.minimumScaleFactor(0.3)
							
						}
						.frame(height: 80)
					
					
					HStack {
						RoundedRectangle(cornerRadius: 25)
							.fill(Color.executionColor)
							.stroke(.black, style: StrokeStyle(lineWidth: 2))
							.overlay {
								
								VStack(spacing: 20) {
									Divider()
									Text("Title:\n\(task.name)")
										.lineLimit(3)
										.minimumScaleFactor(0.5)
									
									
									Divider()
									Text("Start Time: ") +
									
									Text(formattedDate(startTime))
										.lineLimit(2)
										.padding(.horizontal)
										.minimumScaleFactor(0.5)
									
									Divider()
									Text("You've Got This!")
										.italic()
										.lineLimit(2)
									
									Divider()
									
								}
								.font(.system(size: 25, weight: .semibold, design: .serif))
								.minimumScaleFactor(0.5)
								.padding(.horizontal)
							}
							.frame(minWidth: 150, maxWidth: 300, minHeight: 150, maxHeight: 300)
						
						VStack {
							
							RoundedRectangle(cornerRadius: 25)
								.fill(systemAlternate)
								.stroke(Color(UIColor.systemBackground), style: StrokeStyle(lineWidth: 2))
								.overlay {
									
									Text(textToTime(from: remainingTime))
										.font(.system(size: 20, weight: .bold, design: .monospaced))
										.foregroundStyle(Color(UIColor.systemBackground))
										.multilineTextAlignment(.center)
										.minimumScaleFactor(0.5)
										.padding()
									
								}
								.frame(minWidth: 75, maxWidth: 150, minHeight: 75, maxHeight: 150)
							
							Button(action: toggleTimer) {
								RoundedRectangle(cornerRadius: 25)
									.fill(isRunning ? Color.red : Color.green)
									.stroke(.black, style: StrokeStyle(lineWidth: 2))
									.overlay {
										Image(systemName: isRunning ? "pause.circle" : "play.circle")
											.font(.system(size: 30))
											.foregroundStyle(.white)
										
									}.frame(minWidth: 75, maxWidth: 150, minHeight: 75, maxHeight: 150)
							}
						}
					}
				}
				
			}
			.padding([.horizontal, .bottom], 25)
			.brightness(sessionComplete ? -0.3 : 0)
			
			VStack {
				RoundedRectangle(cornerRadius: 25)
					.fill(Color.executionColor)
					.stroke(.black, style: StrokeStyle(lineWidth: 5))
					.overlay {
						VStack {
							Text("Congratulations!")
								.font(.system(size: 35, weight: .bold))
							
							Text("{ YOU COMPLETED }")
								.font(.system(size: 25, weight: .semibold, design: .monospaced))
						}
					}
					.frame(height: 300)
					.padding(.horizontal, 25)
				
				Button(action: finishedTask) {
					RoundedRectangle(cornerRadius: 25)
						.fill(Color(UIColor.systemBackground))
						.stroke(systemAlternate, style: StrokeStyle(lineWidth: 3))
						.overlay {
							
							Text("Mark Task Complete")
								.font(.system(size: 15, design: .monospaced))
								.foregroundStyle(systemAlternate)
							
						}
						.frame(width: 125, height: 80)
				}
				
			}
			.opacity(sessionComplete ? 1 : 0)
		}
		.onAppear {
			setupAdventureTimes()
		}
		.onChange(of: remainingTime) { oldValue, newValue in
			checkForAdventureTimes()
		}
	}
	
	private func finishedTask() {
		task.isComplete.toggle()
		withAnimation(.easeOut(duration: 0.5)) {
			sessionComplete.toggle()
		}
	}
	
	private func toggleTimer() {
		if isRunning {
			pauseTimer()
		} else {
			startTimer()
		}
	}
	
	private func startTimer() {
		isRunning = true
		savedStartTime = Date()
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if remainingTime > 0 {
				remainingTime -= 1
			} else {
				finishedTimer()
			}
		}
	}
	
	private func finishedTimer() {
		timer?.invalidate()
		timer = nil
		isRunning = false
		saveTimeState()
		
		if remainingTime == 0 {
			timer?.invalidate()
			withAnimation(.easeInOut(duration: 0.5)) {
				sessionComplete.toggle()
			}
		}
		
	}
	
	
	private func pauseTimer() {
		timer?.invalidate()
		timer = nil
		isRunning = false
		saveTimeState()
	}
	
	private func saveTimeState() {
		UserDefaults.standard.set(Date(), forKey: "savedExitTime")
		UserDefaults.standard.set(remainingTime, forKey: "remainingTime")
		UserDefaults.standard.set(isRunning, forKey: "isRunning")
	}
	
	private func loadSavedTime() {
		if let savedRemainingTime = UserDefaults.standard.object(forKey: "remainingTime") as? TimeInterval {
			remainingTime = savedRemainingTime
		}
		
		if let savedExitTime = UserDefaults.standard.object(forKey: "savedExitTime") as? Date,
			 let isRunningSaved = UserDefaults.standard.object(forKey: "isRunning") as? Bool {
			let timePassed = Date().timeIntervalSince(savedExitTime)
			remainingTime = max(0, remainingTime - timePassed)
			
			if remainingTime > 0 && isRunningSaved {
				startTimer()
			}
		}
	}
	
	private func textToTime(from time: TimeInterval) -> String {
		let minutes = Int(time) / 60
		let seconds = Int(time) % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
	
	private func formattedDate(_ date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .medium
		return formatter.string(from: date)
	}
	
	private func setupAdventureTimes() {
		nextPickleAdventureThreshold.removeAll()
		for i in 1...4 {
			nextPickleAdventureThreshold.append(remainingTime - totalTime * Double(i))
		}
	}
	
	private func  checkForAdventureTimes() {
		if let nextPickleAdventureTime = nextPickleAdventureThreshold.first, remainingTime <= nextPickleAdventureTime {
			triggerPickleAdventure()
			nextPickleAdventureThreshold.removeFirst()
		}
	}
	
	
	
	private func triggerPickleAdventure() {
		let randomEvent = Int.random(in: 1...5)
		
		switch randomEvent {
		case 1:
			pickleEvent = "Felt Magical and disappeared for a bit"
			pickleOpacity = 0
			DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
				pickleOpacity = 1
			}
		case 2:
			pickleEvent = "Ate a Jiggly Jelly Bean"
			for _ in 1...5 {
				withAnimation(.easeIn(duration: 0.25)) {
					pickleScale = 0.7
					withAnimation(.easeOut(duration: 0.25).delay(0.25)) {
						pickleScale = 1
					}
				}
			}
		case 3:
			pickleEvent = "Got the Zoomies"
			for _ in 1...10 {
				withAnimation(.easeIn(duration: 0.2)) {
					pickleXOffset = -250
					withAnimation(.easeOut(duration: 0.2).delay(0.2)) {
						pickleXOffset = 250
					}
				}
			}
		case 4:
			pickleEvent = "Started Going Crazy!"
			for _ in 1...10 {
				withAnimation(.easeIn(duration: 1)) {
					pickleXOffset = 15
					pickleYOffset = 15
					pickleRotation = 360
					withAnimation(.easeOut(duration: 1).delay(1)) {
						pickleXOffset = -15
						pickleYOffset = -15
						pickleRotation = 720
					}
				}
			}
			DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
				pickleXOffset = 0
				pickleRotation = 0
			}
		case 5:
			pickleEvent = "Started Sunbathing!"
			
		default:
			pickleEvent = "Sleeping Currently..."
		}
	}
}
