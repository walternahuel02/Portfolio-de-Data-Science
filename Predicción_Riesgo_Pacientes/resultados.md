# 📊 Resultados del Modelo de Predicción de Riesgo en Pacientes

El objetivo de este proyecto fue desarrollar un modelo que clasifique a los pacientes en **Riesgo Normal, Bajo, Medio o Alto**, basado en variables clínicas.  


---

## 🔹 Resumen del Modelo

A continuación, se presenta el resumen del modelo :

<img width="532" height="173" alt="image" src="https://github.com/user-attachments/assets/40432118-2454-45a7-9ab8-379bed99bfef" />



---

## 🔹 Estimadores del Modelo

<img width="723" height="87" alt="image" src="https://github.com/user-attachments/assets/120f7579-9d72-4683-81ae-d1a958f7f4b8" />



**Interpretación de coeficientes:**

| Variable | Coeficiente | Interpretación |
|----------|------------|----------------|
| **Si recibe oxígeno suplementario** | 3,394 | Si la respuesta es **SÍ**, el riesgo del paciente aumenta en promedio **3,394 puntos**. |
| **Saturación de oxígeno (%)** | -1,138 | Relación negativa: a mayor saturación, menor riesgo. Un aumento de 1% en saturación reduce el riesgo en **1,138 puntos**, consistente con la medicina: más oxígeno disponible protege mejor los órganos. Menos oxígeno, perjudicial para los órganos vitales |


> ⚠️ Nota: Este análisis segmenta los cuatro estados de riesgo en cuatro cohortes de valores distinta, según:
<img width="449" height="85" alt="image" src="https://github.com/user-attachments/assets/f22dc9f1-5f81-4987-8561-af902913fd80" />

| Puntaje estimado | Estado de riesgo |
|-----------------|----------------|
| < -6,23 | Normal |
| -6,23 a 5,919 | Bajo |
| 5,919 a 19,262 | Medio |
| > 19,262 | Alto |

---

## 🔹 Correlaciones entre Variables

Se evaluó la **colinealidad** entre variables para detectar si algunas explican lo mismo:

<img width="634" height="433" alt="image" src="https://github.com/user-attachments/assets/23adf87f-3090-4174-aad1-9b3fb5ee03e6" />



- Las variables **latidos por minuto** y **respiración por minuto** tienen alta correlación (cercana a 0.7).  
- No hay problema en mantener estas dos variables.

---

