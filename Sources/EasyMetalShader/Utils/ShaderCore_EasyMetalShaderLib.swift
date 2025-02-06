//
//  ShaderCore.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

public enum ShaderCore_EasyMetalShaderLib {
    public static let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    public static let commandQueue: MTLCommandQueue = ShaderCore_EasyMetalShaderLib.device.makeCommandQueue()!
    public static let context: CIContext = CIContext(mtlDevice: device)
}
