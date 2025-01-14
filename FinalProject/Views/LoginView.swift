//
//  LoginView.swift
//  FinalProject
//
//  Created by Riki Itokazu on 11/19/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
   
    
    enum LoginField {
        case email, password
    }
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentMain = false
    @FocusState private var focusField: LoginField?
   
    @State private var userId: String?
    @State private var currentUser: User?
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            // Find suitable image
            Image("logowhite")
                .resizable()
                .scaledToFit()
            Spacer()
            VStack (alignment: .leading) {
                Text("Email")
                    .foregroundStyle(.white)
                    .bold()
                TextField("Email", text:$email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of:email) {
                        enableButtons()
                    }
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.8), lineWidth:2)
                    }
                
                Text("Password")
                    .foregroundStyle(.white)
                    .bold()
                SecureField("Password", text: $password)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = nil
                    }
                    .onChange(of:password) {
                        enableButtons()
                    }
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.8), lineWidth:2)
                    }
            }

            
            HStack {
                
                Button("Log In") {
                    login()
                    // TODO: check last login. if current date is not equal to date of last login, reset counters and
                }
                .padding(.leading)
                
                
            }
            .buttonStyle(.borderedProminent)
            .tint(.blue500)
            .font(.title2)
            .padding(.top)
            .padding(.bottom, 50)
            .disabled(buttonDisabled)
            
        }
        .padding()
        .background(
            LinearGradient(colors: [Color(.black800), Color(.black500)], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .alert(alertMessage, isPresented: $showingAlert) {
            Button ("OK", role:.cancel) {}
        }
        .onAppear() {
            //            if Auth.auth().currentUser != nil {
            //                print("Log in successful")
            //                presentMain = true
            //            }
        }
        .fullScreenCover(isPresented: $presentMain) {
            NavigationStack {
                MainView()
            }
        }
        .onChange(of: userId) {
            print("-----here ")
            print("Users: \(userId ?? "NOTHING")")
            if userId != nil {
                refreshUserHabits(userId: userId)
                presentMain = true
            }
        }
        .onAppear {
            userId = nil
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") {
                   dismiss()
                }
            }
        }
    }
    
    func enableButtons() {
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
        
    }

    func login() {
        Auth.auth().signIn(withEmail: email, password:password) { result, error in
            if let error = error {
                print("LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            } else {
                print("Login success")
                userId = Auth.auth().currentUser!.uid
                
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView()
        
    }
}
