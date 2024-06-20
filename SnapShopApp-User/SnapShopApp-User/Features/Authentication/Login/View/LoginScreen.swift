import SwiftUI

struct LoginScreen: View {
    @State private var text: String = ""
    @State private var password: String = ""
    @StateObject var viewModel = LoginViewModel()
    @State private var navigateToHome = false
    @State private var navigateToRegister = false
    var body: some View {
        NavigationStack{
            if $viewModel.viewState.wrappedValue == .loginView {
                VStack{
                    Image("app-logo").resizable().frame(width: UIScreen.screenWidth * 0.4).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Text("Login").padding(.vertical,30).font(.title2).fontWeight(.bold)
                    AppTextField(fieldModel: $viewModel.emailField,text: $text)
                    
                    AppTextField(fieldModel: $viewModel.passwordField, text: $password)
                    
                    HStack{
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text("Forgot Password?").font(.footnote).fontWeight(.medium).underline().foregroundStyle(Color.gray)
                        }).padding(.trailing,10)
                        
                    }.padding(.bottom,15)
                    
                    VStack{
                        Button(action:{
                            self.navigateToRegister = true
                        },label:{
                            Text("Don't have an account? Register Now").font(.footnote).fontWeight(.medium).underline().foregroundStyle(Color.gray)
                    
                        }).padding(.bottom,10)
                        Button(action:{
                            navigateToHome = true
                        },label:{
                            Text("Continue as Guest").font(.footnote).fontWeight(.medium).underline().foregroundStyle(Color.gray)
                            
                        }).padding(.bottom,160)
                    }

                    
                    AppButton(text: "Login", width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05,isFilled: true, onClick: {
                        print(">>>>>>\( password)")
                        viewModel.login(email: viewModel.emailField.value, password: password)
                        viewModel.viewState = .loading
                    }).padding(.bottom,50)

                    
                }.navigationBarBackButtonHidden(true).padding(.all,20)
            }else{
                VStack {
                    Spacer()
                    CustomCircularProgress()
                    Spacer()
                }
            }
            
        }.onReceive(viewModel.$isLogIn){ isLoggedIn in
            if isLoggedIn {
                navigateToHome = true
            }
        }
       .navigationDestination(isPresented:$navigateToHome){
            ContentView()
        }.navigationDestination(isPresented: $navigateToRegister){
             SignUpScreen()
         }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen( viewModel: LoginViewModel())
    }
}
