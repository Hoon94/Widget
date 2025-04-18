//
//  ContentView.swift
//  RepoWatcher
//
//  Created by Daehoon Lee on 3/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var newRepo = ""
    @State private var repos: [String] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Ex. sallen0400/swift-news", text: $newRepo)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .textFieldStyle(.roundedBorder)
                    
                    Button {
                        if !repos.contains(newRepo) && !newRepo.isEmpty {
                            repos.append(newRepo)
                            UserDefaults.shared.set(repos, forKey: UserDefaults.repoKey)
                            newRepo = ""
                        } else {
                            print("repo already exists or name is empty")
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Saved Repos")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                    
                    List(repos, id: \.self) { repo in
                        Text(repo)
                            .swipeActions {
                                Button("Delete") {
                                    
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Repo List")
        }
    }
}

#Preview {
    ContentView()
}
