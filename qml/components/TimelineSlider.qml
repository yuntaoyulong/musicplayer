import QtQuick
import QtQuick.Controls
import MistPlayer 1.0

Slider {
    id: slider

    property bool userDragging: pressed
    property color accentTone: (typeof Theme !== "undefined" && Theme.accentSoft) ? Theme.accentSoft : "#8094A6"
    property color borderTone: (typeof Theme !== "undefined" && Theme.lineCool) ? Theme.lineCool : "#1F2C3844"

    from: 0
    to: 1

    background: Rectangle {
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 220
        width: slider.availableWidth
        height: 8
        radius: 4
        color: Qt.rgba(1, 1, 1, 0.48)

        Rectangle {
            width: slider.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: slider.accentTone
        }
    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 18
        implicitHeight: 18
        radius: 9
        color: Qt.rgba(1, 1, 1, 0.94)
        border.width: 1
        border.color: slider.borderTone
    }
}
