import QtQuick
import QtQuick.Controls
import MistPlayer 1.0

ItemDelegate {
    id: root

    property string title: ""
    property bool isCurrent: false

    leftPadding: (typeof Theme !== "undefined" && Theme.spaceM) ? Theme.spaceM : 18
    rightPadding: (typeof Theme !== "undefined" && Theme.spaceM) ? Theme.spaceM : 18

    background: Rectangle {
        radius: (typeof Theme !== "undefined" && Theme.radiusPill) ? Theme.radiusPill : 14
        color: root.isCurrent
               ? Qt.rgba(1, 1, 1, 0.75)
               : (root.hovered ? Qt.rgba(1, 1, 1, 0.52) : Qt.rgba(1, 1, 1, 0.20))
        border.color: (typeof Theme !== "undefined" && Theme.lineCool) ? Theme.lineCool : "#1F2C3844"
        border.width: 1

        Behavior on color {
            ColorAnimation { duration: (typeof Theme !== "undefined" && Theme.motionFast) ? Theme.motionFast : 180 }
        }
    }

    contentItem: Text {
        text: root.title
        color: (typeof Theme !== "undefined" && Theme.textPrimary) ? Theme.textPrimary : "#1D252C"
        elide: Text.ElideRight
        font.pixelSize: (typeof Theme !== "undefined" && Theme.body) ? Theme.body : 15
        verticalAlignment: Text.AlignVCenter
    }
}
