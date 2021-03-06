/// Provides a default value for missing `Decodable` data.
///
/// `DefaultCodableStrategy` provides a generic strategy type that the `DefaultCodable` property wrapper can use to provide a reasonable default value for missing Decodable data.
public protocol DefaultCodableStrategy {
    associatedtype RawValue: Codable
    
    static var defaultValue: RawValue { get }
}

/// Decodes values with a reasonable default value
///
/// `@Defaultable` attempts to decode a value and falls back to a default type provided by the generic `DefaultCodableStrategy`.
@propertyWrapper
public struct DefaultCodable<Default: DefaultCodableStrategy>: Codable {
    public var wrappedValue: Default.RawValue
    
    public init(wrappedValue: Default.RawValue) {
        self.wrappedValue = wrappedValue
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = (try? container.decode(Default.RawValue.self)) ?? Default.defaultValue
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension DefaultCodable: Equatable where Default.RawValue: Equatable { }
extension DefaultCodable: Hashable where Default.RawValue: Hashable { }
