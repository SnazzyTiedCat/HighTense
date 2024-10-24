import SwiftUI
import SwiftData

struct ExecutionView: View {
	@Environment(\.colorScheme) private var colorScheme
	@Query(sort: \TaskModel.date) var tasks: [TaskModel]
	@State private var selectedTask: TaskModel?
	
	@State private var remainingTime: Double = 1800
	
	private var backgroundColor: Color {
		colorScheme == .light ? Color(red: 235/255, green: 235/255, blue: 235/255) : Color(red: 35/255, green: 35/255, blue: 35/255)
	}
	
	private var systemAlternate: Color {
		colorScheme == .dark ? .white : .black
	}
	
	
	var body: some View {
		NavigationStack {
			ZStack {
				backgroundColor
					.ignoresSafeArea()
				
				VStack {
					Text("Pick a Task to Work On")
						.font(.system(size: 20, weight: .semibold, design: .monospaced))
						.multilineTextAlignment(.center)
					
					Spacer()
					
					RoundedRectangle(cornerRadius: 25)
						.fill(Color.executionColor)
						.stroke(systemAlternate, style: .init(lineWidth: 3))
						.frame(height: 350)
						.overlay {
							
							List {
								ForEach(tasks) { task in
									taskCell(task: task)
										.onTapGesture {
											selectedTask = task
										}
								}
							}
							
						}
					
					Spacer()
					
					Text("Session Timer")
						.font(.caption)
						.foregroundStyle(systemAlternate)
						.padding(.bottom, 3)
					
					RoundedRectangle(cornerRadius: 25)
						.fill(systemAlternate)
						.overlay {
							VStack(spacing: 15) {
								Text(textToTime(from: remainingTime))
									.font(.system(size: 35, weight: .bold, design: .monospaced))
									.foregroundStyle(Color(UIColor.systemBackground))
								
								HStack(spacing: 50) {
									Button(action: decreaseTime) {
										RoundedRectangle(cornerRadius: 25)
											.fill(Color.red)
											.overlay {
												Image(systemName: "xmark.diamond.fill")
													.font(.system(size: 15))
													.foregroundStyle(.white)
												
											}
											.frame(width: 80, height: 40)
									}
									
									Button(action: increaseTime) {
										RoundedRectangle(cornerRadius: 25)
											.fill(Color.blue)
											.overlay {
												Image(systemName: "plus.diamond.fill")
													.font(.system(size: 15))
													.foregroundStyle(.white)
												
											}
											.frame(width: 80, height: 40)
									}
								}
							}
							
						}
						.frame(height: 125)
						.padding(.horizontal, 25)
					
					Spacer()
				}.padding(25)
			}
			.fullScreenCover(item: $selectedTask) { task in
				ExecutionActionView(task: task, remainingTime: $remainingTime)
			}.transition(.move(edge: .bottom))
		}
	}
	private func decreaseTime() {
		if remainingTime > 0 {
			remainingTime -= 300
		}
	}
	private func biggerDecreaseTime() {
		if remainingTime > 0 {
			remainingTime -= 600
		}
	}
	private func increaseTime() {
		if remainingTime < 86400 {
			remainingTime += 300
		}
	}
	private func biggerIncreaseTime() {
		if remainingTime > 0 {
			remainingTime += 600
		}
	}
	private func textToTime(from time: TimeInterval) -> String {
		let minutes = Int(time) / 60
		let seconds = Int(time) % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
}
