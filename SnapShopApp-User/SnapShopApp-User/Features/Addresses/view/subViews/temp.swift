//
//struct PhoneNumberView: View {
//    
//    var body: some View {
//        GeometryReader { geo in
//            let hasHomeIndicator = geo.safeAreaInsets.bottom > 0
//            NavigationStack {
//                VStack {
//                    
//  
////                    Button {
////                        // Move to the next step
////                    } label: {
////                        Text("Next")
////                    }
////                    .disableWithOpacity(mobPhoneNumber.count < 1)
////                    .buttonStyle(OnboardingButtonStyle())
//                }
//                .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
//                .padding(.horizontal)
//                
//                Spacer()
//                
//            }
//            .onTapGesture {
//                hideKeyboard()
//            }
//            .presentationDetents([.medium, .large])
//        }
//        .ignoresSafeArea(.keyboard)
//    }
//    
//}
//
//
//
