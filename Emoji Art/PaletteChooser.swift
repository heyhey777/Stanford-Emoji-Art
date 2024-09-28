//
//  PaletteChooser.swift
//  Emoji Art
//
//  Created by Kate on 03/03/2024.
//

// View

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    
    @State private var showPaletteEditor = false
    @State private var showPaletteList = false
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
        .sheet(isPresented: $showPaletteEditor) {
            PaletteEditor(palette: $store.palettes[store.cursorIndex])
                .font(nil) // go to the default font
        }
        .sheet(isPresented: $showPaletteList) {
            NavigationStack {
                EditablePaletteList(store: store)
                    .font(nil)
            }
        }
    }
    
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            gotoMenu
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "+-=/")
                showPaletteEditor = true
            }
            AnimatedActionButton("Delete", systemImage:  "minus.circle", role: .destructive) {
                store.palettes.remove(at: store.cursorIndex)
            }
            AnimatedActionButton("Edit", systemImage: "pencil") {
                showPaletteEditor = true
            }
            AnimatedActionButton("List", systemImage: "list.bullet.rectangle.portrait") {
                showPaletteList = true
            }
        }
    }
    
    private var gotoMenu: some View {
        Menu {
            ForEach(store.palettes) { palette in
                AnimatedActionButton(palette.name) {
                    if let index = store.palettes.firstIndex(where: { $0.id == palette.id }) {
                        store.cursorIndex = index
                    }
                }
            }
            } label: {
                Label("Go To", systemImage: "text.insert")
            }
    }
    
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(/*@START_MENU_TOKEN@*/.identity/*@END_MENU_TOKEN@*/)
    }
}


struct ScrollingEmojis: View {
    let emojis: [String] // each string is an emoji
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init) // converting a string into an array of strings
    }
    
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}


#Preview {
    PaletteChooser()
        .environmentObject(PaletteStore(named: "Preview"))
    
}
