# API Interactiva del Banco Mundial – Indicadores Educativos

¡Hola! 👋  

En un proyecto de clase aprendí a crear una API (Interfaz de Programación de Aplicaciones) que consulta las redes de información del **Banco Mundial** y recopila datos específicos según lo que uno necesite: un país determinado, un indicador concreto e incluso un rango de años.  

Aunque el proyecto original estaba enfocado en variables macroeconómicas, decidí llevarlo a otra área para practicar y explorar otros contextos. Elegí el área de **educación**, para poder comparar los indicadores educativos entre distintos países y graficar su evolución a lo largo del tiempo.  
Por ejemplo, este es el resultado que uno buscaría:

<img width="614" height="378" alt="image" src="https://github.com/user-attachments/assets/6eff5653-2d71-4cb7-9453-95ef93d1bf2b" />

###### Se trata de una compración de los años obligatorios entre tres países seleccionados. 


---

## Objetivos del proyecto

1. Extraer datos específicos del Banco Mundial y crear un **DataFrame** listo para analizar.  
2. Permitir la visualización y comparación de indicadores educativos de distintos países.  
3. Hacer la interacción **más visual e intuitiva**, usando widgets para selección de país e indicador.  

---

## Cómo funciona

1. **Selección de indicador y país**:  
   - El usuario ingresa el código info() para desplegar el menú.
   - El usuario puede elegir el indicador educativo que quiere analizar (por ejemplo: gasto público en educación, tasa de alfabetización, esperanza de escolaridad).
     
     <img width="428" height="176" alt="image" src="https://github.com/user-attachments/assets/43626499-7e6f-4e57-9bba-57cc95d7b68a" />
 
   - Luego selecciona el país deseado a través de un menú desplegable.
     
     <img width="428" height="176" alt="image" src="https://github.com/user-attachments/assets/b2df503a-d713-4ab2-afce-23afa6375212" />


     
   - El último paso implica definir un nombre para este conjunto de datos, por ejemplo "df_argentina". 
  

2. **Creación del DataFrame**:  
   - La API descarga automáticamente los datos del Banco Mundial.  
   - Genera un DataFrame con las columnas: `pais`, `año` y `valor`.
     
    <img width="413" height="357" alt="image" src="https://github.com/user-attachments/assets/27e3a98d-ee9b-4e73-91d8-160885b09329" />


   - El usuario puede ejecutar la función info() las veces que le sea necesario para crear los dataframes que necesitará. 
     


3. **Visualización interactiva**:  
   - Al ejecutar la función panel_grafico() se abre un panel de gráficos que permite seleccionar uno o varios DataFrames creados con la función info() y generar un gráfico comparativo con un título personalizado.
   - <img width="469" height="227" alt="image" src="https://github.com/user-attachments/assets/9c4840f9-0801-4a92-9c47-fbc698309bd8" />


---

## ¡Así de sencillo fue todo! Con este simple ejemplo se puede extrapolar a los tantos indicadores que proporciona el Banco Mundial. 
