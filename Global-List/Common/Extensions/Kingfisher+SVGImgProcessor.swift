//
//  Kingfisher+SVGImgProcessor.swift
//  Global-List
//
//  Created by Nikolay Gutorov on 7/20/21.
//

import Kingfisher
import SVGKit

public struct SVGImgProcessor: ImageProcessor {
    
    // SVG is not built-in supported in Kingfisher. Creating processor for SVG.
    
    public var identifier: String = "com.appidentifier.webpprocessor"
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case .image(let image):
            return image
        case .data(let data):
            let imsvg = SVGKImage(data: data)
            return imsvg?.uiImage
        }
    }
}
