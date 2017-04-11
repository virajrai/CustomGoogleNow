//
//  testViewController.swift
//  RITW.HelloWorld
//
//  Created by VIraj Rai on 3/4/17.
//  Copyright © 2017 SmackInnovations. All rights reserved.
//

import UIKit
import Speech
import Contacts
import MessageUI

class testViewController: UIViewController,SFSpeechRecognizerDelegate,MFMessageComposeViewControllerDelegate {

    @IBAction func backButtonn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var textView: UITextField!
    
    
    @IBAction func microphoneTapped(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setTitle("Start Recording", for: .normal)
            let text = textView.text
            
            var array = text?.characters.split{$0 == " "}.map(String.init)
            //let index = text?.index((text?.startIndex)!, offsetBy: 5)
            print(array?[0] ?? "LOL")
            
            if (array?[0].lowercased() == "call"){
                array?.removeFirst()
                fetchContactAndCall(name: array!.joined(separator: " "))
            }
            else if (array?[0].lowercased() == "message" || array?[0].lowercased() == "text"){
                let name = array?[1]
                array?.removeFirst()
                array?.removeFirst()
                fetchContactAndSMS(name: name, body: array!.joined(separator: " "))
            }
            
            else{
                print(text ?? "text NULL")
                google(name: text,weather: true)
            }


            
            
        } else {
            startRecording()
            microphoneButton.setTitle("Stop Recording", for: .normal)
            
            
            
        }
    }
    
    /*
     
     
    
*/
    
    func google(name:String!,weather:Bool){
        
        // Read textValue user inputs into userNameValue variable
        
        var array = name?.characters.split{$0 == " "}.map(String.init)
        let userNameValue = array!.joined(separator: "+")
        
        print(userNameValue)
        // Check of userNameValue is not empty
        if (userNameValue.isEmpty)
        {
            return
        }
        
        
        let scriptUrl = "https://www.google.com/"
        // Add one parameter
        let urlWithParams = scriptUrl + "search?q=\(userNameValue.lowercased())"
        // Create NSURL Ibject
        let myUrl = NSURL(string: urlWithParams);
        print(urlWithParams)
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl! as URL);
        
        request.addValue(	"Mozilla/5.0 (X11; Linux i686) " +
            "AppleWebKit/537.17 (KHTML, like Gecko) " +
            "Chrome/24.0.1312.27 Safari/537.17", forHTTPHeaderField: "User-Agent")
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        // If needed you could add Authorization header value
        // Add Basic Authorization
        /*
         let username = "myUserName"
         let password = "myPassword"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
         let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         */
        
        // Or it could be a single Authorization Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            //print("responseString = \(responseString)")
            
            
            if name.range(of: "weather") != nil {
                
                print("entered if")
                
                
                let list = ["Mostly Cloudy", "Cloudy", "Smoke", "Haze", "Mostly Sunny", "Partly Cloudy", "Scattered Thunderstorms", "Scattered Showers", "Showers", "Rain", "Sunny","Clear with periodic clouds"]
                print("list set")
                var day = (responseString?.range(of: "Monday").toRange()?.lowerBound)
                
                if day == -1{
                    day=0
                }

                print("day is set")
                
                print(responseString?.range(of: "Sunny").toRange()?.lowerBound)
                
                var index_list=[1000000000]
                var weather_type = ["failure"]
                print("array initialized")
                for typeWeather in list{
                    print(typeWeather)
                    let index = responseString?.range(of: typeWeather).toRange()?.lowerBound
                    print(index)
                    if index != nil{
                        index_list.append(index!)
                        weather_type.append(typeWeather)
                    }
                }
                
                print("arrays populted")
                
                var min_index = 0
                let len = index_list.count
                
                for	i in 0...(len-1){
                    if index_list[i] < index_list[min_index]{
                        min_index = i
                    }
                }
                
                print("min index found")
                
                print(weather_type[min_index])
                
                self.textView.text = weather_type[min_index]
 
            
            }
            
            if true{
                
                print("entered if")
                
                let teamName = array?[0]
                print("Teamname" + teamName!)
                let stri = "[(][0123456789]+-[0123456789]+[)]"
                let stringResp = responseString as! String
                let game_done = responseString?.range(of: "Final").toRange()?.lowerBound
               
                let team_index = responseString?.range(of: teamName!).toRange()?.lowerBound
                let hyphen = responseString?.substring(to: game_done!).substring(from: stringResp.index(stringResp.startIndex, offsetBy: team_index!)).range(of: " - ")?.lowerBound
                //print(responseString?.substring(to: game_done!).substring(from: stringResp.index(stringResp.startIndex, offsetBy: team_index!)))
                if (hyphen == nil){
                    var temp = stringResp.range(of: stri,options: .regularExpression)
                    let first_info = stringResp.substring(with: temp!)
                    let first_index = stringResp.range(of: first_info)?.lowerBound
                    var temp2 = stringResp.substring(from: first_index!)
                        
                    temp = temp2.range(of: "[>][0-9]+[<]",options: .regularExpression)
                    var first_score = temp2.substring(with: temp!)
                    
                    first_score = first_score.substring(from: first_score.index(first_score.startIndex, offsetBy: 1))
                    first_score = first_score.substring(to: first_score.index(first_score.endIndex, offsetBy: -1))
                    
                    var second_string = stringResp.substring(from: first_index!)
                    second_string = second_string.substring(from: second_string.index(second_string.startIndex, offsetBy: first_info.characters.count))
                    temp = second_string.range(of: stri,options: .regularExpression)
                    let second_info = second_string.substring(with: temp!)
                    let second_index = second_string.range(of: second_info)?.lowerBound
                    temp2 = second_string.substring(from: second_index!)
                    
                    temp = temp2.range(of: "[>][0-9]+[<]",options: .regularExpression)
                    var second_score = temp2.substring(with: temp!)
                    
                    second_score = second_score.substring(from: second_score.index(second_score.startIndex, offsetBy: 1))
                    second_score = second_score.substring(to: second_score.index(second_score.endIndex, offsetBy: -1))
                    
                    var second = stringResp.substring(from: first_index!)
                    var temp3 = second.range(of: second_info)
                    second = second.substring(to: (temp3?.lowerBound)!)
                    
                    var teamSecond = false
                    
                    if (second.range(of: teamName!)?.lowerBound != nil){
                        teamSecond = true
                    }
                    
                    print(first_info)
                    print(first_score)
                    print(second_score)
                    print(teamSecond)
                    print("insdie fi")
 
                } else{
                    let scoreRange = stringResp.range(of: "[0-9]+ - [0-9]+",options: .regularExpression)
                    let scores = stringResp.substring(with: scoreRange!)
                    let firstScoreRange = scores.range(of: "[0-9]+",options: .regularExpression)
                    let first_score = scores.substring(with: firstScoreRange!)
                    let secondScoreRange = scores.substring(from: (firstScoreRange?.upperBound)!).range(of: "[0-9]+",options: .regularExpression)
                    let second_score = scores.substring(from: (firstScoreRange?.upperBound)!).substring(with: secondScoreRange!)
                    print(first_score)
                    print(second_score)
                    let score_index = scoreRange?.lowerBound
                    var teamListedSecond = false
                    if (stringResp.substring(to: score_index!).range(of: teamName!) != nil){
                        teamListedSecond = true
                    }
                    print(teamListedSecond)
                    
                }
                
                
            }
            
            /*
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
 */
            
        }
        
        task.resume()
        
    }
    
    
    
    
    
    
    
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func fetchContactAndSMS(name:String!,body:String!){
        print(name)
        let store = CNContactStore()
        do{
            let contacts = try store.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: name), keysToFetch:[CNContactPhoneNumbersKey as CNKeyDescriptor,])
            
            let number = (contacts[0].phoneNumbers[0].value ).value(forKey: "digits")as! String
            print(number)
            var messageVC = MFMessageComposeViewController()
            
            messageVC.body = body;
            messageVC.recipients = [number]
            messageVC.messageComposeDelegate = self;
            
            self.present(messageVC, animated: false, completion: nil)
            
        } catch{
            
            print("error")
        }
    }
    
    
    
    func fetchContactAndCall(name:String!){
        print(name)
        let store = CNContactStore()
        do{
            let contacts = try store.unifiedContacts(matching: CNContact.predicateForContacts(matchingName: name), keysToFetch:[CNContactPhoneNumbersKey as CNKeyDescriptor,])
            
            let number = (contacts[0].phoneNumbers[0].value ).value(forKey: "digits")as! String
            print(number)
            if let url = NSURL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url as URL) {
                UIApplication.shared.openURL(url as URL)
            }
            
        } catch{
            
            print("error")
        }
        
    }

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        microphoneButton.isEnabled = false  //2
        
        speechRecognizer?.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
        microphoneTapped(UIButton.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startRecording() {
        //var timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.traceText), userInfo: nil, repeats: true);
        /*let backgroundQueue = DispatchQueue(label: "com.app.queue",
                                            qos: .background,
                                            target: nil)
        DispatchQueue.
        backgroundQueue.async {
            self.traceText()
        }*/
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        

        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
                print(self.textView.text!)
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
        
        
    }
    
    var originalText = ""
    var templateText = "Say something, I'm listening!"
    var current = ""
    
    
    
    func traceText(){
        print("Started tracing")
        var current = self.textView.text
        
        while(current == "" || current == "Say something, I'm listening!"){
            current = self.textView.text
        }
        
        print("Some text detected")
        var startTime = Double(DispatchTime.now().uptimeNanoseconds)
        
        var interval = Double(DispatchTime.now().uptimeNanoseconds) - startTime
        
        
        while(true){
            if (current != self.textView.text){
                current = self.textView.text
                startTime = Double(DispatchTime.now().uptimeNanoseconds)
                continue
            }
            interval = Double(DispatchTime.now().uptimeNanoseconds) - startTime
            interval/=1000*1000
            
            print(interval)
            if (interval>=120){
                break
            }
        }
        print("Ended tracing!!")
        print(textView.text)
        microphoneTapped(UIButton.self)
        
    }
    
    
    
    
    
    @IBAction func startEdit(_ sender: Any) {
        print("Editing started")
    }
    
    
    @IBAction func editEnded(_ sender: Any) {
        print("Editing ended")
    }
    
    

    @IBAction func valueChanged(_ sender: Any) {
        print("Value changed to \(self.textView.text)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
