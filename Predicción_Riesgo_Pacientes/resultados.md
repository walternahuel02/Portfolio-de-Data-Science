# 📊 Resultados del Modelo de Predicción de Riesgo en Pacientes

El objetivo de este proyecto fue desarrollar un modelo que clasifique a los pacientes en **Riesgo Normal, Bajo, Medio o Alto**, basado en variables clínicas.  

Tras evaluar distintos enfoques, el **mejor modelo explicativo** se obtuvo **excluyendo la columna “Estado de Conciencia”**, ya que no aportaba información relevante para la predicción.  

---

## 🔹 Resumen del Modelo

A continuación, se presenta el resumen del modelo final:

![SUMMARY_MODELO](https://raw.githubusercontent.com/walternahuel02/Portfolio-de-Data-Science/refs/heads/main/Predicci%C3%B3n_Riesgo_Pacientes/im%C3%A1genes/summary%20MODELO%20SC.jpg)

El **R² ajustado = 0.8768**, lo que indica que nuestro modelo explica aproximadamente el **88% de la variabilidad** en los niveles de riesgo.

---

## 🔹 Estimadores del Modelo

<img width="586" height="71" alt="image" src="https://github.com/user-attachments/assets/251f8ab2-d98c-45f0-9dbb-ec9fe14128fa" />

**Interpretación de coeficientes:**

- **Temperatura (coeficiente = 0.1940):**  
  Si la temperatura sube 1 unidad (°C), el riesgo aumenta en promedio **0.194 puntos**.  

- **Saturación de oxígeno (%) (coeficiente = -0.0417):**  
  Relación negativa: a mayor saturación, menor riesgo. Un aumento de 1% en saturación reduce el riesgo en **0.04 puntos**, consistente con la medicina: más oxígeno disponible, órganos más protegidos.  

> ⚠️ Nota: Este análisis asume que pasar de un estado de riesgo al otro tiene la misma distancia:  
> - 0–1: Riesgo normal  
> - 1–2: Riesgo bajo  
> - 2–3: Riesgo medio  
> - 3–4: Riesgo alto

---

## 🔹 Correlaciones entre Variables

Se evaluó la **colinealidad** entre variables para detectar si algunas explican lo mismo:

![VCORR](https://raw.githubusercontent.com/walternahuel02/Portfolio-de-Data-Science/refs/heads/main/Predicci%C3%B3n_Riesgo_Pacientes/im%C3%A1genes/correlaci%C3%B3n%20entre%20v.jpg)

- Las variables **latidos por minuto** y **respiración por minuto** tienen alta correlación (cercana a 0.7).  
- Mantener ambas variables mejora el R² ajustado, aumentando la precisión del modelo.

---

## 🔹 Normalidad de los Residuos

Para validar los supuestos de inferencia estadística, se analizó la **distribución de los residuos**:

![histog](https://raw.githubusercontent.com/walternahuel02/Portfolio-de-Data-Science/refs/heads/main/Predicci%C3%B3n_Riesgo_Pacientes/im%C3%A1genes/histograma.jpg) 
![qq](https://raw.githubusercontent.com/walternahuel02/Portfolio-de-Data-Science/refs/heads/main/Predicci%C3%B3n_Riesgo_Pacientes/im%C3%A1genes/QQ%20RESIDUALS.jpg)

- Tanto el **histograma** como el **QQ plot** muestran que los residuos no siguen una distribución normal.  
- Por lo tanto, **la inferencia estadística debe tomarse con cautela**.
