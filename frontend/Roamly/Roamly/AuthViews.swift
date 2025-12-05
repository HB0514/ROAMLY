import SwiftUI
import Combine

extension Color {
    static let skyBlue = Color(red: 151/255, green: 200/255, blue: 255/255)
    static let primaryBlue = Color(red: 59/255, green: 134/255, blue: 255/255)
    static let pageBackground = Color(red: 244/255, green: 247/255, blue: 255/255)
    static let avatarBackground = Color(red: 191/255, green: 214/255, blue: 255/255)
}

final class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var userEmail: String?

    func setSession(email: String, tokens: AuthTokens, activate: Bool = true) {
        userEmail = email
        accessToken = tokens.access
        refreshToken = tokens.refresh
        if activate {
            isLoggedIn = true
        }
    }

    func markLoggedIn() {
        isLoggedIn = true
    }

    func clear() {
        isLoggedIn = false
        accessToken = nil
        refreshToken = nil
        userEmail = nil
    }
}
// MARK: - Root

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainTabView()
            } else {
                NavigationStack {
                    LoginView()
                }
            }
        }
    }
}

// MARK: - Share Layout (blue + white)

struct AuthScaffold<Content: View>: View {
    @Environment(\.dismiss) private var dismiss

    let title: String
    let showBack: Bool
    let content: Content

    init(title: String, showBack: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.showBack = showBack
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.pageBackground
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Color.skyBlue
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 240)

                    HStack(alignment: .center, spacing: 12) {
                        if showBack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }

                        Text(title)
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 3)

                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }

                Spacer()
            }

            VStack {
                Spacer().frame(height: 180)

                VStack(spacing: 24) {
                    content
                }
                .padding(24)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(32)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: -4)
                .padding(.horizontal, 16)

                Spacer()
            }
        }
    }
}

// MARK: - Share component

struct RoundedInputField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 44)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

struct DropdownField: View {
    let placeholder: String
    @Binding var value: String
    let options: [String]

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(option) {
                    value = option
                }
            }
        } label: {
            HStack {
                Text(value.isEmpty ? placeholder : value)
                    .foregroundColor(value.isEmpty ? .gray : .black)
                Spacer()
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .frame(height: 44)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            .cornerRadius(22)
            .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
        }
    }
}

struct PrimaryButtonLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.primaryBlue)
            .cornerRadius(26)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            PrimaryButtonLabel(title: title)
        }
    }
}

struct AlertMessage: Identifiable {
    let id = UUID()
    let text: String
}

// MARK: - 1. Login View

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var infoMessage: AlertMessage?
    @State private var isLoading = false

    var body: some View {
        AuthScaffold(title: "Log In") {
            Spacer().frame(height: 8)

            RoundedInputField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
            RoundedInputField(placeholder: "Password", text: $password, isSecure: true)

            HStack {
                Spacer()
                Button("forgot password?") {
                    infoMessage = AlertMessage(
                        text: "Password reset is not connected yet.\nAsk the dev team to hook this up to your backend."
                    )
                }
                .font(.system(size: 11))
                .foregroundColor(Color.primaryBlue)
            }

            PrimaryButton(title: isLoading ? "Logging in..." : "Login") {
                Task { await performLogin() }
            }
            .disabled(isLoading)

            Spacer().frame(height: 8)

            HStack(spacing: 4) {
                Spacer()
                Text("Don't have an account?")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("Sign Up")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color.primaryBlue)
                }
                Spacer()
            }
        }
        .alert(item: $infoMessage) { msg in
            Alert(
                title: Text("Info"),
                message: Text(msg.text),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func performLogin() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            await MainActor.run {
                infoMessage = AlertMessage(text: "Email and password are required.")
            }
            return
        }

        await MainActor.run { isLoading = true }
        do {
            let tokens = try await APIClient.shared.login(email: trimmedEmail, password: password)
            await MainActor.run {
                appState.setSession(email: trimmedEmail, tokens: tokens, activate: true)
            }
        } catch {
            await MainActor.run {
                let message = (error as? APIError)?.errorDescription ?? error.localizedDescription
                infoMessage = AlertMessage(text: message)
            }
        }
        await MainActor.run { isLoading = false }
    }
}

// MARK: - 2. SignUp View
private enum SignUpRoute: Hashable {
    case aboutYou
}

struct SignUpView: View {
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var infoMessage: AlertMessage?
    @State private var isLoading = false
    @State private var goAboutYou = false

    var body: some View {
        AuthScaffold(title: "Sign Up", showBack: true) {

            RoundedInputField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
            RoundedInputField(placeholder: "Password", text: $password, isSecure: true)
            RoundedInputField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

            PrimaryButton(title: isLoading ? "Signing up..." : "Signup") {
                Task { await performSignup() }
            }
            .disabled(isLoading)
        }
        .background(
            NavigationLink(destination: AboutYouView(), isActive: $goAboutYou) { EmptyView() }
                .hidden()
        )
        .alert(item: $infoMessage) { msg in
            Alert(title: Text("Info"), message: Text(msg.text), dismissButton: .default(Text("OK")))
        }
    }

    private func performSignup() async {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            await MainActor.run { infoMessage = AlertMessage(text: "Email and password are required.") }
            return
        }
        guard password == confirmPassword else {
            await MainActor.run { infoMessage = AlertMessage(text: "Passwords do not match.") }
            return
        }

        await MainActor.run { isLoading = true }
        do {
            try await APIClient.shared.register(email: trimmedEmail, password: password)
            let tokens = try await APIClient.shared.login(email: trimmedEmail, password: password)
            await MainActor.run {
                appState.setSession(email: trimmedEmail, tokens: tokens, activate: false)
                goAboutYou = true
            }
        } catch {
            await MainActor.run {
                let message = (error as? APIError)?.errorDescription ?? error.localizedDescription
                infoMessage = AlertMessage(text: message)
            }
        }
        await MainActor.run { isLoading = false }
    }
}

// MARK: - 3. About You View

struct AboutYouView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var gender = ""
    private let genderOptions = ["Male", "Female", "Non-binary", "Prefer not to say"]

    var body: some View {
        AuthScaffold(title: "About You", showBack: true) {
            RoundedInputField(placeholder: "First Name", text: $firstName)
            RoundedInputField(placeholder: "Last Name", text: $lastName)
            DropdownField(placeholder: "Gender", value: $gender, options: genderOptions)

            NavigationLink {
                ProfilePictureView()
            } label: {
                PrimaryButtonLabel(title: "Continue")
            }
        }
    }
}

// MARK: - 4. Profile Picture View

struct ProfilePictureView: View {
    @State private var hasImage = false
    @State private var dummyImage = "LikeLion"

    var body: some View {
        AuthScaffold(title: "Profile Picture", showBack: true) {
            Spacer().frame(height: 8)

            HStack {
                Spacer()
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.avatarBackground)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Text(dummyImage)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                        )

                    Button {
                        print("Open image picker tapped")
                    } label: {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.primaryBlue)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .offset(x: 6, y: 6)
                }
                Spacer()
            }

            Text("Choose a picture for your profile")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .center)

            NavigationLink {
                LanguagesView()
            } label: {
                PrimaryButtonLabel(title: "Continue")
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - 5. Languages View

struct LanguageChip: View {
    let title: String
    @Binding var isSelected: Bool

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.primaryBlue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .black)
                .clipShape(Capsule())
        }
    }
}

struct LanguagesView: View {
    @EnvironmentObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedLanguages: Set<String> = ["English"]

    private let allLanguages: [String] = [
        "English","Afrikaans","Albanian","Arabic","Armenian","Azeri",
        "Basque","Belarusian","Bosnian","Bulgarian","Catalan","Chinese"
    ]

    var filteredLanguages: [String] {
        if searchText.isEmpty { return allLanguages }
        return allLanguages.filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    var body: some View {
        AuthScaffold(title: "Languages you speak", showBack: true) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Language", text: $searchText)
            }
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            .cornerRadius(20)

            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 8)], spacing: 8) {
                    ForEach(filteredLanguages, id: \.self) { lang in
                        LanguageChip(
                            title: lang,
                            isSelected: Binding(
                                get: { selectedLanguages.contains(lang) },
                                set: { newValue in
                                    if newValue {
                                        selectedLanguages.insert(lang)
                                    } else {
                                        selectedLanguages.remove(lang)
                                    }
                                }
                            )
                        )
                    }
                }
                .padding(.vertical, 4)
            }

            PrimaryButton(title: "Continue") {
                print("Selected languages: \(selectedLanguages)")
                appState.markLoggedIn()
            }
            .padding(.top, 8)
        }
    }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
