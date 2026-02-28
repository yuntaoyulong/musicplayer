import QtQuick
import QtQuick.Controls
import MistPlayer 1.0

Button {
    id: root
    property url iconSource

    implicitWidth: 54
    implicitHeight: 54
    padding: 0

    background: Rectangle {
        radius: Theme.radiusButton
        color: root.down ? Qt.rgba(1, 1, 1, 0.82) : Qt.rgba(1, 1, 1, 0.6)
        border.color: Theme.lineCool
        border.width: 1

        Behavior on color { ColorAnimation { duration: Theme.motionFast } }
    }

    contentItem: Item {
        Image {
            anchors.centerIn: parent
            source: root.iconSource
            width: 20
            height: 20
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 20
            sourceSize.height: 20
        }
    }
}
