//
//  TaggingDataSource.swift
//  damus
//
//  Created by Ben Weeks on 1/15/23.
//
// Ref: https://github.com/k-lpmg/Tagging

public protocol TaggingDataSource: class {
    func tagging(_ tagging: Tagging, didChangedTagableList tagableList: [String])
    func tagging(_ tagging: Tagging, didChangedTaggedList taggedList: [TaggingModel])
}

public extension TaggingDataSource {
    func tagging(_ tagging: Tagging, didChangedTagableList tagableList: [String]) {return}
    func tagging(_ tagging: Tagging, didChangedTaggedList taggedList: [TaggingModel]) {return}
}
