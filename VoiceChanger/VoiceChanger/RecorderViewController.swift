//
//  RecorderViewController.swift
//  VoiceChanger
//
//  Created by Rhidian Cody on 19/03/2015.
//  Copyright (c) 2015 Lloyd Cody. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordAudioButtonPressed(sender: UIButton) {
        println("Recording Started");
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String;
        var currentDateTime = NSDate();
        var dateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "ddMMyyyy-HHmmss";
        var recordingName = dateFormatter.stringFromDate(currentDateTime) + ".wav";
        var pathArray = [dirPath, recordingName];
        let filePath = NSURL.fileURLWithPathComponents(pathArray);
        println("FILE PATH:", filePath);
        
        // set up audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryMultiRoute, error: nil)
        
        // init and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self;
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        stopRecordingButton.hidden = false;
        recordButton.hidden = true;
    }
    
    @IBAction func iconrecordButtonPressed(sender: UIButton) {
        if (!recordButton.hidden) {
            recordAudioButtonPressed(sender);
        } else {
            stopRecordingButtonPressed(sender);
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // save the audio
            recordedAudio = RecordedAudio();
            recordedAudio.filePathUrl = recorder.url;
            recordedAudio.title = recorder.url.lastPathComponent;
            
            // perform segue
            performSegueWithIdentifier("stopRecording", sender: recordedAudio);
        } else {
            println("Failed to record file");
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playVC:PlayViewController = segue.destinationViewController as PlayViewController;
            let data = sender as RecordedAudio;
            playVC.receivedAudio = data;
            
            recordButton.hidden = false;
            stopRecordingButton.hidden = true;
        }
    }

    @IBAction func stopRecordingButtonPressed(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        println("Recording Stopped");
    }

}

