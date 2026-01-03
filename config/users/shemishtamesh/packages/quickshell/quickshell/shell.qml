// import Quickshell
//
// ShellRoot {
//     Bar {
//         panelWidth: 500
//         panelHeight: 300
//         hoverBuffer: 1
//         // verticalPosition: Constants.VerticalPosition.Top
//         // horizontalPosition: Constants.HorizontalPosition.Center
//     }
// }

import QtQuick
import Quickshell

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Bar {
            panelWidth: 500
            panelHeight: 300
            hoverBuffer: 1
        }
    }
}
