
## ⚙️ Instalación y uso
```R
# instalar librerías necesarias
install.packages(c("readxl", "car", "ggcorrplot"))

# cargar librerías
library(readxl)
library(car)
library(ggcorrplot)
```

Leer los datos (asegurarse de nombrar al objeto "datos" con el archivo excel de la carpeta data)
datos <- read_excel("Riesgo_de_salud.xlsx")
🧹 Preprocesamiento
Se codificaron variables categóricas a numéricas (Consciousness, Risk_Level).

Se corrigió el formato de Temperature (de texto a numérico).

```R
# ejemplo: conversión de Risk_Level
datos$Risk_Level <- ifelse(datos$Risk_Level=="Normal", 0,
                      ifelse(datos$Risk_Level=="Low", 1,
                      ifelse(datos$Risk_Level=="Medium", 2,
                      ifelse(datos$Risk_Level=="High", 3, NA))))
```
📈 Modelado
Se probó un modelo de regresión lineal múltiple con todas las variables, y luego se compararon modelos
alternativos quitando variables poco significativas.

```R
modelo <- lm(Risk_Level ~ Respiratory_Rate + Oxygen_Saturation + 
             O2_Scale + Systolic_BP + Heart_Rate + Temperature + 
             Consciousness + On_Oxygen, data=datos)

summary(modelo)
```
📌 R² ajustado ≈ 0.8766 → excelente capacidad explicativa.

🔍 Análisis adicional
Residuos

Histograma y Q-Q plot mostraron ligera asimetría → residuos no normales.

Test de Shapiro-Wilk confirmó p < 0.05 (no normalidad).



## Multicolinealidad

Correlación entre frecuencia respiratoria y cardíaca (r = 0.68).

VIF < 5 → no hay redundancia crítica.


# 📊Comparación de modelos
Modelo completo: todas las variables → R² ajustado 0.8766.

Modelo sin Conciencia: R² ajustado 0.8768 → mejora mínima, variable poco explicativa.

Modelo sin Heart Rate: R² ajustado más bajo → no conviene eliminarlo.

📌 Conclusión: el modelo sin Conciencia (modeloSC) es el más adecuado.


## ✅ Conclusiones
El modelo explica ~88% de la variabilidad del riesgo.

La variable Conciencia aporta muy poco → puede excluirse.

No se detecta colinealidad grave.

Los residuos no son normales → los coeficientes siguen siendo insesgados, pero los tests clásicos de significancia deben interpretarse con cautela.




