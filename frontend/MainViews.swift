import SwiftUI

// MARK: - Models

struct Tour: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let location: String
    let price: String
    let imageName: String   // For now use system or placeholder
    let rating: Double
    let reviews: Int
    let category: String
}

struct Guide: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rating: Double
    let avatar: String
}

struct ChatThread: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let unread: Bool
}

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isMe: Bool
    let time: String
}

// MARK: - Sample Data

let sampleToursNearYou: [Tour] = [
    Tour(title: "Malibu Coastal Tour", location: "Malibu, CA", price: "$80", imageName: "photo", rating: 4.8, reviews: 204, category: "Tours Near You"),
    Tour(title: "LA City Highlights", location: "Los Angeles, CA", price: "$95", imageName: "photo", rating: 4.6, reviews: 132, category: "Tours Near You"),
    Tour(title: "Santa Monica Sunset", location: "Santa Monica, CA", price: "$70", imageName: "photo", rating: 4.9, reviews: 321, category: "Tours Near You")
]

let sampleTrendingTours: [Tour] = [
    Tour(title: "Disneyland Adventure", location: "Anaheim, CA", price: "$120", imageName: "photo", rating: 4.7, reviews: 540, category: "Trending"),
    Tour(title: "Universal Studios Day", location: "Universal City, CA", price: "$110", imageName: "photo", rating: 4.5, reviews: 312, category: "Trending")
]

let sampleExtremeTours: [Tour] = [
    Tour(title: "Skydiving Over LA", location: "Los Angeles, CA", price: "$200", imageName: "photo", rating: 4.9, reviews: 88, category: "Extreme"),
    Tour(title: "ATV Desert Ride", location: "Palm Springs, CA", price: "$150", imageName: "photo", rating: 4.6, reviews: 54, category: "Extreme")
]

let sampleGuides: [Guide] = [
    Guide(name: "Alex Kim", rating: 4.8, avatar: "person.fill"),
    Guide(name: "Sarah Lee", rating: 4.7, avatar: "person.fill"),
    Guide(name: "Daniel Park", rating: 4.9, avatar: "person.fill")
]

let sampleThreads: [ChatThread] = [
    ChatThread(name: "Bob Builder", lastMessage: "See you tomorrow!", unread: true),
    ChatThread(name: "Jane Traveler", lastMessage: "Thanks for the great tour!", unread: false)
]

let sampleConversation: [ChatMessage] = [
    ChatMessage(text: "Hi, I’d like to know more about the Hollywood Walk Tour.", isMe: false, time: "09:40"),
    ChatMessage(text: "Of course! What would you like to know?", isMe: true, time: "09:41"),
    ChatMessage(text: "How long is the tour and what’s included?", isMe: false, time: "09:42")
]

// MARK: - Main Tab View

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }

            NavigationStack {
                ExploreView()
            }
            .tabItem {
                Image(systemName: "safari.fill")
                Text("Explore")
            }

            NavigationStack {
                MessagesListView()
            }
            .tabItem {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                Text("Messages")
            }

            NavigationStack {
                AccountPlaceholderView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                Text("Account")
            }
        }
    }
}

// MARK: - Shared Components

struct SectionHeader: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

struct TourCard: View {
    let tour: Tour
    var compact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image placeholder
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: compact ? 130 : 160)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 4) {
                    Text(tour.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Text(tour.location)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(12)
            }

            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 12))
                Text(String(format: "%.1f", tour.rating))
                    .font(.system(size: 13, weight: .semibold))
                Text("(\(tour.reviews))")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Spacer()
                Text(tour.price)
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 4)
        }
        .frame(width: compact ? 180 : 200)
    }
}

struct GuideAvatarCard: View {
    let guide: Guide

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color.avatarBackground)
                    .frame(width: 60, height: 60)
                Image(systemName: guide.avatar)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            }

            Text(guide.name)
                .font(.system(size: 13, weight: .medium))
                .lineLimit(1)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .font(.system(size: 11))
                Text(String(format: "%.1f", guide.rating))
                    .font(.system(size: 11))
            }
        }
        .frame(width: 90)
    }
}

// MARK: - Explore View

struct ExploreView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                SectionHeader(title: "Explore")

                VStack(alignment: .leading, spacing: 16) {

                    ExploreSectionView(
                        title: "Tours Near You",
                        tours: sampleToursNearYou
                    )

                    ExploreSectionView(
                        title: "Trending",
                        tours: sampleTrendingTours
                    )

                    ExploreSectionView(
                        title: "Extreme Activities",
                        tours: sampleExtremeTours
                    )

                    // Best Guides
                    VStack(alignment: .leading, spacing: 12) {
                        SectionHeader(title: "Best Guides")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(sampleGuides) { guide in
                                    GuideAvatarCard(guide: guide)
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
            }
            .padding(.top, 16)
        }
        .navigationTitle("Explore")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExploreSectionView: View {
    let title: String
    let tours: [Tour]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: title)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tours) { tour in
                        NavigationLink {
                            GuideDetailView(tour: tour)
                        } label: {
                            TourCard(tour: tour)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

// MARK: - Guide Detail View

struct GuideDetailView: View {
    let tour: Tour

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // Header Image
                ZStack(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.gray.opacity(0.4), .gray.opacity(0.1)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 260)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.white.opacity(0.7))
                        )

                    VStack(alignment: .leading, spacing: 6) {
                        Text(tour.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        Text(tour.location)
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.9))

                        HStack(spacing: 10) {
                            Image(systemName: "person.crop.circle")
                            Text("Guide Name")
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 4, height: 4)
                            Image(systemName: "person.2.fill")
                            Text("200")
                            Circle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: 4, height: 4)
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", tour.rating))
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    }
                    .padding(16)
                }

                // Description
                VStack(alignment: .leading, spacing: 12) {
                    Text("Description")
                        .font(.system(size: 18, weight: .semibold))

                    Text("Description of tour — Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam...")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineSpacing(4)

                    Button {
                        // Expand description / show more
                    } label: {
                        Text("More")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.primaryBlue)
                            .cornerRadius(20)
                    }

                    Button {
                        // Map route
                    } label: {
                        HStack {
                            Text("Map With Tour Route")
                            Spacer()
                            Image(systemName: "map")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.08))
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 16)

                // Specifics
                VStack(alignment: .leading, spacing: 12) {
                    Text("Specifics")
                        .font(.system(size: 18, weight: .semibold))
                    HStack(spacing: 16) {
                        SpecificChip(icon: "binoculars.fill", title: "Sightseeing")
                        SpecificChip(icon: "leaf.fill", title: "Nature")
                        SpecificChip(icon: "moon.stars.fill", title: "Late")
                    }
                }
                .padding(.horizontal, 16)

                // Reviews
                VStack(alignment: .leading, spacing: 12) {
                    Text("Reviews")
                        .font(.system(size: 18, weight: .semibold))

                    VStack(spacing: 12) {
                        ReviewCard()
                        ReviewCard()
                    }

                    Button {
                        // Show more reviews
                    } label: {
                        Text("More")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.primaryBlue)
                    }
                }
                .padding(.horizontal, 16)

                // About Guide
                VStack(alignment: .leading, spacing: 12) {
                    Text("About Guide")
                        .font(.system(size: 18, weight: .semibold))

                    HStack(alignment: .center, spacing: 12) {
                        Circle()
                            .fill(Color.avatarBackground)
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Guide Name")
                                .font(.system(size: 16, weight: .semibold))
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("4.5")
                                    .font(.system(size: 13))
                            }
                        }
                        Spacer()
                    }

                    Text("Description of tour guide — Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineSpacing(3)
                }
                .padding(.horizontal, 16)

                // Price + Reserve button
                HStack(spacing: 16) {
                    VStack(alignment: .leading) {
                        Text(tour.price)
                            .font(.system(size: 20, weight: .bold))
                        Text("per person")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }

                    Button {
                        // Reserve tour
                    } label: {
                        Text("Reserve")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.primaryBlue)
                            .cornerRadius(24)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SpecificChip: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(title)
        }
        .font(.system(size: 13))
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(14)
    }
}

struct ReviewCard: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Circle()
                .fill(Color.avatarBackground)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(.white)
                )

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("name")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.system(size: 12))
                        Text("4.5")
                            .font(.system(size: 12))
                    }
                }
                Text("Review Description Review Description Review Description Review Description...")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .lineLimit(3)
            }
        }
        .padding(12)
        .background(Color.gray.opacity(0.06))
        .cornerRadius(16)
    }
}

// MARK: - Home View

struct HomeView: View {
    @State private var selectedCategory: String = "Nature"
    private let categories = ["Nature", "Food", "Nightlife", "Culture"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                // Search bar
                HStack {
                    TextField("Search Tour or Location", text: .constant(""))
                        .padding(.horizontal, 16)
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                    Button {
                        // filter
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 18))
                            .padding(8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Category chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                selectedCategory = category
                            } label: {
                                Text(category)
                                    .font(.system(size: 14, weight: .medium))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(selectedCategory == category ? Color.primaryBlue : Color.gray.opacity(0.1))
                                    .foregroundColor(selectedCategory == category ? .white : .black)
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Featured card
                VStack(alignment: .leading, spacing: 8) {
                    TourCard(tour: sampleTrendingTours.first ?? sampleToursNearYou.first!, compact: false)
                }
                .padding(.horizontal, 16)

                // Additional list
                VStack(alignment: .leading, spacing: 12) {
                    Text("Recommended")
                        .font(.system(size: 18, weight: .semibold))
                        .padding(.horizontal, 16)

                    ForEach(sampleToursNearYou) { tour in
                        NavigationLink {
                            GuideDetailView(tour: tour)
                        } label: {
                            HStack(spacing: 12) {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 70)
                                    .cornerRadius(12)
                                    .overlay(
                                        Image(systemName: "photo")
                                            .foregroundColor(.white.opacity(0.7))
                                    )

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(tour.title)
                                        .font(.system(size: 14, weight: .semibold))
                                        .lineLimit(2)
                                    Text(tour.location)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)

                                    HStack(spacing: 4) {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 11))
                                        Text(String(format: "%.1f", tour.rating))
                                            .font(.system(size: 11))
                                        Text(tour.price)
                                            .font(.system(size: 11, weight: .semibold))
                                            .foregroundColor(.primaryBlue)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                        .buttonStyle(.plain)
                    }
                }

                Spacer().frame(height: 16)
            }
        }
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Search View (basic list style)

struct SearchView: View {
    @State private var query: String = ""
    private let destinations = [
        "Las Vegas, United States NV",
        "Lake Geneva, United States WI",
        "Lake Como, United States IL",
        "Leaning, United States MI"
    ]

    var filtered: [String] {
        guard !query.isEmpty else { return destinations }
        return destinations.filter { $0.lowercased().contains(query.lowercased()) }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Search", text: $query)
                    .padding(.horizontal, 16)
                    .frame(height: 36)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                Button("Cancel") {
                    query = ""
                }
                .font(.system(size: 14))
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 4)

            List {
                ForEach(filtered, id: \.self) { dest in
                    Text(dest)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Messages List & Chat

struct MessagesListView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Messages")
                    .font(.system(size: 24, weight: .bold))
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            HStack {
                TextField("Search", text: .constant(""))
                    .padding(.horizontal, 16)
                    .frame(height: 36)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                Spacer().frame(width: 16)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            List {
                ForEach(sampleThreads) { thread in
                    NavigationLink {
                        ChatView(thread: thread)
                    } label: {
                        HStack(spacing: 12) {
                            Circle()
                                .fill(Color.avatarBackground)
                                .frame(width: 46, height: 46)
                                .overlay(
                                    Text(String(thread.name.prefix(1)))
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(thread.name)
                                        .font(.system(size: 15, weight: .semibold))
                                    Spacer()
                                    Circle()
                                        .fill(thread.unread ? Color.primaryBlue : Color.clear)
                                        .frame(width: 8, height: 8)
                                }
                                Text(thread.lastMessage)
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}

struct ChatView: View {
    let thread: ChatThread
    @State private var messages: [ChatMessage] = sampleConversation
    @State private var draft: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(messages) { msg in
                            ChatBubble(message: msg)
                                .id(msg.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                }
                .onChange(of: messages.count) { _ in
                    if let last = messages.last {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }

            Divider()

            // Input bar
            HStack(spacing: 12) {
                TextField("Enter a message", text: $draft, axis: .vertical)
                    .lineLimit(1...4)
                    .padding(10)
                    .background(Color.gray.opacity(0.08))
                    .cornerRadius(20)

                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.primaryBlue)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .navigationTitle(thread.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendMessage() {
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let newMessage = ChatMessage(text: trimmed, isMe: true, time: "now")
        messages.append(newMessage)
        draft = ""
    }
}

struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack {
            if message.isMe {
                Spacer()
                Text(message.text)
                    .padding(10)
                    .background(Color.primaryBlue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
            } else {
                Text(message.text)
                    .padding(10)
                    .background(Color.gray.opacity(0.15))
                    .foregroundColor(.black)
                    .cornerRadius(16)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                Spacer()
            }
        }
    }
}

// MARK: - Placeholder Account View

struct AccountPlaceholderView: View {
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "person.crop.circle.badge.checkmark")
                .font(.system(size: 60))
                .foregroundColor(.primaryBlue)
            Text("Account Screen")
                .font(.system(size: 20, weight: .semibold))
            Text("This is a placeholder for the future account/profile page.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
}