import Foundation

struct APIConfig {
    /// Change this to your running Django server host/port.
    /// Use http://127.0.0.1:8000 for simulator, or your machine IP for a physical device.
    static let baseURL = URL(string: "http://127.0.0.1:8000/api")!
}

enum APIError: LocalizedError {
    case invalidURL
    case server(status: Int, message: String?)
    case decoding(Error)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request URL."
        case .server(let status, let message):
            return message ?? "Server error (\(status))."
        case .decoding:
            return "Failed to parse server response."
        case .unknown:
            return "Unknown error."
        }
    }
}

struct AuthTokens: Codable {
    let access: String
    let refresh: String
}

private struct RegisterRequest: Encodable {
    let email: String
    let password: String
}

private struct LoginRequest: Encodable {
    let email: String
    let password: String
}

private struct MessageResponse: Decodable {
    let message: String?
    let error: String?
    let detail: String?
}

struct ChatMessageDTO: Identifiable, Codable, Hashable {
    let id: Int
    let senderEmail: String
    let content: String
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case senderEmail = "sender_email"
        case content
        case createdAt = "created_at"
    }
}

struct ChatRoomDTO: Identifiable, Codable, Hashable {
    let id: Int
    let name: String?
    let participants: [String]
    let messages: [ChatMessageDTO]
    let createdAt: Date?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case participants
        case messages
        case createdAt = "created_at"
    }
}

final class APIClient {
    static let shared = APIClient()
    private init() {}

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { d in
            let container = try d.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = formatter.date(from: dateString) {
                return date
            }
            if let fallback = ISO8601DateFormatter().date(from: dateString) {
                return fallback
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }
        return decoder
    }

    private func makeRequest(
        path: String,
        method: String,
        body: Encodable? = nil,
        accessToken: String? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: APIConfig.baseURL) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(AnyEncodable(body))
        }

        return request
    }

    private func handleResponse<T: Decodable>(data: Data, response: URLResponse) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        let status = httpResponse.statusCode
        guard (200...299).contains(status) else {
            let message = parseErrorMessage(from: data)
            throw APIError.server(status: status, message: message)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }

    private func parseErrorMessage(from data: Data) -> String? {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }

        return json["detail"] as? String
            ?? json["error"] as? String
            ?? json["message"] as? String
    }

    // MARK: - Auth

    func register(email: String, password: String) async throws {
        let request = try makeRequest(
            path: "auth/register/",
            method: "POST",
            body: RegisterRequest(email: email, password: password)
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        _ = try handleResponse(data: data, response: response) as MessageResponse
    }

    func login(email: String, password: String) async throws -> AuthTokens {
        let request = try makeRequest(
            path: "auth/login/",
            method: "POST",
            body: LoginRequest(email: email, password: password)
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }

    // MARK: - Messaging

    func fetchChatRooms(accessToken: String) async throws -> [ChatRoomDTO] {
        let request = try makeRequest(path: "messaging/rooms/", method: "GET", accessToken: accessToken)
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }

    func fetchMessages(roomID: Int, accessToken: String) async throws -> [ChatMessageDTO] {
        let request = try makeRequest(
            path: "messaging/rooms/\(roomID)/messages/",
            method: "GET",
            accessToken: accessToken
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }

    func sendMessage(roomID: Int, content: String, accessToken: String) async throws -> ChatMessageDTO {
        struct Payload: Encodable { let content: String }
        let request = try makeRequest(
            path: "messaging/rooms/\(roomID)/messages/",
            method: "POST",
            body: Payload(content: content),
            accessToken: accessToken
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }

    func createChatRoom(name: String, accessToken: String) async throws -> ChatRoomDTO {
        struct Payload: Encodable { let name: String }
        let request = try makeRequest(
            path: "messaging/rooms/",
            method: "POST",
            body: Payload(name: name),
            accessToken: accessToken
        )
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response)
    }
}

// MARK: - Helpers

private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        encodeFunc = value.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
