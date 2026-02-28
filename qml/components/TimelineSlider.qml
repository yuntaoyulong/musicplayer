import QtQuick
import QtQuick.Controls
import MistPlayer 1.0

Slider {
    id: slider

    property bool userDragging: pressed

    from: 0
    to: 1

    background: Rectangle {
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 200
        width: slider.availableWidth
        height: 6
        radius: 3
        color: Qt.rgba(1, 1, 1, 0.48)

        Rectangle {
            width: slider.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: Theme.accentSoft
        }
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: 8
        color: Qt.rgba(1, 1, 1, 0.9)
        border.width: 1
        border.color: Theme.lineCool
    }
}
