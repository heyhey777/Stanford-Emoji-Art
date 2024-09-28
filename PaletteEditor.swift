//
//  PaletteEditor.swift
//  Emoji Art
//
//  Created by Kate on 07/03/2024.
//

import SwiftUI

struct PaletteEditor: View {
   @Binding var palette: Palette
    
    private let emojiFont = Font.system(size: 40)
    
    @State private var emojisToAdd: String = ""
    
    enum Focused {
        case name
        case addEmojis
    }
    
    @FocusState private var focused: Focused?
    
    
    var body: some View {
        Form {
            Section(header: Text("Name")) {
                TextField("Name", text: $palette.name)
                    .focused($focused, equals: .name)
            }
            Section(header: Text("Emojis")) {
                TextField("Add emojis here", text: $emojisToAdd)
                    .font(emojiFont)
                    .onChange(of: emojisToAdd) { emojisToAdd in
                        palette.emojis = (emojisToAdd + palette.emojis)
                            .filter { $0.isEmoji }
                            .uniqued
                    }
                removeEmojis
            }
        }
            .frame(minWidth: 300, minHeight: 350)
            .onAppear {
                if palette.name.isEmpty {
                    focused = .name
                } else {
                    focused = .addEmojis
                }
                
            }
    }
    
    var removeEmojis: some View {
        VStack(alignment: .trailing) {
            Text("Tap to remove emojis").font(.caption).foregroundColor(.gray)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                palette.emojis.remove(emoji.first!)
                                emojisToAdd.remove(emoji.first!)
                            }
                        }
                }
            }
        }
        .font(emojiFont)
    }
    
}

struct PaletteEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State private var palette = PaletteStore(named: "Preview").palettes.first!
        var body: some View {
            PaletteEditor(palette:  $palette)
        }
    }
    
    static var previews: some View {
        Preview()
    }
}