//
//  PlayViewController.swift
//  VoiceChanger
//
//  Created by Rhidian Cody on 19/03/2015.
//  Copyright (c) 2015 Lloyd Cody. All rights reserved.
//

import UIKit
import AVFoundation

class PlayViewController: UIViewController {
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioPlayerNode:AVAudioPlayerNode!
    var changePitchEffect:AVAudioUnitTimePitch!
    var audioFileBuffer:AVAudioPCMBuffer!
    
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var rateSlider: UISlider!
    @IBOutlet weak var pitchSlider: UISlider!
    @IBOutlet weak var loopSwitch: UISwitch!
    @IBOutlet weak var stopPlaybackButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudioButtonPressed(sender: UIButton) {
        playAudio();
    }
    
    func playAudio() {
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil);
        let audioFormat = audioFile.processingFormat;
        let audioFrameCount = UInt32(audioFile.length);
        audioFileBuffer = AVAudioPCMBuffer(PCMFormat: audioFormat, frameCapacity: audioFrameCount);
        audioFile.readIntoBuffer(audioFileBuffer, error: nil);
        
        audioEngine = AVAudioEngine();
        audioPlayerNode = AVAudioPlayerNode();
        changePitchEffect = AVAudioUnitTimePitch();

        var mainMixer = audioEngine.mainMixerNode;
        audioEngine.attachNode(audioPlayerNode);
        audioEngine.connect(audioPlayerNode, to:mainMixer, format: audioFileBuffer.format);
        
        changePitchEffect.pitch = pitchSlider.value;
        changePitchEffect.rate = rateSlider.value;
        audioEngine.attachNode(changePitchEffect);
        
        audioEngine.connect(mainMixer, to: changePitchEffect, format: nil);
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil);
        
        audioEngine.startAndReturnError(nil);
        audioPlayerNode.play();
        audioPlayerNode.scheduleBuffer(audioFileBuffer, atTime: nil, options:((loopSwitch.on) ? .Loops : nil), completionHandler: nil);
        
        stopPlaybackButton.hidden = false;
        playButton.hidden = true;
    }
        
    @IBAction func loopSwitchChanged(sender: UISwitch) {

    }
    
    @IBAction func rateSliderValueChanged(sender: UISlider) {
        if ((changePitchEffect) != nil) {
            changePitchEffect.rate = rateSlider.value;
        }
    }
    
    @IBAction func pitchSliderValueChanged(sender: UISlider) {
        if ((changePitchEffect) != nil) {
            changePitchEffect.pitch = pitchSlider.value;
        }
    }
    
    @IBAction func stopPlaybackButtonPressed(sender: UIButton) {
        if (audioPlayerNode != nil) {
            audioPlayerNode.stop();
        }
        
        stopPlaybackButton.hidden = true;
        playButton.hidden = false;
    }
}

