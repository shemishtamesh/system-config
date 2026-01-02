import Quickshell
import QtQuick

Variants {
    model: Quickshell.screens

    delegate: PanelWindow {
        id: root
        property var modelData

        screen: modelData

        anchors {
            top: true
        }
        exclusionMode: ExclusionMode.Ignore
        // color: "transparent"
        color: "blue"

        implicitHeight: wrap.height + wrap.yTransform
        implicitWidth: 500

        Rectangle {
            id: wrap

            property bool showed: false
            property int hoverBuffer: 1

            readonly property int contentHeight: 300
            property int yTransform: -contentHeight

            width: root.implicitWidth
            height: contentHeight + hoverBuffer
            y: yTransform
            x: (parent.width / 2) - (width / 2)
            // color: "transparent"
            color: "green"

            Rectangle {
                id: content
                height: wrap.contentHeight
                width: root.implicitWidth
                ClockWidget {}
            }

            onShowedChanged: {
                wrap.yTransform += showed ? contentHeight : -contentHeight;
                wrap.height += showed ? -wrap.hoverBuffer : wrap.hoverBuffer;
            }

            // Behavior on yTransform {
            //     SequentialAnimation {
            //         NumberAnimation {
            //             duration: 200
            //             easing.type: Easing.InOutQuad
            //         }
            //     //     ScriptAction {
            //     //         script: {
            //     //             wrap.yTransform = wrap.showed ? wrap.wrapHeight : -wrap.wrapHeight ;
            //     //         }
            //     //     }
            //     }
            // }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onHoveredChanged: wrap.showed = !wrap.showed
            }
        }
    }
}
