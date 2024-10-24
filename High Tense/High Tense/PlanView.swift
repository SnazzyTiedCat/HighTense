import SwiftUI
import SwiftData

struct PlanView: View {
	@Environment(\.modelContext) var context
	@Environment(\.colorScheme) private var colorScheme
	
	@State private var taskToEdit: TaskModel?
	@State private var showAddTaskSheet: Bool = false
	@Query(sort: \TaskModel.date) var tasks: [TaskModel]
	
	
	private var backgroundColor: Color {
		colorScheme == .light ? Color(red: 235/255, green: 235/255, blue: 235/255) : Color(red: 35/255, green: 35/255, blue: 35/255)
	}
	
	private var systemAlterate: Color {
		colorScheme == .dark ? .white : .black
	}
	
	var body: some View {
		ZStack {
			backgroundColor
				.ignoresSafeArea()
			
			VStack {
				RoundedRectangle(cornerRadius: 25)
					.fill(Color(UIColor.systemBackground))
					.stroke(systemAlterate, style: StrokeStyle(lineWidth: 3))
					.brightness(0.1)
					.frame(height: 125)
					.overlay {
						HStack {
							RoundedRectangle(cornerRadius: 25)
								.fill(Color.planColor)
								.stroke(systemAlterate, style: StrokeStyle(lineWidth: 3))
								.frame(minWidth: 100, maxWidth: 200, minHeight: 125, maxHeight: 125)
								.overlay {
									
									Text("\(tasks.count)")
										.font(.system(size: 25, weight: .semibold, design: .monospaced))
										.foregroundStyle(.white)
										.multilineTextAlignment(.center)
									
								}
							
							Spacer()
							
							Button(action: addTask) {
								Circle()
									.fill(Color.blue)
									.overlay {
										
										Image(systemName: "plus.diamond.fill")
											.font(.system(size: 25))
											.foregroundStyle(Color.white)
										
									}
									.frame(width: 75, height: 75)
							}
							
							Spacer()
						}
					}.padding()
				
				Spacer()
				
				RoundedRectangle(cornerRadius: 25)
					.fill(Color(UIColor.systemBackground))
					.stroke(systemAlterate, style: .init(lineWidth: 2))
					.brightness(colorScheme == .light ? -0.1 : 0.2)
					.overlay {
						
						List {
							ForEach(tasks) { task in
								taskCell(task: task)
									.onTapGesture {
										taskToEdit = task
									}
							}
							.onDelete { indexSet in
								for index in indexSet {
									context.delete(tasks[index])
								}
							}
						}
						
						if tasks.isEmpty {
							
							VStack {
								
								Text("🎉")
									.font(.system(size: 50))
									.padding(.bottom, 5)
								
								Text("No Tasks!")
									.font(.system(size: 35, weight: .semibold))
								
							}
						}
						
					}.padding()
				
			}
			.padding(.bottom, 70)
			.sheet(isPresented: $showAddTaskSheet) {
				addTaskSheetView()
			}
			.sheet(item: $taskToEdit) { task in
				editTaskSheetView(task: task)
			}
		}
	}
	private func addTask() {
		showAddTaskSheet.toggle()
	}
}

#Preview {
	PlanView()
}

struct taskCell: View {
	let task: TaskModel
	
	var body: some View {
		HStack {
			Text(task.name)
				.fontDesign(.monospaced)
			
			Spacer()
			
			Image(systemName: task.isComplete ? "checkmark.circle.fill" : "xmark.circle.fill")
				.font(.system(size: 25))
		}
		
	}
}

struct addTaskSheetView: View {
	@Environment(\.modelContext) var context
	@Environment(\.dismiss) private var dismiss
	@Environment(\.colorScheme) private var colorScheme
	
	private var backgroundColor: Color {
		colorScheme == .light ? Color(red: 235/255, green: 235/255, blue: 235/255) : Color(red: 35/255, green: 35/255, blue: 35/255)
	}
	
	private var systemAlternate: Color {
		colorScheme == .dark ? .white : .black
	}
	
	@State private var name: String = ""
	@State private var date: Date = .now
	@State private var isComplete: Bool = false
	
	var body: some View {
		ZStack {
			backgroundColor
				.ignoresSafeArea()
			
			VStack {
				Text("New Task")
					.font(.system(size: 30, weight: .semibold, design: .monospaced))
					.multilineTextAlignment(.center)
				
				Spacer()
				
				RoundedRectangle(cornerRadius: 25)
					.fill(Color(UIColor.systemBackground))
					.stroke(systemAlternate, style: StrokeStyle(lineWidth: 3))
					.overlay {
						Form {
							
							TextField("Task Name", text: $name)
							DatePicker("Date", selection: $date, displayedComponents: .date)
							
						}
					}.frame(height: 350)
				
				Spacer()
				
				Button {
					let task = TaskModel(name: name, date: date, isComplete: isComplete)
					context.insert(task)
					dismiss()
					
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 15)
							.fill(Color.planColor)
							.stroke(.black, style: StrokeStyle(lineWidth: 2))
							.shadow(radius: 20, y: 20)
						
						Text("Save")
							.font(.system(size: 15, weight: .bold))
							.foregroundStyle(.white)
					}.frame(width: 100, height: 50)
				}
				
				
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
				
			}.padding(25)
		}
	}
}

struct editTaskSheetView: View {
	@Environment(\.colorScheme) private var colorScheme
	@Environment(\.dismiss) private var dismiss
	@Bindable var task: TaskModel
	
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
				Text("Edit Task")
					.font(.system(size: 30, weight: .semibold, design: .monospaced))
					.multilineTextAlignment(.center)
				
				Spacer()
				
				RoundedRectangle(cornerRadius: 25)
					.fill(Color(UIColor.systemBackground))
					.stroke(systemAlternate, style: StrokeStyle(lineWidth: 3))
					.overlay {
						Form {
							
							TextField("Edit Name", text: $task.name)
							DatePicker("Date", selection: $task.date, displayedComponents: .date)
							Text("Task Status: \(task.isComplete ? "Complete" : "Incomplete")")
						}
					}.frame(height: 350)
				
				Spacer()
				
				Button {
					task.isComplete.toggle()
					
				} label: {
					ZStack {
						RoundedRectangle(cornerRadius: 15)
							.fill(task.isComplete ? Color.green : Color.red)
							.stroke(.black, style: StrokeStyle(lineWidth: 2))
							.shadow(radius: 20, y: 20)
						
						Text("Task Complete?")
							.font(.system(size: 15, weight: .bold))
							.foregroundStyle(.white)
					}.frame(width: 100, height: 50)
				}
				
				Spacer().frame(height: 25)
				
				Button {
					dismiss()
					
				} label: {
					RoundedRectangle(cornerRadius: 25)
						.fill(systemAlternate)
						.frame(width: 125, height: 80)
						.overlay {
							VStack(spacing: 15) {
								Image(systemName: "xmark")
									.font(.system(size: 25))
									.foregroundStyle(Color(UIColor.systemBackground))
								
								Text("Save & Close")
									.font(.system(size: 15, weight: .semibold))
							}
							
						}
				}
				
			}.padding(25)
			
		}
	}
}
