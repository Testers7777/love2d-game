function love.load()
    stage = "first"

    target = {}
    target.x = 250
    target.y = 550
    target.z = 0
    target.radius = 50
    target.colorA = 255
    target.colorB = 255
    target.colorC = 255

    isReadingDoc = false
    isJumping = false
    isSleeping = false
    isRunning = false
    isMovingRight = false
    isMovingLeft = false

    inElevator = false
    inBed = false

    score = 0

    gameFont = love.graphics.newFont(30)

    love.window.setTitle("by Testers7777")

    local iconData = love.image.newImageData("icon.png")
    love.window.setIcon(iconData)

    image = love.graphics.newImage("icon.png")
end

function love.update(dt)

    local mrectX = 0
    local mrectY = 500
    local mrectWidth = 250
    local mrectHeight = 250

if stage == 'second' then
    if target.x >= mrectX and target.x <= mrectX + mrectWidth and
       target.y >= mrectY and target.y <= mrectY + mrectHeight then
            inBed = true
        else
            inBed = false
    end
end

    local rectX = 600
    local rectY = 400
    local rectWidth = 350
    local rectHeight = 700

    if target.x >= rectX and target.x <= rectX + rectWidth and
       target.y >= rectY and target.y <= rectY + rectHeight then
        inElevator = true
    else
        inElevator = false
    end

    local moveSpeed = 300

    if isRunning then
        moveSpeed = 600
    end

    if isMovingRight then
        local windowWidth = love.graphics.getWidth()
        if not (target.x + 50 > windowWidth) then
            target.x = target.x + moveSpeed * dt
        end
    end

    if isMovingLeft then
        if not (target.x - moveSpeed * dt < 100) then
            target.x = target.x - moveSpeed * dt
        end
    end


    if isJumping then
        target.z = target.z + 1000 * dt
        target.y = target.y + target.z * dt

        if target.y >= 550 then
            target.y = 550
            target.z = 0
            isJumping = false
        end
    end
end

function love.draw()
    local getW = love.graphics.getWidth() / 4
    local getWY = love.graphics.getWidth() - 70
    local getH = love.graphics.getHeight() / 3

    if not isReadingDoc then
    love.graphics.print("Appuyer sur M pour\n voir le livre d'aide", getH + 50, 0)
    love.graphics.setColor(0, 0, 1)
    love.graphics.print("Run : " .. tostring(isRunning), getWY - 100, 0)

    local circleX = love.graphics.getWidth() - 70
    local circleY = 60
    local radius = 70

    love.graphics.setFont(gameFont)

    -- ELEVATOR

    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", 600, 400, 220, 200)

    love.graphics.setColor(158, 158, 158)
    love.graphics.rectangle("fill", 600, 400, 100, 200)

    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", 600, 400, 103, 200)
    
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("line", 600, 400, 350, 200)

    love.graphics.print("Ascenseur", 630, 400)

    if stage == "first" then
        -- FIRST STAGE

        love.graphics.setColor(255,255,255)
        love.graphics.print("à vous d'aménager cet étage !", getH - 130, getW + 200)

        love.graphics.setColor(0, 0, 1)
        love.graphics.print("Etage 1", 0, 0)
    else
        --  SECOND STAGE

        love.graphics.setColor(255,255,255)
        love.graphics.rectangle("line", 15,520, 65,65)
        love.graphics.setColor(255,255,255)
        love.graphics.rectangle("line", 0,500, 250,250)
        love.graphics.setColor(1,0,0)
        love.graphics.rectangle("fill", 100,500, 150,250)

        love.graphics.setColor(0,0,1)
        love.graphics.print("Etage 2", 0, 0)
    end
    -- TARGET

    love.graphics.setColor(target.colorA, target.colorB, target.colorC)
    love.graphics.circle("fill", target.x, target.y, target.radius)

    if inElevator then
        -- IN THE ELEVATOR

        love.graphics.setColor(255,255,255)
        love.graphics.print("Appuyer sur E pour " .. (stage == "first" and "monter" or "descendre"), getH, getW)
    end

    if inBed then
        -- IS SLEEPING

        love.graphics.setColor(255,255,255)
        love.graphics.print("Appuyer sur E pour " .. (isSleeping and "se reveiller" or "dormir"), getH, getW)
    end
else
-- DOCUMENTATION BOOK
love.graphics.setColor(1,1,1)
love.graphics.print("Appuyer sur M pour\n voir le livre d'aide", getH + 50, getW)
love.graphics.print("Appuyer sur L pour changer\nla couleur de votre skin", getH + 20, getW - 100)
love.graphics.print("Appuyer sur shift pour courir", getH, getW + 100)
love.graphics.print("Appuyer sur espace pour sauter", getH, getW + 200)
love.graphics.print("Appuyer sur échape pour quitter", getH, getW + 300)

end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "space" then
        if not isSleeping then
            if not isJumping then
                isJumping = true
                target.z = -600
            end
        end
    end

    if key == "e" then
        takeElevator()
        sleep()
    end

    if key == "m" then
        if not isReadingDoc then
            isReadingDoc = true
        else
            isReadingDoc = false
        end
    end

    if key == "l" then
        if target.colorA == 255 then
            changeTargetColor("red")
        elseif target.colorA == 1 then
            changeTargetColor("green")
        elseif target.colorB == 1 then
            changeTargetColor("blue")
        elseif target.colorC == 1 then
            changeTargetColor("red")
        else
            changeTargetColor("red")
        end
    end    

    if key == "d" then
        if not isSleeping then
            isMovingRight = true
        end
    end
    if key == "q" then
        if not isSleeping then
            isMovingLeft = true
        end
    end
    if key == "lshift" then
        if not isSleeping then
            isRunning = true
        end
    end
end

function love.keyreleased(key)
    if key == "d" then
        isMovingRight = false
    end
    if key == "q" then
        isMovingLeft = false
    end
    if key == "lshift" then
        isRunning = false
    end
end

function takeElevator()
    if stage == "first" then
        if inElevator then
            stage = "second"
        end
    else
        if inElevator then
            stage = "first"
        end
    end
end

function sleep()
    if stage == "second" then
        if not isSleeping then
            if inBed then
                isMovingLeft = false
                isMovingRight = false
                isRunning = false
                isSleeping = true
                target.x = 150
            end
        else
            if inBed then
                isSleeping = false
            end
        end
    end
end

function changeTargetColor(color)
    if color == 'red' then
        target.colorA = 1
        target.colorB = 0
        target.colorC = 0
    end
    if color == 'green' then
        target.colorA = 0
        target.colorB = 1
        target.colorC = 0
    end
    if color == 'blue' then
        target.colorA = 0
        target.colorB = 0
        target.colorC = 1
    end
end
