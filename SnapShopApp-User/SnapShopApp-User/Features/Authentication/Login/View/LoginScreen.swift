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
                    
                    Image("app-logo").resizable().aspectRatio(contentMode: .fit).frame(width: UIScreen.screenWidth * 0.3).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    Text("Login").padding(.bottom,30).font(.title2).fontWeight(.bold)
                    AppTextField(fieldModel: $viewModel.emailField,text: $text).padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
                    
                    AppTextField(fieldModel: $viewModel.passwordField, text: $password)
                    
                    VStack{
                        
                        AppButton(text: "Login", width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05,isFilled: true, onClick: {
                            print(">>>>>>\( password)")
                            viewModel.login(email: viewModel.emailField.value, password: password)
                            viewModel.viewState = .loading
                        }).padding(.bottom,10)
                        
                        
                        HStack{
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                            Text("or").padding(.horizontal)
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.gray)
                        }.padding(.vertical)
                        
                        Button {
                            viewModel.signInWithGoogle()

                        } label: {
                            
                            HStack{
                                Image("google-icon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.screenWidth * 0.12, height: UIScreen.screenHeight * 0.035)
                             
                                
                                Text("Sign in with Google")
                                    .font(.callout)
                                    .lineLimit(1)
                            }.foregroundColor(.white)
                                .padding(.horizontal,16)
                                .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.black).frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenHeight * 0.05))
                            
                        }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05)

                        
                        Button {
                            
                                self.navigateToRegister = true
                        } label: {
                            
                            HStack{
                                    Text("Register").fontWeight(.medium)
                                    .font(.callout)
                                    .lineLimit(1)
                            }.foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 10.0, style: .continuous).fill(.black).frame(width: UIScreen.screenWidth * 0.9 , height: UIScreen.screenHeight * 0.05))
                            
                        }.frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05).padding(.bottom,20)
                        
                    }
                }.navigationBarBackButtonHidden(true).padding(.all,20).navigationBarItems( trailing:  Button(action:{
                    navigateToHome = true
                },label:{
                    Text("SKIP")
                        .font(.callout)
                        .fontWeight(.medium)
                        .underline()
                        .foregroundStyle(Color.black)
                    
                })
                 )
            }else{
                VStack {
                    Spacer()
                    CustomCircularProgress()
                    Spacer()
                }.navigationBarBackButtonHidden(true)
            }
            
        }.onReceive(viewModel.$isLogIn){ isLoggedIn in
            if isLoggedIn {
                navigateToHome = true
            }
        }
        .navigationDestination(isPresented:$navigateToHome){
            BaseView()
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
