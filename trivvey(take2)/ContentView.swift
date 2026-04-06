//
//  ContentView.swift
//  trivvey
//
//  Created by Sindhu's iPad on 4/6/26.
//

import SwiftUI

struct Question: Codable, Identifiable {
    var id: UUID = UUID()
    let question: String
    let A: String
    let B: String
    let C: String
    let D: String
    let answer: String
    
    enum CodingKeys: String, CodingKey {
           case question, A, B, C, D, answer
       }
}

struct ContentView: View {
    // store questions
    @State private var questions: [Question] = []
    
    var body: some View {
        NavigationStack {
            List(questions) { q in
                NavigationLink(destination: QuestionView(question: q)) {
                    Text(q.question)
                }
            }
            .navigationTitle("Trivvey")
            .toolbar {
                Button(action: {
                    questions.shuffle()
                }) {
                    Image(systemName: "shuffle")

                }
            }
        }
        .onAppear {
                    let url = Bundle.main.url(forResource: "questions", withExtension: "json")!
                    let data = try! Data(contentsOf: url)
                // decode json
                    do {
                        questions = try JSONDecoder().decode([Question].self, from: data)
                    } catch {
                        print("Decoding error:", error)
                    }
                }
            }
        }

struct QuestionView: View {
    
    let question: Question
    @State private var selected: String? = nil
    @State private var showResult = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text(question.question)
                .font(.title3)
                .bold(true)
            HStack(){
                answerButton("A", question.A)
                answerButton("B", question.B)
            }
        
            HStack(){
                answerButton("C", question.C)
               answerButton("D", question.D)
            }
            
            
            if showResult {
                Text(selected == question.answer ? "Correct!" : "Wrong!")
                    .font(.title2)
                
            }
            
            Spacer()
        }
        .padding()
    }
    
    func answerButton(_ key: String, _ text: String) -> some View {
        Button("\(key). \(text)") {
            selected = key
            showResult = true
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1)) // bubble color
        .cornerRadius(12)
    }
    
}


#Preview {
    ContentView()
}

