#!/usr/bin/env python
# -*- coding: utf-8 -*-
# przykład z książki https://leanpub.com/pyprog

import wx

# tworzymy obiekt aplikacji
app = wx.App(0)


# obiekt okna (Frame)
frame = wx.Frame(None, -1, "Tytul okna")
frame.Show(True)

# panel = obiekt wnetrza okna
panel = wx.Panel(frame, -1)
# obiekt etykiety w oknie
label1 = wx.StaticText(panel, -1, "Etykieta")

# panel w oknie
frame.panel = panel

# okno w aplikacji
app.SetTopWindow(frame)
app.MainLoop()
