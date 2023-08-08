UIManager = { widgets = {} }

function UIManager.update(dt)
    for widgetId, widget in pairs(UIManager.widgets) do
        if widget.update then
            widget:update(dt)
        end
    end
end

function UIManager.draw()
    for widgetId, widget in ipairs(UIManager.widgets) do
        widget:draw()
    end
end

function UIManager.insert(item)
    table.insert(UIManager.widgets, item)
end

function UIManager.remove(item)
    for widgetId, widget in pairs(UIManager.widgets) do
        if item == widget then
            table.remove(UIManager.widgets, widgetId)
        end
    end
end

function UIManager.clear()
    UIManager.widgets = {}
end
