//
//  ViewController.swift
//  MetalTest2
//
//  Created by 福山帆士 on 2020/07/23.
//  Copyright © 2020 福山帆士. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    private let device = MTLCreateSystemDefaultDevice()!
    
    private var commandQueue: MTLCommandQueue!
    
    private var texture: MTLTexture!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myMtkView = MTKView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), device: device)
        
        view.addSubview(myMtkView)
        
        myMtkView.delegate = self
        
        commandQueue = device.makeCommandQueue()
        
        let textureLoader = MTKTextureLoader(device: device)
        
        texture = try! textureLoader.newTexture(
            name: "red",
            scaleFactor: view.contentScaleFactor,
            bundle: nil)
        
        myMtkView.colorPixelFormat = texture.pixelFormat
        
        myMtkView.enableSetNeedsDisplay = true
        myMtkView.framebufferOnly = false
        
        myMtkView.setNeedsDisplay()
        
    }


}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
        
        guard let drawwble = view.currentDrawable else {
            fatalError()
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()!
        
        let blitEncoder = commandBuffer.makeBlitCommandEncoder()!
        
        let w = min(texture.width, drawwble.texture.width)
        let h = min(texture.height, drawwble.texture.height)
        
        // コピー & エンコード
        blitEncoder.copy(from: texture,
                         sourceSlice: 0,
                         sourceLevel: 0,
                         sourceOrigin: MTLOrigin(x: 0, y: 0, z: 0),
                         sourceSize: MTLSizeMake(w, h, texture.depth),
                         to: drawwble.texture,
                         destinationSlice: 0,
                         destinationLevel: 0,
                         destinationOrigin: MTLOrigin(x: 0, y: 0, z: 0))
        
        blitEncoder.endEncoding()
        
        commandBuffer.present(drawwble) //
        
        commandBuffer.commit() // エンキュー
        
        commandBuffer.waitUntilCompleted()
        
    }
    
    
}
