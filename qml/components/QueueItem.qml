import QtQuick
import QtQuick.Controls
import MistPlayer 1.0

ItemDelegate {
    id: root

    required property string title
    required property bool isCurrent

    implicitHeight: 44
    leftPadding: Theme.spaceM
    rightPadding: Theme.spaceM

    background: Rectangle {
        radius: Theme.radiusPill
        color: root.hovered || root.isCurrent ? Qt.rgba(1, 1, 1, 0.78) : "transparent"
        border.width: root.isCurrent ? 1 : 0
        border.color: Theme.lineCool

        Behavior on color { ColorAnimation { duration: Theme.motionFast } }
    }

    contentItem: Text {
        text: root.title
        color: Theme.textPrimary
        elide: Text.ElideMiddle
        font.pixelSize: Theme.body
    }
}
