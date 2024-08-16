#!/usr/bin/env python3

from gi.repository import Playerctl, GLib

player = Playerctl.Player()

played_out = ['Zu Fuss', 'Walk And Talk', 'Neuland']


def on_track_change(player, e):
    if player.get_title() in played_out:
        player.next()


player.on('metadata', on_track_change)

GLib.MainLoop().run()
