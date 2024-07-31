//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/08/01.
//

import XCTest
@testable import EasyMetalShader

@EMComputeShader
class TestArrayShader {

    var array: BoolBuffer = BoolBuffer(count: 5)

    var impl: String {
        "array[0] = true;"
        "array[1] = false;"
        "array[2] = true;"
        "array[3] = false;"
        "array[4] = true;"
    }

    var customMetalCode: String {
        ""
    }
}

class ComputeShaderArrayTests: XCTestCase {

    func testBuild() throws {

        let shader = TestArrayShader()
        try shader.array.setBytes([false, false, false, false, false])

        let dispatch = EMMetalDispatch()
        dispatch.compute { encoder in
            shader.dispatchArray(encoder, arrayCount: shader.array.count)
        }
        dispatch.commit()
        dispatch.waitUntilCompleted()

        let arrayPointer = shader.array.buffer.contents().assumingMemoryBound(to: Bool.self)
        let array = Array(UnsafeBufferPointer(start: arrayPointer, count: shader.array.count))

        XCTAssertEqual(array, [true, false, true, false, true])
    }
}
