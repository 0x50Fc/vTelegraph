//
//  ViewController.m
//  Sample
//
//  Created by Zhang Hailong on 13-8-22.
//  Copyright (c) 2013年 hailong.org. All rights reserved.
//

#import "ViewController.h"


#import <AudioToolbox/AudioToolbox.h>

@interface ViewController (){
    AudioQueueRef _queue;
    AudioQueueBufferRef _buffer;
    AudioStreamBasicDescription _format;
}

@end

static void ViewController_AudioQueueOutputCallback(
                                                  void *                  inUserData,
                                                  AudioQueueRef           inAQ,
                                                  AudioQueueBufferRef     inBuffer){
	
    
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _format.mFormatID = kAudioFormatLinearPCM;
    _format.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger;
    _format.mChannelsPerFrame = 1;
    _format.mBitsPerChannel = 16;
    _format.mFramesPerPacket = 1;
    _format.mBytesPerPacket =  2;
    _format.mBytesPerFrame = 2;
    _format.mSampleRate = 8000;
    
    OSStatus status;
    
    status = AudioQueueNewOutput(&_format, ViewController_AudioQueueOutputCallback, self, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &_queue);
    
    int bufferSize = 8000;
    short * p;
    short v = 32768;
    
    AudioQueueAllocateBuffer(_queue,bufferSize,&_buffer);
   
    memset(_buffer->mAudioData, 0, bufferSize);
    
    p = (short *)_buffer->mAudioData;
    
    for(int i=0;i<32;i++){
        *p = v;
        p ++;
    }
    
    _buffer->mAudioDataByteSize = bufferSize;
    
    AudioQueueEnqueueBuffer(_queue, _buffer, 0, NULL);
    
    status = AudioQueuePrime(_queue, 0, NULL);
    
    AudioQueueSetParameter(_queue, kAudioQueueParam_Volume, 1.0);
    
    status = AudioQueueStart(_queue, NULL);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
