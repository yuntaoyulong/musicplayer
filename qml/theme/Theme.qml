pragma Singleton
import QtQuick

QtObject {
    readonly property color fogWhite: "#F5F7F8"
    readonly property color paperWhite: "#FCFCFB"
    readonly property color airyWhite: "#F2F4F5"
    readonly property color lineSoft: "#26FFFFFF"
    readonly property color lineCool: "#1A2D3842"
    readonly property color textPrimary: "#1D252C"
    readonly property color textSecondary: "#6B7782"
    readonly property color accentSoft: "#7B8E9F"

    readonly property int radiusWindow: 28
    readonly property int radiusPanel: 24
    readonly property int radiusButton: 18
    readonly property int radiusPill: 14

    readonly property int spaceXS: 8
    readonly property int spaceS: 12
    readonly property int spaceM: 18
    readonly property int spaceL: 26
    readonly property int spaceXL: 36

    readonly property int headline: 36
    readonly property int title: 22
    readonly property int body: 15
    readonly property int caption: 12

    readonly property int motionFast: 180
    readonly property int motionNormal: 220
}
