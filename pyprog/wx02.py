#!/usr/bin/env python
# -*- coding: utf-8 -*-
# przykład z książki https://leanpub.com/pyprog

import wx

class TestApp(wx.App):

  def OnInit(self):
    frame = wx.Frame(None, -1, "Tytul okna")
    frame.Show(True)
    panel = wx.Panel(frame, -1)
    self.label1 = wx.StaticText(panel, -1, "Etykieta")

    button1 = wx.Button(panel, id=wx.ID_ANY, label="Kilknij", pos=(225, 5), size=(80, 25))
    button1.Bind(wx.EVT_BUTTON, self.onButton1Click)

    frame.panel = panel
    self.SetTopWindow(frame)
    return True
 
  def onButton1Click(self, event):
    self.label1.SetLabel("Button pressed!")

app = TestApp(0)
app.MainLoop()
