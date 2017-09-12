#!/usr/bin/env python
# -*- coding: utf-8 -*-
# przykład z książki https://leanpub.com/pyprog

import wx

class TestApp(wx.App):

  def OnInit(self):
    frame = wx.Frame(None, -1, "Tytul okna")
    frame.Show(True)
    panel = wx.Panel(frame, -1)
    label1 = wx.StaticText(panel, -1, "Etykieta")
    frame.panel = panel
    self.SetTopWindow(frame)
    return True

app = TestApp(0)
app.MainLoop()
