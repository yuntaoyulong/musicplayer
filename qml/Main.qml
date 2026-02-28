import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.platform
import QtQuick.Dialogs
import MistPlayer 1.0
import "components"
import "theme"

ApplicationWindow {
    id: window
    width: 1240
    height: 780
    minimumWidth: 980
    minimumHeight: 620
    visible: true
    title: "MistPlayer"
    color: "transparent"

    flags: Qt.Window | Qt.FramelessWindowHint

    property bool showQueue: true

    function formatTime(ms) {
        const total = Math.max(0, Math.floor(ms / 1000))
        const m = Math.floor(total / 60)
        const s = total % 60
        return m + ":" + (s < 10 ? "0" + s : s)
    }

    Item {
        anchors.fill: parent

        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0; color: Qt.rgba(0.98, 0.99, 1.0, 0.78) }
                GradientStop { position: 1; color: Qt.rgba(0.94, 0.96, 0.97, 0.68) }
            }
        }

        DropArea {
            anchors.fill: parent
            onDropped: (drop) => {
                const files = []
                for (let i = 0; i < drop.urls.length; ++i) {
                    files.push(drop.urls[i])
                }
                playerController.addFiles(files)
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: Theme.spaceXL
            spacing: Theme.spaceL

            GlassPanel {
                Layout.fillHeight: true
                Layout.preferredWidth: Math.max(620, window.width * 0.62)
                tint: Qt.rgba(1, 1, 1, 0.55)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spaceXL
                    spacing: Theme.spaceL

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 48

                        RowLayout {
                            anchors.fill: parent

                            Text {
                                text: "MistPlayer"
                                font.pixelSize: Theme.title
                                font.weight: Font.Medium
                                color: Theme.textPrimary
                            }

                            Item { Layout.fillWidth: true }

                            ControlButton {
                                iconSource: "qrc:/MistPlayer/assets/icons/open.svg"
                                onClicked: playerController.openFiles()
                                ToolTip.visible: hovered
                                ToolTip.text: "打开文件"
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Rectangle {
                            anchors.fill: parent
                            radius: Theme.radiusPanel
                            color: Qt.rgba(1, 1, 1, 0.46)
                            border.width: 1
                            border.color: Theme.lineCool

                            Column {
                                anchors.fill: parent
                                anchors.margins: Theme.spaceXL
                                spacing: Theme.spaceM

                                Text {
                                    text: playerController.nowPlayingTitle
                                    font.pixelSize: Theme.headline
                                    font.weight: Font.Medium
                                    color: Theme.textPrimary
                                    elide: Text.ElideRight
                                    width: parent.width
                                }

                                Text {
                                    text: playerController.nowPlayingPath
                                    font.pixelSize: Theme.body
                                    color: Theme.textSecondary
                                    elide: Text.ElideMiddle
                                    width: parent.width
                                }

                                Item { width: 1; height: 24 }

                                Rectangle {
                                    width: 260
                                    height: 260
                                    radius: 40
                                    color: Qt.rgba(1, 1, 1, 0.62)
                                    border.color: Theme.lineCool
                                    border.width: 1

                                    Text {
                                        anchors.centerIn: parent
                                        text: "PLAY"
                                        color: Theme.textSecondary
                                        letterSpacing: 7
                                        font.pixelSize: Theme.caption
                                    }
                                }
                            }
                        }
                    }

                    GlassPanel {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 180

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.spaceL
                            spacing: Theme.spaceM

                            TimelineSlider {
                                id: timeline
                                Layout.fillWidth: true
                                from: 0
                                to: Math.max(1, playerController.mediaPlayer.duration)
                                value: userDragging ? value : playerController.mediaPlayer.position
                                onMoved: playerController.seek(value)
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                Text {
                                    text: formatTime(playerController.mediaPlayer.position)
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.caption
                                }
                                Item { Layout.fillWidth: true }
                                Text {
                                    text: formatTime(playerController.mediaPlayer.duration)
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.caption
                                }
                            }

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: Theme.spaceS

                                ControlButton {
                                    iconSource: "qrc:/MistPlayer/assets/icons/previous.svg"
                                    onClicked: playerController.previous()
                                }
                                ControlButton {
                                    iconSource: playerController.mediaPlayer.playbackState === MediaPlayer.PlayingState
                                                ? "qrc:/MistPlayer/assets/icons/pause.svg"
                                                : "qrc:/MistPlayer/assets/icons/play.svg"
                                    onClicked: playerController.playPause()
                                }
                                ControlButton {
                                    iconSource: "qrc:/MistPlayer/assets/icons/next.svg"
                                    onClicked: playerController.next()
                                }

                                Item { Layout.fillWidth: true }

                                Text {
                                    text: "音量"
                                    color: Theme.textSecondary
                                    font.pixelSize: Theme.caption
                                }

                                Slider {
                                    Layout.preferredWidth: 140
                                    from: 0
                                    to: 1
                                    value: playerController.audioOutput.volume
                                    onValueChanged: playerController.setVolume(value)
                                }
                            }
                        }
                    }
                }
            }

            GlassPanel {
                Layout.fillHeight: true
                Layout.fillWidth: true
                tint: Qt.rgba(1, 1, 1, 0.5)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: Theme.spaceL
                    spacing: Theme.spaceM

                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            text: "播放队列"
                            color: Theme.textPrimary
                            font.pixelSize: Theme.body
                            font.weight: Font.Medium
                        }
                        Item { Layout.fillWidth: true }
                        ControlButton {
                            iconSource: "qrc:/MistPlayer/assets/icons/queue.svg"
                            onClicked: window.showQueue = !window.showQueue
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: showQueue ? Math.max(240, window.height * 0.45) : 0
                        clip: true
                        visible: showQueue
                        spacing: Theme.spaceXS
                        model: playerController.playlist
                        delegate: QueueItem {
                            width: ListView.view.width
                            title: model.title
                            isCurrent: model.isCurrent
                            onClicked: playerController.playAt(index)
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: Theme.radiusPanel
                        color: Qt.rgba(1, 1, 1, 0.35)
                        border.width: 1
                        border.color: Theme.lineCool

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: Theme.spaceM

                            Text {
                                text: "最近打开"
                                font.pixelSize: Theme.body
                                color: Theme.textSecondary
                            }

                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: playerController.recentItems
                                delegate: ItemDelegate {
                                    width: ListView.view.width
                                    text: modelData
                                    elide: Text.ElideMiddle
                                    onClicked: playerController.playRecent(index)
                                    background: Rectangle {
                                        radius: Theme.radiusPill
                                        color: hovered ? Qt.rgba(1, 1, 1, 0.62) : "transparent"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Shortcut { sequence: StandardKey.Open; onActivated: playerController.openFiles() }
    Shortcut { sequence: "Space"; onActivated: playerController.playPause() }
    Shortcut { sequence: "Ctrl+Right"; onActivated: playerController.next() }
    Shortcut { sequence: "Ctrl+Left"; onActivated: playerController.previous() }
}
