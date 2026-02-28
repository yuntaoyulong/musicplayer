pragma Singleton
import QtQuick

QtObject {
    readonly property color fogWhite: "#F7F8F8"
    readonly property color paperWhite: "#FCFCFB"
    readonly property color airyWhite: "#F1F4F6"
    readonly property color lineSoft: "#1EFFFFFF"
    readonly property color lineCool: "#1F2C3844"
    readonly property color textPrimary: "#1D252C"
    readonly property color textSecondary: "#67727D"
    readonly property color accentSoft: "#8094A6"

    readonly property int radiusWindow: 30
    readonly property int radiusPanel: 24
    readonly property int radiusButton: 18
    readonly property int radiusPill: 14

    readonly property int spaceXS: 8
    readonly property int spaceS: 12
    readonly property int spaceM: 18
    readonly property int spaceL: 26
    readonly property int spaceXL: 36
    readonly property int spaceXXL: 52

    readonly property int headline: 38
    readonly property int title: 22
    readonly property int body: 15
    readonly property int caption: 12

    readonly property int motionFast: 180
    readonly property int motionNormal: 220

    readonly property string iconBase: "qrc:/qt/qml/MistPlayer/assets/icons/"
    function icon(name) {
        return iconBase + name + ".svg"
    }
}
