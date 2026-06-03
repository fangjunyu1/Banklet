//
//  iCloudFileManager.swift
//  SwiftSlim
//
//  Created by 方君宇 on 2026/6/3.
//

import SwiftUI

final class iCloudFileManager {
    static let shared = iCloudFileManager()

    private init() {}

    /// 获取 iCloud Documents 目录
    func iCloudDocumentsURL() -> URL? {
        guard let containerURL = FileManager.default.url(forUbiquityContainerIdentifier: nil) else {
            return nil
        }

        let documentsURL = containerURL.appendingPathComponent("Documents",isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: documentsURL.path) {
            try? FileManager.default.createDirectory(
                at: documentsURL,
                withIntermediateDirectories: true
            )
        }

        return documentsURL
    }

    /// 保存文件到 iCloud
    func save(data: Data, fileName: String) throws {
        guard let documentsURL = iCloudDocumentsURL() else {
            throw NSError(
                domain: "iCloud",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "iCloud is not available."]
            )
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)
        try data.write(to: fileURL, options: .atomic)
    }

    /// 读取 iCloud 文件
    func read(fileName: String) throws -> Data {
        guard let documentsURL = iCloudDocumentsURL() else {
            throw NSError(
                domain: "iCloud",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "iCloud is not available."]
            )
        }

        let fileURL = documentsURL.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            return try Data(contentsOf: fileURL)
        } else {
            throw NSError(
                domain: "iCloud",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "File not found."]
            )
        }
    }
}
