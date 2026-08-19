import SwiftUI

public struct MemForgeOverlay: View {
    @ObservedObject private var store: MemForgeStore
    @State private var isOpen = false
    @State private var selectedID: UUID?
    @State private var editValue = ""
    @State private var dragOffset = CGSize.zero
    @State private var accumulatedOffset = CGSize(width: 0, height: 100)

    public init(store: MemForgeStore) {
        self.store = store
    }

    public var body: some View {
        ZStack(alignment: .trailing) {
            if isOpen {
                panel
                    .padding(.trailing, 18)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            Button {
                withAnimation(.spring(response: 0.28, dampingFraction: 0.82)) {
                    isOpen.toggle()
                    if isOpen && selectedID == nil {
                        selectedID = store.values.first?.id
                        syncEditValue()
                    }
                }
            } label: {
                Image(systemName: isOpen ? "xmark" : "gearshape.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(width: 54, height: 54)
                    .background(.black.opacity(0.92), in: Circle())
                    .overlay(Circle().stroke(.white.opacity(0.18), lineWidth: 1))
                    .shadow(radius: 12)
            }
            .padding(.trailing, 10)
            .offset(
                x: accumulatedOffset.width + dragOffset.width,
                y: accumulatedOffset.height + dragOffset.height
            )
            .gesture(
                DragGesture()
                    .onChanged { dragOffset = $0.translation }
                    .onEnded { value in
                        accumulatedOffset.width += value.translation.width
                        accumulatedOffset.height += value.translation.height
                        dragOffset = .zero
                    }
            )
            .zIndex(2)
        }
    }

    private var selectedValue: MemForgeValue? {
        guard let selectedID else { return nil }
        return store.values.first(where: { $0.id == selectedID })
    }

    private var panel: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "memorychip.fill")
                Text("MemForgeKit").font(.headline)
                Spacer()
                Text("TEST BUILD")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
            }

            if store.values.isEmpty {
                Text("No registered values")
                    .foregroundStyle(.secondary)
            } else {
                Picker("Registered value", selection: Binding(
                    get: { selectedID ?? store.values.first?.id },
                    set: { selectedID = $0; syncEditValue() }
                )) {
                    ForEach(store.values) { item in
                        Text(item.name).tag(Optional(item.id))
                    }
                }

                if let selectedValue {
                    HStack {
                        Text("Current")
                        Spacer()
                        Text("\(selectedValue.value)")
                            .font(.body.monospacedDigit().bold())
                    }

                    TextField("New value", text: $editValue)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        guard let newValue = Int(editValue) else {
                            store.status = "Invalid numeric value"
                            return
                        }
                        store.setValue(id: selectedValue.id, to: newValue)
                        syncEditValue()
                    } label: {
                        Label("Apply value", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Toggle(
                        "Freeze value",
                        isOn: Binding(
                            get: { selectedValue.frozen },
                            set: { store.setFrozen(id: selectedValue.id, frozen: $0) }
                        )
                    )
                }

                Divider()

                Button(role: .destructive) {
                    store.reset()
                    selectedID = store.values.first?.id
                    syncEditValue()
                } label: {
                    Label("Reset registered values", systemImage: "arrow.counterclockwise")
                }

                Text(store.status)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(width: 320)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(radius: 24)
    }

    private func syncEditValue() {
        if let selectedValue {
            editValue = String(selectedValue.value)
        }
    }
}