import QtQuick
import MistPlayer 1.0

Rectangle {
    id: root

    property color tint: Qt.rgba(1, 1, 1, 0.62)
    property int panelRadius: (typeof Theme !== "undefined" && Theme.radiusPanel) ? Theme.radiusPanel : 24
    property color borderTone: (typeof Theme !== "undefined" && Theme.lineCool) ? Theme.lineCool : "#1F2C3844"

    radius: panelRadius
    color: tint
    border.color: borderTone
    border.width: 1
    antialiasing: true

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: Math.max(0, root.panelRadius - 1)
        color: Qt.rgba(1, 1, 1, 0.17)
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: parent.height * 0.30
        radius: root.panelRadius
        color: Qt.rgba(1, 1, 1, 0.16)
    }
}
