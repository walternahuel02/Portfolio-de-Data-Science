### Instrucciones de uso.
 - 1 . Descargar el archivo .ipynb y, abrirlo en GOOGLE COLAB (plataforma para abrir códigos sin descargar nada ni correr riesgos), o abrirlo en programas como VISUAL CODE.
 - 2 . Debe ejecutarse cada uno de los códigos, el primer grupo tardará menos de medio minuto pues debe instalar lo necesario, el resto no tardará nada. No te pedirá nada.
 - 3 . Ejecutarás vos info() para llamar a la función que genera los dataframes.
 - 4. Ejecturarás vos panel_grafico() al final, para realizar el gráfico.
  
  ------
#### Acá presento el código completo, con sus debidas aclaraciones para entenderlo. 

```python
!pip install world_bank_data
import requests
import world_bank_data as wb
import pandas as pd
import matplotlib.pyplot as plt
from ipywidgets import interact, widgets
from IPython.display import display, clear_output
import urllib3
```
```python
#preparo el listado de paises excluyendo las regiones agregadas y los territorios no autónomos.
countries = wb.get_countries()
countries = pd.DataFrame(countries)
df_countries = pd.DataFrame(countries)
countries = countries[countries["region"] != "Aggregates"]

# Dependencias excluidas
excluidos = [
        "Channel Islands","Cayman Islands","Bermuda","Hong Kong SAR, China","Macao SAR, China",
        "Puerto Rico","American Samoa","Guam","Northern Mariana Islands","Virgin Islands, U.S.",
        "Virgin Islands, British","Aruba","Curacao","Sint Maarten (Dutch part)","Svalbard and Jan Mayen",
        "Åland Islands","Greenland","French Polynesia","Guadeloupe","Martinique","Réunion","Mayotte",
        "Saint Pierre and Miquelon","Wallis and Futuna","New Caledonia","Cook Islands","Niue","Tokelau",
        "Bonaire, Sint Eustatius and Saba","Cocos (Keeling) Islands","Christmas Island","British Virgin Islands",
        "Gibraltar","Montserrat","Falkland Islands (Malvinas)","Saint Helena, Ascension and Tristan da Cunha",
        "French Southern Territories","Western Sahara","Isle of Man","Virgin Islands (U.S.)",
        "West Bank and Gaza","St. Martin (French part)","Turks and Caicos Islands"
    ]

countries = countries[~countries["name"].isin(excluidos)]
df_countries = pd.DataFrame(countries)
urllib3.disable_warnings()  # oculta el warning SSL
```
```python
def info():
    # --- 1. Indicadores ---                  # key : value =  indicador : código
    indicadores = {
        "Gasto público en educación (% del PIB)": "SE.XPD.TOTL.GD.ZS",
        "Gasto público en educación (% del gasto público total)": "SE.XPD.TOTL.GB.ZS",
        "Gasto total en educación (US$ constantes 2015)": "SE.XPD.TOTL.CD",
        "Esperanza de escolaridad (total de años)": "SE.SCH.LIFE",
        "Tasa de alfabetización, adultos (%)": "SE.ADT.LITR.ZS",
        "Duración obligatoria de la educación en años.": "SE.COM.DURS",
        "% de niñas que completan primaria": "SE.PRM.CMPT.FE.ZS",
        "% de varones que completan la primaria": "SE.PRM.CMPT.MA.ZS",
        "Cantidad de alumnos por maestro en primaria": "SE.PRM.ENRL.TC.ZS",
        "Cantidad de alumnos por maestro en secundaria": "SE.SEC.ENRL.TC.ZS",
        "% de jóvenes alfabetizados": "SE.ADT.1524.LT.ZS",
        "% de adultos alfabetizados": "SE.ADT.LITR.ZS"
    }

    # --- 2. Menús visuales ---
    indicador_dropdown = widgets.Dropdown(       #genera el primer widget (ventana a elegir entre opciones)
        options=indicadores.keys(),      #las opciones son las keys de indicadores (los nombres de los indicadores)
        description="Indicador:",
        style={'description_width': 'initial'}    #que entre todo en la línea.
    )

    pais_dropdown = widgets.Dropdown(
        options=countries["name"].sort_values().tolist(),
        description="País:",
        style={'description_width': 'initial'}
    )

    nombre_widget = widgets.Text(       #abre el widget tipo texto, el CÓMO querés llamar al dataframe.
        description="Nombre DF:",
        placeholder="Ej: df_arg_2023")   #sugerencia.

    boton = widgets.Button(description="Buscar", button_style="info")
    salida = widgets.Output()

    def on_click(b):       #funcionamiento del botón buscar
        with salida:
            clear_output()
            nombre_indicador = indicador_dropdown.value   #aloja el nombre que elegiste.
            codigo = indicadores[nombre_indicador]        #aloja el value de la key que elegiste, osea el código del indicador.
            pais = pais_dropdown.value                    #aloja en pais al pais que elegiste.
            nombre_df = nombre_widget.value.strip()       #aloja en nombre_df al nombre que escribiste para llamar al df

            if nombre_df == "":         #condición si no elegiste como llamar al df.
                print("❌ Debes escribir un nombre para el DataFrame")
                return

            cod_pais = countries.loc[countries["name"] == pais].index[0] #importante pues no sirve el nombre del pais si no su código, acá guardas en cod_pais el respectivo valor índice que tiene (index es la columna índice que aloja los id)

            # buscar en la info de la API
            url = f"https://api.worldbank.org/v2/country/{cod_pais}/indicator/{codigo}?format=json&per_page=500"  #variará según el cod_pais que elijamos en país, y  el código obtenido de la key que elegimos.
            response = requests.get(url, verify=False)
            data = response.json()

            if not data or len(data) < 2: #si la API del Banco Mundial no devolvió ningún resultado, esta condición será True.
                print("❌ No se encontraron datos") #La API devuelve normalmente una lista de 2 elementos: data[0] → metadatos sobre la consulta (páginas, total de resultados, etc.) data[1] → los datos reales que queremos (los indicadores año por año)
                return

            df = pd.json_normalize(data[1]) #creamos el df con los datos del elemento 1, los datos que queremos.
            df = df[["country.value","date","value"]].rename(
                columns={"country.value":"pais","date":"año","value":"valor"})
            df = df.dropna(subset=["valor"]).sort_values("año").reset_index(drop=True) #limpiamos el df poniendo los títulos en español.

            # Guardar el DataFrame en globals() con el nombre que escribiste
            globals()[nombre_df] = df #acá hace uso del campo de texto que había al inicio, aloja en variables globales al df, con el nombre que se eligió.

            print(f"✅ ¡DataFrame '{nombre_df}' creado!")
            display(df.tail()) #vemos la cola de los datos, es decir, los ultimos años, los últimos datos, los mas recientes.

    boton.on_click(on_click)
    display(indicador_dropdown, pais_dropdown, nombre_widget, boton, salida) #te muestra los botones y widgets que codificamos antes.

```

```python
#creamos la funcion que grafica. al usar df_list ya podemos mezclar dfs. El título se cambiará en otra función.
def graficar(df_list, titulo="Comparación de indicadores"):
    plt.figure(figsize=(10,6))

    for df in df_list:
        df = df.dropna(subset=["valor"])
        df = df.sort_values("año")
        df["año"] = df["año"].astype(int)
        pais = df["pais"].iloc[0]
        plt.plot(df["año"], df["valor"], marker='o', label=pais)

    plt.title(titulo)
    plt.xlabel("Año")
    plt.ylabel("Valor")
    plt.grid(True)
    plt.legend()
    plt.xticks(rotation=45)
    plt.show()
```


```python
def panel_grafico():   #Este es el apartado visual antes de que se active la función graficar.
    # --- 1. Detectar solo los DataFrames válidos de info() ---  evita que haya de opciones otras variables  globales que no son dataframes.
    posibles_dfs = [var for var, val in globals().items()
                    if isinstance(val, pd.DataFrame) and "año" in val.columns and "valor" in val.columns] #comprueba si es la variable que uno espera:
                      # insistance comprueba si la variable val es un DataFrame de pandas.
                      # Verifica que el DataFrame tenga una columna llamada "año".
                      # también verifica que el DataFrame tenga una columna llamada "valor".

    if not posibles_dfs:
        print("❌ No se encontraron DataFrames válidos para graficar.")
        return

    # --- 2. Mensaje de instrucciones ---
    mensaje = widgets.Label("Mantenga presionado Ctrl para seleccionar múltiples DataFrames")

    # --- 3. Widgets ---
    dfs_widget = widgets.SelectMultiple(
        options=posibles_dfs,  #las opciones son los dataframes que acabamos de filtrar, los que si nos sirven, los que tienen año y valor, y estructura de pandas.
        description="Tablas de información:",
        style={'description_width':'initial'}
    )

    titulo_widget = widgets.Text(
        value="Comparación de indicadores",
        description="Título:",
        style={'description_width':'initial'}
    )

    boton = widgets.Button(description="Graficar", button_style="success") #visual del botón graficar.
    salida = widgets.Output()

    # --- 4. Acción del botón ---
    def on_click(b): #al apretar el botón
        with salida:
            clear_output()
            seleccion = dfs_widget.value
            if not seleccion:
                print("❌ Debes seleccionar al menos un DataFrame")
                return
            #hace:
            df_list = [globals()[name] for name in seleccion] #crea la lista de dfs que se va a graficar, aquella que necesitamos para la función graficar()
            graficar(df_list, titulo_widget.value)  #reemplaza la lista con cada uno de los nombres, y pone en el espacio del título aquel que escribimos en el widget pasado.

    boton.on_click(on_click)

    # --- 5. Mostrar widgets ---
    display(mensaje, dfs_widget, titulo_widget, boton, salida)
```
