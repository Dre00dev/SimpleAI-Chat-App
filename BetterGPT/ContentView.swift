//todo move api key to somewhere safe

//add all chatgpt files
import OpenAISwift
import SwiftUI

struct Prompt {
  var title: String
  var text: String
}
let prompts = [
  Prompt(title: "English Translator and Improver", text: "I want you to act as an English translator, spelling corrector and improver. I will speak to you in any language and you will detect the language, translate it and answer in the corrected and improved version of my text, in English. I want you to replace my simplified A0-level words and sentences with more beautiful and elegant, upper level English words and sentences. Keep the meaning same, but make them more literary. I want you to only reply the correction, the improvements and nothing else, do not write explanations. My statement is: Bom Dia, praver em conhecer voce! "),
  Prompt(title: "Travel Guide", text: "I want you to act as a travel guide. I will write you my location and you will suggest a place to visit near my location. In some cases, I will also give you the type of places I will visit. You will also suggest me places of similar type that are close to my first location. My suggestion request is: I am in New York City and I love Art"),
  Prompt(title: "Story Teller", text: "I want you to act as a storyteller. You will come up with entertaining stories that are engaging, imaginative and captivating for the audience. It can be fairy tales, educational stories or any other type of stories which has the potential to capture people's attention and imagination. Depending on the target audience, you may choose specific themes or topics for your storytelling session e.g., if it’s children then you can talk about animals; If it’s adults then history-based tales might engage them better etc. My first request is: I Need an interesting story on perseverance."),
  Prompt(title: "Motivational Coach", text: "I want you to act as a motivational coach. I will provide you with some information about someone's goals and challenges, and it will be your job to come up with strategies that can help this person achieve their goals. This could involve providing positive affirmations, giving helpful advice or suggesting activities they can do to reach their end goal. My request is: I need help motivating myself to stay disciplined while studying for an upcoming exam"),
  Prompt(title: "Author", text: "I want you to act as a novelist. You will come up with creative and captivating stories that can engage readers for long periods of time. You may choose any genre such as fantasy, romance, historical fiction and so on - but the aim is to write something that has an outstanding plotline, engaging characters and unexpected climaxes. My request is: I need to write a science-fiction novel set in the future."),
  Prompt(title: "Math Teacher", text: "I want you to act as a math teacher. I will provide some mathematical equations or concepts, and it will be your job to explain them in easy-to-understand terms. This could include providing step-by-step instructions for solving a problem, demonstrating various techniques with visuals or suggesting online resources for further study. My  request is :I need help understanding how probability works."),
  Prompt(title: "Career Counselor", text: "I want you to act as a career counselor. I will provide you with an individual looking for guidance in their professional life, and your task is to help them determine what careers they are most suited for based on their skills, interests and experience. You should also conduct research into the various options available, explain the job market trends in different industries and advice on which qualifications would be beneficial for pursuing particular fields. My request is: I want to advise someone who wants to pursue a potential career in software engineering."),
  Prompt(title: "AI-Assisted Doctor", text: "I want you to act as an AI assisted doctor. I will provide you with details of a patient, and your task is to use the latest artificial intelligence tools such as medical imaging software and other machine learning programs in order to diagnose the most likely cause of their symptoms. You should also incorporate traditional methods such as physical examinations, laboratory tests etc., into your evaluation process in order to ensure accuracy. My first request is: The patient has a cold what over the counter medicine should he get."),
  Prompt(title: "Chef", text: "I require someone who can suggest delicious recipes that includes foods which are nutritionally beneficial but also easy & not time consuming enough therefore suitable for busy people like us among other factors such as cost effectiveness so overall dish ends up being healthy yet economical at same time! My request: Something light yet fulfilling that could be cooked quickly during lunch break"),
  Prompt(title: "Fancy Title Generator", text: "I want you to act as a fancy title generator. I will type keywords via comma and you will reply with fancy titles. my first keywords are api,test,automation"),
  Prompt(title: "Dream Interpreter", text: "I want you to act as a dream interpreter. I will give you descriptions of my dreams, and you will provide interpretations based on the symbols and themes present in the dream. Do not provide personal opinions or assumptions about the dreamer. Provide only factual interpretations based on the information given. My first dream is: about being chased by a giant spider."),
  Prompt(title: "Password Generator", text: "I want you to act as a password generator for individuals in need of a secure password. I will provide you with keywords to include or incorporate. Your task is to generate a complex password using these inputs and provide it to me. Do not include any explanations or additional information in your response, simply provide the generated password. My keywords are: Dog, Cat "),
  Prompt(title: "Find a better word", text: "I want you to act as a synonyms provider. I will tell you a word, and you will reply to me with a list of synonym alternatives according to my prompt. Provide a max of 10 synonyms per prompt.  Words should exist. Do not write explanations.  My word is: Walk"),
  Prompt(title: "What To Buy", text: "I want you to act as my personal shopper. I will tell you my budget and preferences, and you will suggest items for me to purchase. You should only reply with the items you recommend, and nothing else. Do not write explanations. My first request is: I have a budget of $100 and I am looking for a new dress."),
  Prompt(title: "Legal Advisor", text: "I want you to act as my legal advisor. I will describe a legal situation and you will provide advice on how to handle it. You should only reply with your advice, and nothing else. Do not write explanations. My request is: I am involved in a car accident and I am not sure what to do."),
  Prompt(title: "Emergency Response Professional", text: "I want you to act as my first aid traffic or house accident emergency response crisis professional. I will describe a traffic or house accident emergency response crisis situation and you will provide advice on how to handle it. You should only reply with your advice, and nothing else. Do not write explanations. My  request is: My toddler drank a bit of bleach and I am not sure what to do."),
    ]

final class ViewModel: ObservableObject {
    init() {}
    
    private var client: OpenAISwift?
    
    func setup(){
        client = OpenAISwift(authToken: )//add chatgpt api key
    }
    func send(text: String, completion: @escaping (String) -> Void){
        client?.sendCompletion(
            with: text,
            maxTokens: 500,
            completionHandler: { result in
                switch result {
                case .success(let model):
                    let output = model.choices.first?.text ?? ""
                    completion(output)
                case .failure:
                    break
                }
            })
    }
}


struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]() //collection of the strings
    @State private var selectedPrompt: Prompt?

    
    
    var body: some View {
        NavigationView{
        VStack (alignment: .leading) {
            List {
                Section(header: Text("Use and edit these prompts!")) {
                    ForEach(prompts, id: \.title) { prompt in
                        Button(action: {
                            self.selectedPrompt = prompt
                            text = prompt.text
                        }) {
                            Text(prompt.title)
                        }
                    }
                }
            }
            //Divider()
            Section(header: Text("Chat Log").font(.largeTitle)) {
                ScrollView{
                    ForEach(models, id: \.self){ string in
                        Text(string)
                    }
                }
                Divider()
                
                HStack {
                    if #available(iOS 16.0, *) {
                        TextField("Type Here...", text: $text, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        TextField("Type Here...", text: $text)
                            .textFieldStyle(.roundedBorder)
                            
                    }
                    Button("Send"){
                        send()
                    }
                }
            }
        }
        .onAppear{
            viewModel.setup()
        }
        }
        .padding()
    }
    func send(){
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        models.append("Me: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                self.models.append("ChatGPT: \(response)")  //"ChatGPT:" +response
                self.text = ""
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

