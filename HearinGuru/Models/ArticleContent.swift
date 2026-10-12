import Foundation

struct ArticleSection {
    let heading: String?
    let body: String

    init(heading: String? = nil, body: String) {
        self.heading = heading
        self.body    = body
    }
}

struct ArticleFullContent: Identifiable {
    let id      = UUID()
    let title:  String
    let meta:   String
    let icon:   String          // SF Symbol name
    let sections: [ArticleSection]
}

let articleContents: [ArticleFullContent] = [
    ArticleFullContent(
        title: "How to read your hearing test results — explained simply",
        meta:  "8 min read · Hearing Loss",
        icon:  "waveform",
        sections: [
            ArticleSection(body: "A hearing test, or audiogram, is the most important tool for understanding how well you hear. But for most people, looking at the result sheet feels like reading a foreign language. Here's a plain-English guide."),
            ArticleSection(heading: "What is an audiogram?", body: "An audiogram is a graph that plots the softest sounds you can hear at different pitches (frequencies). The horizontal axis shows frequency in Hertz (Hz) — from low-pitched sounds on the left (250 Hz, like a bass drum) to high-pitched sounds on the right (8000 Hz, like a bird chirp).\n\nThe vertical axis shows loudness in decibels (dB HL). The numbers go from 0 at the top (very quiet) down to 120 at the bottom (extremely loud). The higher your mark sits on the graph, the better your hearing."),
            ArticleSection(heading: "The hearing loss categories", body: "• Normal: 0–25 dB — you can hear whispers\n• Mild: 26–40 dB — you miss soft speech and consonants\n• Moderate: 41–55 dB — speech must be loud to understand\n• Moderately severe: 56–70 dB — you struggle even with raised voices\n• Severe: 71–90 dB — you rely heavily on lip-reading\n• Profound: 91+ dB — you hear very little without amplification"),
            ArticleSection(heading: "Air conduction vs bone conduction", body: "Your audiogram shows two sets of marks — air conduction (AC) and bone conduction (BC). AC tests the full hearing pathway. BC bypasses the outer and middle ear and tests only the inner ear.\n\nIf AC and BC marks sit at the same level, the problem is in the inner ear (sensorineural). If AC is worse than BC, the problem is in the outer or middle ear (conductive)."),
            ArticleSection(heading: "What to do with your results", body: "Share the audiogram with an audiologist who can prescribe the right hearing aid. Mild-to-moderate loss often responds very well to modern digital aids. Don't wait — untreated hearing loss is linked to cognitive decline and social isolation."),
        ]
    ),
    ArticleFullContent(
        title: "Why hearing gets worse after 40 — and what to do",
        meta:  "5 min read · Hearing Loss",
        icon:  "person.fill",
        sections: [
            ArticleSection(body: "Most people assume hearing loss is something that happens to the elderly. But the inner ear starts showing measurable decline from your mid-30s — and by 40, many people have already lost some high-frequency hearing without knowing it."),
            ArticleSection(heading: "The biology behind it", body: "Deep inside your inner ear are roughly 15,000 tiny hair cells that convert sound vibrations into electrical signals for the brain. Unlike most cells in the body, these hair cells cannot regenerate. They are permanently destroyed by loud noise, ageing, and certain medications.\n\nAfter 40, cumulative damage begins to add up. High frequencies go first — the 's', 'f', and 'th' consonants critical for speech clarity."),
            ArticleSection(heading: "Signs it's happening to you", body: "• You ask people to repeat themselves frequently\n• You struggle in noisy restaurants\n• You turn the TV up louder than others prefer\n• Phone calls feel unclear even with good signal\n• You mishear similar-sounding words"),
            ArticleSection(heading: "What you can do", body: "First: get a baseline audiogram. Second: protect your ears now. Every loud event destroys more hair cells. Third: if you already have measurable loss, consider hearing aids early. Research shows early intervention preserves brain plasticity."),
            ArticleSection(heading: "The good news", body: "Modern hearing aids are nearly invisible, Bluetooth-capable, and AI-powered. An audiologist can fit you with a pair matched precisely to your audiogram — not a generic amplifier."),
        ]
    ),
    ArticleFullContent(
        title: "How to protect your hearing from everyday noise",
        meta:  "4 min read · Prevention",
        icon:  "speaker.slash.fill",
        sections: [
            ArticleSection(body: "Noise-induced hearing loss is the most preventable form of hearing loss — and one of the most common. The damage is permanent."),
            ArticleSection(heading: "The 85 dB rule", body: "Damage begins at 85 decibels. At 85 dB (busy traffic, a lawn mower), you have about 8 hours before risk begins. At 100 dB (live music, nightclub), damage can occur in 15 minutes. At 120 dB (jet engine close up), pain and instant damage happen immediately."),
            ArticleSection(heading: "Everyday sounds to watch", body: "• Earphones at 80%+ volume: 90–100 dB. Use the 60/60 rule — no more than 60% volume for 60 minutes.\n• Motorcycles: 95–100 dB. Wear helmet ear inserts.\n• Power tools: 100–110 dB. Always use ear protection.\n• Firecrackers: 150+ dB. Keep at maximum possible distance.\n• Concerts and clubs: 105–115 dB. Use musician's earplugs."),
            ArticleSection(heading: "Protecting yourself without missing out", body: "Musician's earplugs reduce volume by 15–25 dB while preserving clarity. They're small, nearly invisible, and inexpensive. You can enjoy music at a concert without dangerous peak volumes."),
            ArticleSection(heading: "After a loud event", body: "Temporary threshold shift — the muffled sensation after a concert — means your hair cells are stressed. Give your ears 16–18 hours of quiet to recover. If ringing persists for more than a day, see an audiologist."),
        ]
    ),
    ArticleFullContent(
        title: "How to help a family member who won't admit hearing loss",
        meta:  "7 min read · For Families",
        icon:  "person.2.fill",
        sections: [
            ArticleSection(body: "\"I can hear fine — you just mumble.\" If this sounds familiar, you are not alone. Denial is one of the most common responses to hearing loss. Here's how to help without creating conflict."),
            ArticleSection(heading: "Why people deny hearing loss", body: "Hearing loss carries a stigma that vision loss doesn't. Glasses are fashionable; hearing aids still feel like a badge of old age. Many people also don't notice gradual decline — the brain compensates for years by filling in the gaps and lip-reading unconsciously."),
            ArticleSection(heading: "What not to do", body: "• Don't shout or over-enunciate — it feels infantilising\n• Don't have the conversation in front of others — humiliation creates resistance\n• Don't make it about inconvenience to you — it triggers defensiveness\n• Don't give ultimatums"),
            ArticleSection(heading: "What works", body: "Have the conversation one-on-one in a quiet space. Frame it around safety — missed doorbells, emergency announcements. Ask them to do it for you: \"I worry about you. Would you get a hearing test just so we know for sure?\"\n\nMake the first step easy. A free hearing test at home removes the barrier of scheduling an audiologist."),
            ArticleSection(heading: "Managing the adjustment period", body: "New hearing aid users need time. The brain has to relearn sounds it hasn't processed properly in years. Everyday sounds feel suddenly loud. This is normal and passes within 2–6 weeks."),
        ]
    ),
    ArticleFullContent(
        title: "Signs you may have hearing loss — a simple checklist",
        meta:  "3 min read · Hearing Loss",
        icon:  "checkmark.circle.fill",
        sections: [
            ArticleSection(body: "Hearing loss creeps up slowly. Most people wait 7–10 years from first signs to seeking help. Use this checklist to evaluate yourself or someone you care about."),
            ArticleSection(heading: "Communication signs", body: "☐  You frequently ask people to repeat themselves\n☐  You hear speech but struggle to understand it, especially in background noise\n☐  Phone conversations feel unclear even with good signal\n☐  You misunderstand similar-sounding words ('fifteen' vs 'fifty')\n☐  You find yourself watching people's lips to understand them"),
            ArticleSection(heading: "Environment signs", body: "☐  The TV volume feels right to you but others find it too loud\n☐  You can't hear the doorbell or phone ring from another room\n☐  You can't tell which direction a sound is coming from\n☐  Birds and high-pitched sounds seem to have faded"),
            ArticleSection(heading: "Physical signs", body: "☐  You have ringing or buzzing in your ears (tinnitus)\n☐  You have a history of working in noisy environments\n☐  You take medications known to affect hearing (high-dose aspirin, certain antibiotics)"),
            ArticleSection(heading: "What to do", body: "If you checked 3 or more boxes in any section, take the 5-minute hearing test in the Tools tab. If you checked 5 or more across all sections, see an audiologist promptly."),
        ]
    ),
    ArticleFullContent(
        title: "Common questions about hearing loss — answered",
        meta:  "5 min read · FAQ",
        icon:  "questionmark.circle.fill",
        sections: [
            ArticleSection(body: "Hearing loss affects over 1.5 billion people worldwide. Yet there's enormous confusion about what it is, what causes it, and what can be done."),
            ArticleSection(heading: "Can hearing loss be reversed?", body: "In most cases, no. Sensorineural hearing loss (damage to inner ear hair cells) is permanent. However, conductive hearing loss (from blockage or infection) is often treatable with medicine or surgery."),
            ArticleSection(heading: "Are hearing aids the only option?", body: "For sensorineural loss: hearing aids are the primary treatment. For severe to profound loss, cochlear implants are highly effective. For conductive loss: medical treatment often restores hearing without aids."),
            ArticleSection(heading: "Will wearing a hearing aid make my hearing worse?", body: "No. This is one of the most persistent myths. Properly fitted hearing aids amplify only the frequencies you've lost, at the level needed. What does make hearing worse is leaving it untreated — the auditory cortex weakens from lack of stimulation."),
            ArticleSection(heading: "At what age does hearing loss start?", body: "High-frequency loss can begin from age 25 onwards from noise exposure. Age-related loss (presbycusis) typically becomes noticeable after 50. 1 in 3 people over 65 has significant hearing loss."),
        ]
    ),
    ArticleFullContent(
        title: "Tinnitus: causes, symptoms and relief options",
        meta:  "6 min read · Hearing Loss",
        icon:  "ear.trianglebadge.exclamationmark",
        sections: [
            ArticleSection(body: "Tinnitus — the perception of sound without an external source — affects around 15% of adults. For most, it's a mild annoyance. For about 2%, it's severely debilitating."),
            ArticleSection(heading: "What causes tinnitus?", body: "Tinnitus is a symptom, not a disease. It arises when the auditory system produces phantom signals, usually due to:\n\n• Noise-induced hearing loss (most common cause)\n• Age-related hearing loss\n• Ear infections or earwax blockage\n• Certain medications (high-dose aspirin, some antibiotics, diuretics)\n• Head or neck injuries\n• High blood pressure or cardiovascular disease"),
            ArticleSection(heading: "What it sounds like", body: "Tinnitus manifests as ringing, buzzing, hissing, whistling, clicking, or roaring. It can be in one ear, both ears, or appear to come from inside the head. It's often worse in quiet environments — this is why it feels most severe at bedtime."),
            ArticleSection(heading: "Relief options", body: "• Sound therapy: Background sounds (white noise, pink noise, nature sounds) mask the tinnitus signal. The Tinnitus Relief tool in this app provides four sound options.\n\n• Hearing aids: Since tinnitus often accompanies hearing loss, treating the hearing loss reduces tinnitus severity in many patients.\n\n• Cognitive Behavioural Therapy (CBT): The most evidence-backed psychological approach.\n\n• Lifestyle: Reduce caffeine, alcohol, and salt. Exercise regularly. Manage stress."),
            ArticleSection(heading: "When to see a doctor", body: "See a doctor promptly if tinnitus started after a head injury, is only in one ear, is pulsating in rhythm with your heartbeat, or is accompanied by sudden hearing loss."),
        ]
    ),
    ArticleFullContent(
        title: "When should you see a doctor about your hearing?",
        meta:  "4 min read · FAQ",
        icon:  "stethoscope",
        sections: [
            ArticleSection(body: "Many people with hearing loss wait years before seeing a professional. This guide will help you decide when to act."),
            ArticleSection(heading: "See a doctor immediately if:", body: "• You experience sudden hearing loss — waking unable to hear well in one ear is a medical emergency. Get to an ENT within 24–48 hours.\n• Hearing loss follows a head injury or pressure change\n• You have pain, discharge, or bleeding from the ear\n• Tinnitus is only in one ear\n• Dizziness or balance problems accompany hearing changes"),
            ArticleSection(heading: "See a doctor soon (within a few weeks) if:", body: "• You've noticed progressive hearing difficulty over months\n• Your hearing test shows moderate loss or worse\n• You are having social or professional difficulties due to hearing trouble\n• You have children — undetected hearing loss in children significantly impacts speech development"),
            ArticleSection(heading: "GP vs audiologist vs ENT", body: "A GP can rule out simple causes (earwax, infection) and refer you onward. An audiologist performs detailed hearing tests and fits hearing aids. An ENT handles medical and surgical conditions. For most people, an audiologist is the right first call."),
            ArticleSection(heading: "What to expect at an appointment", body: "The audiologist will take a history, examine your ears, and run a standard hearing test in a soundproof booth. The whole appointment takes about 45–60 minutes. You'll leave with an audiogram and a recommendation for hearing aids or further investigation."),
        ]
    ),
]
