Push-Location -Path ".\CPP_Game\build"
    cmake -Wno-dev --fresh ..
    cmake --build . --config Debug
    cmake --build . --config Release

    Invoke-Expression ".\Project_Game.sln"
Pop-Location