# Firmar el APK con una clave propia

La clave y su contraseña las crea el grupo. **No subirlas a GitHub** ni
compartirlas por chat, y guardar una copia: sin ella no se puede actualizar la
app instalada.

1. Crear la clave (pide una contraseña y algunos datos). `keytool` viene con
   Android Studio, en la carpeta `jbr\bin`:

```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkeypair -v -keystore "$HOME\libreria.jks" -keyalg RSA -keysize 2048 -validity 10000 -alias libreria
```

2. Crear el archivo `android/key.properties` (ya está ignorado por git):

```
storeFile=C:/Users/TU_USUARIO/libreria.jks
storePassword=TU_CONTRASEÑA
keyAlias=libreria
keyPassword=TU_CONTRASEÑA
```

3. Compilar:

```powershell
flutter build apk --release
```

Al cambiar de firma hay que **desinstalar** la app anterior del celular antes de
instalar la nueva.
