import QtQuick
import MistPlayer 1.0

Rectangle {
    id: root
    property color tint: Qt.rgba(1, 1, 1, 0.62)

    color: tint
    radius: Theme.radiusPanel
    border.color: Theme.lineCool
    border.width: 1
    antialiasing: true

    Rectangle {
        anchors.fill: parent
        anchors.margins: 1
        radius: parent.radius - 1
        color: Qt.rgba(1, 1, 1, 0.18)
    }
}
