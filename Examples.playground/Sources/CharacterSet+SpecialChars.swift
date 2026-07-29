import Foundation

extension CharacterSet {
    public static var specialChars: Self {
        CharacterSet(charactersIn: "!?@#$%^&*()|\\/<>,.~`_+-=")
    }
}
