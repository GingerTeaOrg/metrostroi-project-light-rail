Metrostroi.DefineSystem( "MPLR_Matrix" )
Metrostroi.DontAccelerateSimulation = true
function TRAIN_SYSTEM:Initialize()
    local resolutionX = self.Train.LEDMatrixX
    local resolutionY = self.Train.LEDMatrixY
    self.Grid = {}
    for i = 1, resolutionY do
        self.Grid[ i ] = self.Grid[ i ] or {}
        for j = 1, resolutionX do
            self.Grid[ i ][ j ] = 0
        end
    end

    self.LinePrefix = "none"
end

function TRAIN_SYSTEM:Clear()
    local maxRows = #self.Grid
    local maxCols = #self.Grid[ 1 ] -- assuming the grid is a rectangle
    -- If the new message is different from the old one, clear the grid
    -- Optimized grid clearing using nested loop unrolling
    for row = 1, maxRows do
        local gridRow = self.Grid[ row ]
        for col = 1, maxCols, 4 do
            gridRow[ col ] = 0
            if col + 1 <= maxCols then gridRow[ col + 1 ] = 0 end
            if col + 2 <= maxCols then gridRow[ col + 2 ] = 0 end
            if col + 3 <= maxCols then gridRow[ col + 3 ] = 0 end
        end
    end
end

function TRAIN_SYSTEM:Display( msg )
    -- Initialize the starting X position, using ledX or defaulting to 0
    local startX = ledX or 0
    -- Retrieve the old message, ensuring it's a table with at least one element, otherwise default to an empty table
    local oldmsg = type( oldmsg ) == "table" and oldmsg[ 1 ] and oldmsg or {}
    -- Precompute the maximum rows and columns of the grid for reuse
    local maxRows = #self.Grid
    local maxCols = #self.Grid[ 1 ] -- assuming the grid is a rectangle
    -- Precompute the width of an empty character for spacing calculations
    local emptyCharWidth = #UF.charMatrixSmallThin[ "EMPTY" ][ 1 ]
    -- If the new message is different from the old one, clear the grid
    if msg ~= oldmsg then
        -- Optimized grid clearing using nested loop unrolling
        for row = 1, maxRows do
            local gridRow = self.Grid[ row ]
            for col = 1, maxCols, 4 do
                gridRow[ col ] = 0
                if col + 1 <= maxCols then gridRow[ col + 1 ] = 0 end
                if col + 2 <= maxCols then gridRow[ col + 2 ] = 0 end
                if col + 3 <= maxCols then gridRow[ col + 3 ] = 0 end
            end
        end

        xOffset = 0
    end

    -- Initialize the y-coordinate
    local y_coordinate = 0
    -- Define the function to print LEDs for a given string, font, and X position
    local function printLED( str1, font, PosX )
        local charMatrix, charWidth, charRow, gridRow, gridRowIndex, gridColIndex
        local cumulativeWidth = 0 -- Track the total width used by previous characters
        local charSpacing = 1 -- Define a fixed spacing between characters
        -- Determine if we should apply spacing
        local applySpacing = font ~= "Symbols"
        -- Loop through each character in the string
        for i = 1, #str1 do
            local char = str1:sub( i, i )
            -- Determine the character matrix based on the font
            if font == "SmallThin" then
                charMatrix = UF.charMatrixSmallThin[ char ]
            elseif font == "SmallBold" then
                charMatrix = UF.charMatrixSmallBold[ char ]
            elseif font == "Symbols" then
                charMatrix = UF.charMatrixSymbols[ char ]
            elseif font == "Headline" then
                charMatrix = UF.charMatrixHeadline[ char ]
            else
                charMatrix = nil
                Error( "Character not found!!!" )
            end

            -- Handle space characters separately
            if char == " " then
                -- Use the width of the space character defined in the font's character matrix
                if font == "SmallThin" then
                    charWidth = #UF.charMatrixSmallThin[ " " ][ 1 ]
                elseif font == "SmallBold" then
                    charWidth = #UF.charMatrixSmallBold[ " " ][ 1 ]
                elseif font == "Headline" then
                    charWidth = #UF.charMatrixHeadline[ "SPACE" ][ 1 ]
                elseif font == "Symbols" then
                    charWidth = #UF.charMatrixSymbols[ " " ][ 1 ]
                end

                -- Simply increase the cumulativeWidth by the width of the space character
                cumulativeWidth = cumulativeWidth + charWidth + ( applySpacing and charSpacing or 0 )
            else
                -- If a valid character matrix is found, process it
                if charMatrix then
                    charWidth = #charMatrix[ 1 ]
                    -- Loop through each row of the character matrix
                    for row = 1, #charMatrix do
                        charRow = charMatrix[ row ]
                        gridRowIndex = row + y_coordinate
                        -- Ensure the grid row index is within bounds
                        if gridRowIndex > 0 and gridRowIndex <= maxRows then
                            gridRow = self.Grid[ gridRowIndex ]
                            -- Loop through each column of the character matrix
                            for col = 1, charWidth do
                                -- Calculate the absolute grid column index
                                gridColIndex = PosX + cumulativeWidth + col
                                -- Ensure the grid column index is within bounds
                                if gridColIndex > 0 and gridColIndex <= maxCols then
                                    -- Set the grid value based on the character matrix value
                                    gridRow[ gridColIndex ] = tonumber( charRow:sub( col, col ) ) == 1 and 1 or 0
                                end
                            end
                        end
                    end

                    -- Update cumulativeWidth for the next character
                    cumulativeWidth = cumulativeWidth + charWidth + ( applySpacing and charSpacing or 0 )
                end
            end
        end
    end

    -- Loop through each message entry
    for k, v in ipairs( msg ) do
        -- Extract the y-coordinate from the message entry
        y_coordinate = v[ 1 ]
        -- Loop through each value in the message entry
        for _, val in ipairs( v ) do
            if type( val ) == "table" then
                -- Extract the string, font, and X position
                local str1 = val[ 1 ]
                local font = val[ 2 ]
                local PosX = val[ 3 ]
                -- Print the LEDs for the extracted string, font, and X position
                printLED( str1, font, PosX )
            end
        end
    end

    -- Loop through each row of the grid to draw the LEDs
    for k, gridRow in ipairs( self.Grid ) do
        local ledY = ( k + 1 ) * ledSize
        for i = 1, matrixWidth do
            -- If the grid cell is 1, draw the LED
            if gridRow[ i ] == 1 then
                local ledX = startX + ( i + 1 ) * ledSize
                self:drawLED( ledX, ledY )
            end
        end
    end

    -- Update oldmsg to the current message
    oldmsg = msg
end

function TRAIN_SYSTEM:GetLinePrefix()
end

function TRAIN_SYSTEM:RenderDisplay()
    local ibis = self.Train.IBIS
    local dest = ibis.DestinationString
    local linePos = 2
    local msg = {
        [ 1 ] = { 15, { line, "SmallThin", linePos } }
    }
end