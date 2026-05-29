import Foundation

struct GoMirror: Identifiable, Equatable {
    let id: String
    let name: String
    let systemImage: String
    let proxyURL: String?
    let testURL: String
    let isRecommended: Bool

    var isOfficial: Bool { id == "official" }

    static let allPresets: [GoMirror] = [
        GoMirror(
            id: "official",
            name: "官方源",
            systemImage: "globe",
            proxyURL: nil,
            testURL: "https://proxy.golang.org",
            isRecommended: false
        ),
        GoMirror(
            id: "goproxy-cn",
            name: "goproxy.cn",
            systemImage: "cloud",
            proxyURL: "https://goproxy.cn",
            testURL: "https://goproxy.cn",
            isRecommended: true
        ),
        GoMirror(
            id: "goproxy-io",
            name: "goproxy.io",
            systemImage: "point.3.connected.trianglepath.dotted",
            proxyURL: "https://goproxy.io",
            testURL: "https://goproxy.io",
            isRecommended: true
        ),
        GoMirror(
            id: "aliyun",
            name: "阿里云",
            systemImage: "cloud",
            proxyURL: "https://mirrors.aliyun.com/goproxy/",
            testURL: "https://mirrors.aliyun.com",
            isRecommended: true
        ),
        GoMirror(
            id: "tencent",
            name: "腾讯云",
            systemImage: "cloud",
            proxyURL: "https://mirrors.cloud.tencent.com/go/",
            testURL: "https://mirrors.cloud.tencent.com",
            isRecommended: false
        ),
        GoMirror(
            id: "baidu",
            name: "百度",
            systemImage: "cloud",
            proxyURL: "https://goproxy.baidu.com/",
            testURL: "https://goproxy.baidu.com",
            isRecommended: false
        ),
        GoMirror(
            id: "huawei",
            name: "华为云",
            systemImage: "cloud",
            proxyURL: "https://repo.huaweicloud.com/repository/goproxy/",
            testURL: "https://repo.huaweicloud.com",
            isRecommended: false
        ),
    ]
}
