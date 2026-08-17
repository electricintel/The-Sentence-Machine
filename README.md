# The-Sentence-Machine
Cross Platform Operating System (attempt)

USOS is a generated C demo tree built by `build_usos.ps1`.

## Build

```powershell
powershell.exe -ExecutionPolicy Bypass -File build_usos.ps1
```

## How To Use Now

Standard run:

```powershell
.\USOS\build\usos.exe
```

Interactive codebreaker mode:

```powershell
.\USOS\build\usos.exe codebreaker
```

Interactive multi-app shell mode:

```powershell
.\USOS\build\usos.exe shell
```

## Portable (USB) Use

Copy the full `USOS/build/dist/` folder to the target machine, then run:

Portable default run:

```powershell
.\USOS\build\dist\usos.exe
```

Portable interactive codebreaker mode:

```powershell
.\USOS\build\dist\usos.exe codebreaker
```

Portable shell mode:

```powershell
.\USOS\build\dist\usos.exe shell
```

Shell commands:

* `help`
* `clock`
* `calc <a> <b>`
* `note set <text>`
* `note show`
* `translate <word>`
* `sentence <text>`
* `codebreaker <1-8>`
* `diag`
* `ui <event>`
* `exit`

## Output

The build produces:

* `USOS/build/libusos.a`
* `USOS/build/usos.exe`
* `USOS/build/dist/` with the runtime DLLs needed to run on another Windows machine
