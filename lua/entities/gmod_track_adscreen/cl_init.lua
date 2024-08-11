include( "shared.lua" )
function ENT:Initialize()
    self.ComicTimer = 0
    self.Screen = self:CreateRT( "RT1", 4096, 912 )
    if not file.Exists( "xkcd_temp", "DATA" ) then file.CreateDir( "xkcd_temp" ) end
    self.CurrentComic = ""
    hook.Add( "PostDrawHUD", "RenderDFIScreens" .. self:EntIndex(), function() if IsValid( ent ) and ent.RenderDisplay then ent:RenderDisplay() end end )
    local mat = Material( "models/lilly/uf/stations/dfi/display2" ) --CHANGEME
    mat:SetTexture( "$basetexture", self.Screen )
end

function ENT:RenderDisplay()
    if not self.RenderTimer then self.RenderTimer = RealTime() end
    render.PushRenderTarget( self.Screen, 0, 0, 4096, 912 )
    render.Clear( 0, 0, 0, 255, true, true )
    cam.Start2D()
    local mat = Material( self.CurrentComic )
    surface.SetMaterial( mat )
    cam.End2D()
    render.PopRenderTarget()
end

function ENT:Think()
    local changeComic = self:GetNW2Bool( "ChangeComic", false )
    if CurTime() - self.ComicTimer > 20 then
        self.ComicTimer = CurTime()
        self:DownloadRandomComic( math.random( 999 ) )
    end
end

function ENT:DownloadRandomComic( rand )
    local url = "https://xkcd.com/" .. rand .. "/info.0.json"
    http.Fetch( url, -- onSuccess function
        function( body )
        local data = util.JSONToTable( body )
        if not data then
            print( "Failed to parse latest XKCD JSON." )
            return
        end

        local imgURL = data.img
        self:DownloadXKCDImage( imgURL )
    end, -- onFailure function
        function( message )
        -- We failed. =(
        print( message )
    end, -- header example
        {
        [ "accept-encoding" ] = "gzip, deflate",
        [ "accept-language" ] = "fr"
    } )
end

-- Function to download the image from the given URL and save it
function ENT:DownloadXKCDImage( imageUrl )
    local fileName = string.GetFileFromFilename( imageUrl )
    local filePath = "xkcd_temp/" .. fileName
    -- Ensure the temp directory exists
    -- Fetch the image
    http.Fetch( imageUrl, function( body )
        -- Save the image to the file
        file.Write( filePath, body )
        -- Print a message to confirm
        --print( "Downloaded and saved comic to: " .. filePath )
        -- Load the image as a material
        self.CurrentComic = "data/" .. filePath
        -- Use comicMaterial for rendering, etc.
    end, function( error ) print( "Failed to download comic image: " .. error ) end )
end

function ENT:OnRemove()
end

function ENT:CreateRT( name, w, h )
    local RT = GetRenderTarget( "UF" .. self:EntIndex() .. ":" .. name, w or 512, h or 512 )
    if not RT then Error( "Can't create RT\n" ) end
    return RT
end