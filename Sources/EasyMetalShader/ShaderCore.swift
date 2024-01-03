//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit

public enum ShaderCore {
    public static let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    public static let commandQueue: MTLCommandQueue = ShaderCore.device.makeCommandQueue()!
    public static let context: CIContext = CIContext(mtlDevice: device)
}
