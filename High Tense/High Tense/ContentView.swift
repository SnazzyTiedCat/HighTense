import SwiftUI
import SwiftData

extension Color {
	static var planColor: Color {
		return Color(red: 152/255, green: 131/255, blue: 143/255)
	}
	static var executionColor: Color {
		return Color(red: 208/255, green: 225/255, blue: 212/255)
	}
	static var finishedColor: Color {
		return Color(red: 137/255, green: 166/255, blue: 251/255)
	}
}

struct ContentView: View {
	@State private var collapseTab: Bool = false
	@State private var selectedTab = 0
	@State private var showPickle: Bool = true
	@Namespace private var animation
	
	var body: some View {
		NavigationStack {
			ZStack {
				
				switch selectedTab {
				case 0:
					PlanView()
						.matchedGeometryEffect(id: "Plancontent", in: animation)
				case 1:
					ExecutionView()
						.matchedGeometryEffect(id: "Execcccontent", in: animation)
				case 2:
					FinishedView()
						.matchedGeometryEffect(id: "Finishedcontent", in: animation)
				default:
					PlanView()
				}
				
				VStack {
					
					Spacer()
					
					CustomTabView(selectedTab: $selectedTab, collapseTab: $collapseTab, animation: animation)
					
				}
				
			}
			.ignoresSafeArea(edges: .bottom)
			.fullScreenCover(isPresented: $showPickle) {
				PickleIntroView()
			}
		}
	}
}

#Preview {
    ContentView()
}
