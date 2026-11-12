-- Rex reads this file on the machine that runs the Rex server.
-- After a change: `rex config check`, then `rex config reload` on that machine.
-- Appearance (theme, font, tabs, sidebar) lives in Rex's own settings, not here.

-- Sidebar on cmd+s instead of cmd+/.
rex.unbind("cmd+/", "client.sidebar.toggle")
rex.bind("cmd+s", "client.sidebar.toggle")

-- Tabs on ctrl+left/right instead of ctrl+(shift+)tab.
rex.unbind("ctrl+tab", "client.tab.next")
rex.unbind("ctrl+shift+tab", "client.tab.previous")
rex.bind("ctrl+right", "client.tab.next")
rex.bind("ctrl+left", "client.tab.previous")

-- No cmd+= to grow the font.
rex.unbind("cmd+=", "client.font.increase")
