//
//  MappableObject.swift
//  SwivlExam
//
//  Created by Sergiy Suprun on 3/15/15.
//  Copyright (c) 2015 Sergiy Suprun. All rights reserved.
//

import Foundation


protocol MappableObject: NSObjectProtocol{

    class func fromJSONMappingSheme() -> [String:String]
    
    init()
}