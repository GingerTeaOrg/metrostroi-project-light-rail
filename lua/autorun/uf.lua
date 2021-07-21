if not UF then
    -- Global library
    UF = {}

    -- Supported train classes
    UF.TrainClasses = {}
    UF.IsTrainClass = {}
    -- Supported train classes
    Metrostroi.TrainSpawnerClasses = {}
    timer.Simple(0.05, function()
        for name in pairs(scripted_ents.GetList()) do
            local prefix = "gmod_subway_uf_"
            if string.sub(name,1,#prefix) == prefix then
                table.insert(UF.TrainClasses,name)
                UF.IsTrainClass[name] = true
            end
        end




    end)
end