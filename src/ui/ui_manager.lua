UIManager = { widgets = {} }

function UIManager.update(dt)
    local widget = UIManager.widgets[#UIManager.widgets]
    if widget.update then
        widget:update(dt)
    end
end

function UIManager.draw()
    for widgetId, widget in ipairs(UIManager.widgets) do
        widget:draw()
    end
end

function UIManager.push(item)
    table.insert(UIManager.widgets, item)
end

function UIManager.pop()
    table.remove(UIManager.widgets, #UIManager.widgets)
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
