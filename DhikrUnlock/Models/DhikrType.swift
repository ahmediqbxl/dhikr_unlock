import Foundation

enum DhikrType: String, CaseIterable, Codable, Identifiable {
    case subhanAllah
    case alhamdulillah
    case allahuAkbar
    case laIlahaIllallah
    case astaghfirullah
    case salawat

    var id: String { rawValue }

    var arabicText: String {
        switch self {
        case .subhanAllah: return "سُبْحَانَ اللَّهِ"
        case .alhamdulillah: return "الْحَمْدُ لِلَّهِ"
        case .allahuAkbar: return "اللَّهُ أَكْبَرُ"
        case .laIlahaIllallah: return "لَا إِلَٰهَ إِلَّا اللَّهُ"
        case .astaghfirullah: return "أَسْتَغْفِرُ اللَّهَ"
        case .salawat: return "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ"
        }
    }

    var transliteration: String {
        switch self {
        case .subhanAllah: return "SubhanAllah"
        case .alhamdulillah: return "Alhamdulillah"
        case .allahuAkbar: return "Allahu Akbar"
        case .laIlahaIllallah: return "La ilaha illallah"
        case .astaghfirullah: return "Astaghfirullah"
        case .salawat: return "Salawat"
        }
    }

    var meaning: String {
        switch self {
        case .subhanAllah: return "Glory be to Allah"
        case .alhamdulillah: return "All praise is due to Allah"
        case .allahuAkbar: return "Allah is the Greatest"
        case .laIlahaIllallah: return "There is no god but Allah"
        case .astaghfirullah: return "I seek forgiveness from Allah"
        case .salawat: return "O Allah, send blessings upon Muhammad"
        }
    }

    var defaultTarget: Int { 33 }
}
