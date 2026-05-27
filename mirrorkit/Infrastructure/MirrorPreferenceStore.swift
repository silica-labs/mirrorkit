import Foundation

final class MirrorPreferenceStore {
    static let shared = MirrorPreferenceStore()

    private let defaults = UserDefaults.standard
    private let keyMirror = "mirrorkit.selectedMirrorId"

    var selectedMirrorId: String? {
        get { defaults.string(forKey: keyMirror) }
        set { defaults.set(newValue, forKey: keyMirror) }
    }
}
