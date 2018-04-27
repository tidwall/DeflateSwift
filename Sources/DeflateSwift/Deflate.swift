/*
 * DeflateSwift (deflate.swift)
 *
 * Copyright (C) 2015 ONcast, LLC. All Rights Reserved.
 * Created by Josh Baker (joshbaker77@gmail.com)
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 */

import Foundation
import zlib

class ZStream {
    
    fileprivate static var c_version : UnsafePointer<Int8> = zlibVersion()
    fileprivate(set) static var version : String = String(format: "%s", locale: nil, c_version)
    
    fileprivate func makeError(_ res : CInt) -> NSError? {
        var err = ""
        switch res {
        case 0: return nil
        case 1: err = "stream end"
        case 2: err = "need dict"
        case -1: err = "errno"
        case -2: err = "stream error"
        case -3: err = "data error"
        case -4: err = "mem error"
        case -5: err = "buf error"
        case -6: err = "version error"
        default: err = "undefined error"
        }
        return NSError(domain: "deflateswift", code: -1, userInfo: [NSLocalizedDescriptionKey:err])
    }
    
    fileprivate var strm = z_stream()
    fileprivate var deflater = true
    fileprivate var initd = false
    fileprivate var init2 = false
    fileprivate var level = CInt(-1)
    fileprivate var windowBits = CInt(15)
    fileprivate var out = [UInt8](repeating: 0, count: 5000)

    init() { }

    func write(_ bytes : [UInt8], flush: Bool) -> (bytes: [UInt8], err: NSError?) {
        var mutBytes = bytes
        var res : CInt
        if !initd {
            if deflater {
                if init2 {
                    res = deflateInit2_(&strm, level, 8, windowBits, 8, 0, ZStream.c_version, CInt(MemoryLayout<z_stream>.size))
                } else {
                    res = deflateInit_(&strm, level, ZStream.c_version, CInt(MemoryLayout<z_stream>.size))
                }
            } else {
                if init2 {
                    res = inflateInit2_(&strm, windowBits, ZStream.c_version, CInt(MemoryLayout<z_stream>.size))
                } else {
                    res = inflateInit_(&strm, ZStream.c_version, CInt(MemoryLayout<z_stream>.size))
                }
            }
            if res != 0{
                return ([UInt8](), makeError(res))
            }
            initd = true
        }
        var result = [UInt8]()
        strm.avail_in = CUnsignedInt(bytes.count)
        strm.next_in = &mutBytes+0
        repeat {
            strm.avail_out = CUnsignedInt(out.count)
            strm.next_out = &out+0
            if deflater {
                res = deflate(&strm, flush ? 1 : 0)
            } else {
                res = inflate(&strm, flush ? 1 : 0)
            }
            if res < 0 {
                return ([UInt8](), makeError(res))
            }
            let have = out.count - Int(strm.avail_out)
            if have > 0 {
                result += Array(out[0...have-1])
            }
        } while (strm.avail_out == 0 && res != 1)
        if strm.avail_in != 0 {
            return ([UInt8](), makeError(-9999))
        }
        return (result, nil)
    }
    deinit {
        guard initd  else { return }

        if deflater {
            _ = deflateEnd(&strm)
        } else {
            _ = inflateEnd(&strm)
        }
    }
}

class DeflateStream : ZStream {

    convenience init(level : Int) {
        self.init()
        self.level = CInt(level)
    }

    convenience init(windowBits: Int) {
        self.init()
        self.init2 = true
        self.windowBits = CInt(windowBits)
    }

    convenience init(level : Int, windowBits: Int) {
        self.init()
        self.init2 = true
        self.level = CInt(level)
        self.windowBits = CInt(windowBits)
    }
}

class InflateStream : ZStream {
    override init() {
        super.init()
        deflater = false
    }
    convenience init(windowBits: Int) {
        self.init()
        self.init2 = true
        self.windowBits = CInt(windowBits)
    }
}

