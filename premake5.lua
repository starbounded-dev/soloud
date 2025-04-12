local with_sdl = false
local with_sdl2 = false
local with_sdl3 = false
local with_openal = false
local with_portaudio = false
local with_xaudio2 = false
local with_winmm = false
local with_coreaudio = false
local with_alsa = false
local with_jack = false
local with_miniaudio = false
local with_null = true

-- Detect platform-specific defaults
if os.target() == "windows" then
    with_winmm = true
elseif os.target() == "macosx" then
    with_coreaudio = true
else
    with_alsa = true
end

-- Define projects
project "SoLoud"
    kind "StaticLib"
    language "C++"
    staticruntime "off"
    
    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
	objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "src/audiosource/**.cpp",
        "src/filter/**.cpp",
        "src/core/**.cpp"
    }

    includedirs { "include", "src" }

    -- Backend-specific configurations
    if with_openal then
        defines { "WITH_OPENAL" }
        files { "src/backend/openal/**.cpp" }
    end

    if with_alsa then
        defines { "WITH_ALSA" }
        files { "src/backend/alsa/**.cpp" }
    end

    if with_sdl then
        defines { "WITH_SDL" }
        files { "src/backend/sdl/**.cpp" }
    end

    if with_sdl2 then
        defines { "WITH_SDL2" }
        files { "src/backend/sdl2/**.cpp" }
    end

    if with_miniaudio then
        defines { "WITH_MINIAUDIO" }
        files { "src/backend/miniaudio/**.cpp" }
    end

    if with_null then
        defines { "WITH_NULL" }
        files { "src/backend/null/**.cpp" }
    end

    filter "system:windows"
        if with_winmm then
            defines { "WITH_WINMM" }
            files { "src/backend/winmm/**.cpp" }
        end

    filter "system:macosx"
        if with_coreaudio then
            defines { "WITH_COREAUDIO" }
            files { "src/backend/coreaudio/**.cpp" }
        end

    filter "system:linux"
        if with_alsa then
            defines { "WITH_ALSA" }
            links { "asound" }
        end

    filter "system:windows"
        defines { "_CRT_SECURE_NO_WARNINGS" }
        flags { "MultiProcessorCompile" }
        staticruntime "off"

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "Speed"
        
    filter "configurations:Dist"
        defines { "NDEBUG" }
        optimize "Speed"

    filter {}