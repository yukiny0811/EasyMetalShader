//
//  RasterizerData.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/06.
//

extension MetalPreLibrary {
    static let rasterizerData =
"""
struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float size [[point_size]];

    float4 temp1;
    float4 temp2;
    float4 temp3;
    float4 temp4;
    float4 temp5;
    float4 temp6;
    float4 temp7;
    float4 temp8;
    float4 temp9;
};
"""
}
