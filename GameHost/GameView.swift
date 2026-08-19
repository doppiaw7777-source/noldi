import SwiftUI
import MemForgeKit

struct GameView: View {
    @StateObject private var store = MemForgeStore(values: [
        MemForgeValue(name: "Coins", value: 1500),
        MemForgeValue(name: "Gems", value: 25),
        MemForgeValue(name: "Health", value: 100),
        MemForgeValue(name: "Score", value: 7500)
    ])

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .gray.opacity(0.65)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Spacer(minLength: 20)

                Text("GAMEHOST")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.white)

                Text("Authorized MemForgeKit test build")
                    .foregroundStyle(.white.opacity(0.7))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    ForEach(store.values) { item in
                        VStack(spacing: 6) {
                            Text(item.name.uppercased())
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)
                            Text("\(item.value)")
                                .font(.system(.title2, design: .monospaced))
                                .fontWeight(.bold)
                            if item.frozen {
                                Label("FROZEN", systemImage: "lock.fill")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: 105)
                        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 18))
                    }
                }

                Button {
                    store.mutateForDemo()
                } label: {
                    Label("Run game tick", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)

                Text(store.status)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.75))

                Text("Apri l'ingranaggio flottante per modificare e bloccare in tempo reale i valori registrati da questa build di test.")
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.7))
                    .multilineTextAlignment(.center)

                Spacer()
            }
            .padding(22)

            MemForgeOverlay(store: store)
        }
    }
}