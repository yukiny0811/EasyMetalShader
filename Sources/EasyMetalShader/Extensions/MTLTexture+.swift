//
//  MTLTexture+.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/06.
//

extension MTLTexture {
    public var cgImage: CGImage? {
        guard let ciimage = CIImage(mtlTexture: self) else {
            return nil
        }
        let flipped = ciimage.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
        let cgimage = ShaderCore_EasyMetalShaderLib.context.createCGImage(
            flipped,
            from: flipped.extent
        )
        return cgimage
    }
}
