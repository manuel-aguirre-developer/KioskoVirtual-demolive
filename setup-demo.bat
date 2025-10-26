@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: ============================================
:: Script de configuración automática para Demo
:: Kiosko Virtual - GitHub Pages (Windows)
:: ============================================

echo.
echo 🎮 Configurando Demo de Kiosko Virtual...
echo ==========================================
echo.

:: Verificar que estamos en el directorio correcto
if not exist "index.html" (
    echo ❌ No se encuentra index.html
    echo Por favor ejecuta este script desde la raíz del proyecto.
    pause
    exit /b 1
)

echo ✅ Proyecto encontrado
echo.

:: Crear backup
echo ℹ️  Creando backup del proyecto original...
if not exist "..\kiosko-backup" (
    xcopy /E /I /Q . ..\kiosko-backup
    echo ✅ Backup creado en ..\kiosko-backup
) else (
    echo ⚠️  Ya existe un backup. Saltando...
)
echo.

:: Eliminar archivos innecesarios
echo ℹ️  Eliminando archivos innecesarios para demo...

if exist "backend" (
    rmdir /S /Q backend
    echo ✅ Eliminado: backend\
)

if exist "adminK" (
    rmdir /S /Q adminK
    echo ✅ Eliminado: adminK\
)

if exist "General\conexion.php" (
    del /Q "General\conexion.php"
    echo ✅ Eliminado: General\conexion.php
)

if exist ".env" (
    del /Q ".env"
    echo ✅ Eliminado: .env
)
echo.

:: Actualizar archivos JS
echo ℹ️  Actualizando URLs en archivos JavaScript...

:: Lista de archivos a modificar
set files=client\index\inicio.js client\carrito\carrito.js client\login\login.js client\pagos\comprar.js client\perfil\perfil.js client\verPedidos\verPedidos.js client\configuracion\config.js

for %%f in (%files%) do (
    if exist "%%f" (
        powershell -Command "(gc '%%f') -replace 'const BASE_URL = \"http://localhost/kiosko\";', '// 🎮 DEMO MODE`nconst BASE_URL = window.location.origin;' -replace 'const WS_URL = \"ws://localhost:3006/kiosko\";', 'const WS_URL = \"ws://mock\";' | Set-Content '%%f'"
        echo ✅ Actualizado: %%f
    ) else (
        echo ⚠️  No encontrado: %%f
    )
)
echo.

:: Verificar index.html
echo ℹ️  Verificando index.html...
findstr /C:"mock-backend.js" index.html >nul
if errorlevel 1 (
    echo ⚠️  Necesitas agregar manualmente a index.html:
    echo    ^<script src="mock-backend.js"^>^</script^>
    echo    (antes de inicio.js)
) else (
    echo ✅ mock-backend.js ya está en index.html
)
echo.

:: Crear .gitignore
if not exist ".gitignore" (
    echo ℹ️  Creando .gitignore...
    (
        echo # Backend (no necesario en demo^)
        echo backend/
        echo adminK/
        echo *.php
        echo !mock-backend.js
        echo.
        echo # Variables de entorno
        echo .env
        echo .env.local
        echo.
        echo # Base de datos
        echo bd/
        echo *.sql
        echo.
        echo # Node modules
        echo node_modules/
        echo.
        echo # Logs
        echo *.log
        echo.
        echo # Sistema operativo
        echo .DS_Store
        echo Thumbs.db
        echo.
        echo # IDEs
        echo .vscode/
        echo .idea/
        echo.
        echo # Cache
        echo .cache/
    ) > .gitignore
    echo ✅ Creado .gitignore
) else (
    echo ⚠️  .gitignore ya existe
)
echo.

:: Verificar mock-backend.js
if not exist "mock-backend.js" (
    echo.
    echo ❌ IMPORTANTE: Debes crear el archivo mock-backend.js manualmente
    echo.
    echo Copia el contenido del artifact 'mock-backend.js' que te proporcionaron
    echo y guárdalo como 'mock-backend.js' en la raíz del proyecto.
    echo.
) else (
    echo ✅ mock-backend.js encontrado
)

:: Resumen final
echo.
echo ==========================================
echo ✅ Configuración completada!
echo ==========================================
echo.
echo 📋 Próximos pasos:
echo.
echo 1. Verificar que mock-backend.js existe en la raíz
echo 2. Abrir index.html en el navegador para probar
echo 3. Verificar consola (F12^) - debe decir 'MODO DEMO ACTIVADO'
echo 4. Probar login con demo@kiosko.com / demo123
echo 5. Si todo funciona, subir a GitHub:
echo.
echo    git init
echo    git add .
echo    git commit -m "🎮 Demo inicial"
echo    git remote add origin https://github.com/TU-USUARIO/kiosko-demo.git
echo    git push -u origin main
echo.
echo 6. Activar GitHub Pages en Settings ^> Pages
echo.
echo ==========================================
echo.

:: Preguntar si quiere inicializar git
set /p git_init="¿Quieres inicializar Git ahora? (S/N): "
if /i "%git_init%"=="S" (
    if not exist ".git" (
        git init
        git add .
        echo.
        echo ✅ Git inicializado. Los archivos están staged.
        echo.
        echo ℹ️  Ahora puedes hacer:
        echo    git commit -m "🎮 Demo inicial"
        echo    git remote add origin https://github.com/TU-USUARIO/kiosko-demo.git
        echo    git push -u origin main
    ) else (
        echo ⚠️  Git ya está inicializado
    )
)

echo.
echo ℹ️  Script completado. ¡Buena suerte con tu demo! 🚀
echo.
pause