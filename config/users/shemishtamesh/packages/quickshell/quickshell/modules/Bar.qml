import Quickshell
import QtQuick

PanelWindow /* qmllint disable uncreatable-type */ {
    id: root
    required property int panelWidth
    required property int panelHeight
    required property int hoverBuffer
    property var modelData

    anchors {
        top: true
    }
    exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    implicitHeight: hoverBuffer
    implicitWidth: panelWidth

    Rectangle {
        id: wrap

        property bool showed: false

        width: root.implicitWidth
        height: root.panelHeight + root.hoverBuffer
        y: showed ? 0 : -root.panelHeight
        x: 0
        color: "transparent"

        Rectangle {
            id: content
            height: root.panelHeight
            width: root.implicitWidth
            ClockWidget {}
        }

        Behavior on y {
            SequentialAnimation {
                ScriptAction {
                    script: if (wrap.showed)
                        root.implicitHeight = root.panelHeight;
                }
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
                ScriptAction {
                    script: if (!wrap.showed)
                        root.implicitHeight = root.hoverBuffer;
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onHoveredChanged: wrap.showed = containsMouse
        }
    }
}
