import QtQuick
import QtQuick.Controls
import MistPlayer 1.0

Button {
    id: root

    property url iconSource: ""
    property int buttonRadius: (typeof Theme !== "undefined" && Theme.radiusButton) ? Theme.radiusButton : 18
    property color borderTone: (typeof Theme !== "undefined" && Theme.lineCool) ? Theme.lineCool : "#1F2C3844"
    property int motionFast: (typeof Theme !== "undefined" && Theme.motionFast) ? Theme.motionFast : 180

    implicitWidth: 54
    implicitHeight: 54
    padding: 0

    background: Rectangle {
        radius: root.buttonRadius
        color: root.down ? Qt.rgba(1, 1, 1, 0.84) : (root.hovered ? Qt.rgba(1, 1, 1, 0.73) : Qt.rgba(1, 1, 1, 0.62))
        border.color: root.borderTone
        border.width: 1

        Behavior on color {
            ColorAnimation { duration: root.motionFast }
        }
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
