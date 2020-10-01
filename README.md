# Resuelve

Solución al [Problema](/problem.md) del equipo Resuelve FC.

## Requisitos:
```bash
$ ruby -v   # 2.6.3
$ bundle -v # 2.0.2
```

## Instalación
### Deste el repositorio de Github:
```bash
$ git clone https://github.com/hackvan/resuelve.git
$ cd resuelve/
$ bundle install
```

## Ejecución:
**Opciones del programa:**

Podemos consultar desde la consola las opciones disponibles con la bandera `-h` o `--help`:
```bash
$ bundle exec ruby lib/app.rb -h

Usage: app.rb [options]

Specific options:
    -h, --help            Show this help message
    -i, --input INPUT     Specify the input file path
    -o, --output OUTPUT   Specify the output file path
    -s, --show            Show stats output in console
```

Para la ejecución del programa, por defecto este utiliza como entrada la información del archivo ubicado en `./resuelve/data/input.json` y por defecto devuelve los calculos para cada jugador en el archivo `./resuelve/data/output.json`:
```bash
$ bundle exec ruby lib/app.rb

✅ Archivo con estadisticas generado exitosamente en ".../resuelve/data/output.json"
```

De manera opcional se le puede especificar la ruta del archivo de entrada a utilizar con la bandera `-i` o `--input`:

```bash
$ bundle exec ruby lib/app.rb -i ~/Desktop/input_file.json

✅ Archivo con estadisticas generado exitosamente en ".../resuelve/data/output.json"
```

Y tambien personalizar la ruta con el archivo de salida a generar con la bandera `-o` o `--output`:

```bash
$ bundle exec ruby lib/app.rb -o ~/Desktop/output_file.json

✅ Archivo con estadisticas generado exitosamente en "~/Desktop/output_file.json"
```

Por ultimo si queremos que la información sea mostrada en la misma consola y no en un archivo plano, podemos utilizar la bandera `-s` o `--show`:

```bash
$ bundle exec ruby lib/app.rb -s

********************************************************************************
Equipo: rojo
Total Goles: 19
Total Minimos: 25
Alcance: 76.00%
Total Jugadores: 2
--------------------------------------------------------------------------------
>> Nombre: Juan Perez - Alcance: 66.67% - Sueldo Completo: 67833.33
>> Nombre: El Rulo - Alcance: 90.00% - Sueldo Completo: 42450.00
********************************************************************************
Equipo: azul
Total Goles: 37
Total Minimos: 25
Alcance: 148.00%
Total Jugadores: 2
--------------------------------------------------------------------------------
>> Nombre: EL Cuauh - Alcance: 150.00% - Sueldo Completo: 130000.00
>> Nombre: Cosme Fulanito - Alcance: 140.00% - Sueldo Completo: 30000.00
```