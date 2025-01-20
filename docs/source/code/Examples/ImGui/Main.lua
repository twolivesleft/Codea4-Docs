-- Tab Bar
    
display.fullscreen()

function setup()
end

function draw()
    background(0, 0, 0, 0)
end

local count = 0 

function gui()
    imgui.begin("Tab Bar Window", function()
        imgui.setWindowPos(WIDTH/2 - 300, 100, imgui.cond.once)
        imgui.setWindowSize(600, HEIGHT-200, imgui.cond.once)
        imgui.text(string.format("imgui.isWindowFocused: %s", imgui.isWindowFocused()))
        imgui.text(string.format("CurrentTouch: %f, %f, %d", CurrentTouch.x, CurrentTouch.y, CurrentTouch.state))
        imgui.tabBar("MyTabBar", function()
            imgui.tabItem("Avocado", function()
                imgui.text("This is the Avocado tab!\nblah blah blah blah")
                if imgui.button(string.format("Button (%d)", count)) then count = count + 1 end
            end)
            imgui.tabItem("Broccoli", function()
                imgui.text("This is the Broccoli tab!\nblah blah blah blah")
            end)
            imgui.tabItem("Cucumber", function()
                imgui.text("This is the Cucumber tab!\nblah blah blah blah")
            end)            
        end)
    end)
end

function touched(touch)
end
