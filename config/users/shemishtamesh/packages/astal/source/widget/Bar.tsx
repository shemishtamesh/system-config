import { App, Astal, Gtk, Gdk } from "astal/gtk4"
import { Variable } from "astal"
import Hyprland from "gi://AstralHyprland"

const time = Variable("").poll(1000, "date")
const hyprland = Hyprland.get_defaults()

export default function Bar(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    return <window
        visible
        cssClasses={["Bar"]}
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.EXCLUSIVE}
        anchor={TOP | LEFT | RIGHT}
        application={App}>
        <centerbox cssName="centerbox">
            <button
                onClicked="echo hello"
                hexpand
                halign={Gtk.Align.START}
            >
                Welcome to AGS!
            </button>
            <box />
            <menubutton
                hexpand
                halign={Gtk.Align.CENTER}
            >
                <label label={time()} />
                <popover>
                    <Gtk.Calendar />
                </popover>
            </menubutton>
        </centerbox>
    </window>
}
