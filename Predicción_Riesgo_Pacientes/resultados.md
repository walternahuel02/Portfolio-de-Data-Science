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
# 📊 DASHBOARD EN POWER BI
Se transformó la base de datos creando la columna del riesgo respectivo de cada paciente, y se creó una nueva columna de riesgo escalado que va del 0 al 100, con ello se pudo crear esta visualización de datos.

<img width="1360" height="728" alt="image" src="https://github.com/user-attachments/assets/14fa0b2f-f916-4200-9955-dbe444988083" />


**Tenemos un conteo de pacientes y la segmentación de cada uno en su respectivo nivel**
**Tenemos la composición de los niveles en el total, notando que predominan los pacientes de riesgo medio**
**Tenemos un ranking de los diez pacientes con mayor riesgo del dataset**

Si el cursor se posa sobre un paciente del top 10 podemos ver la información detallada, analizando cada una de sus variables.

<img width="557" height="387" alt="image" src="https://github.com/user-attachments/assets/5b0ce211-b2d1-4ff8-ad78-d70221f3ed4b" />

Luego en la siguiente página vemos el promedio de cada una de las variables, desde latidos del corazón a la cantidad de pacientes que usan oxígeno suplementario, pudiendo filtrar por nivel de riesgo o incluso por paciente específico.

<img width="901" height="511" alt="image" src="https://github.com/user-attachments/assets/ab30f11d-43da-4d50-b9e2-ad2645b3a879" />

# 📊 CALCULADORA DE RIESGO EN PYTHON
Al conocer los coef estimados se me ocurrió codificar una calculadora en Google Colab, simulando la situación en la que un paciente llega y luego de un chequeo el enfermero rellena la caaculadora con los datos, y en el momento recibe el resultado sobre su nivel de riesgo.

https://colab.research.google.com/drive/1cyayWApDDefLxSIx648bgQMOeAWJQdjC

<img width="613" height="383" alt="image" src="https://github.com/user-attachments/assets/02e6d2e2-324c-47a6-8513-9532560fd109" />

Se adjunta el código de Python. La calculadora tiene una correción en cuanto a la imperfección del modelo. Ahora cuenta con rangos típicos de la fisiología. Si se sale del rango automáticamente te categoriza como riesgo alto.

```python

import textwrap
import time
import sys

# Definir coeficientes
coeficientes = {
    "temperatura": 2.71948,
    "oxg": 3.39400,
    "oxgsat": -1.13803,
    "heart_rate": 0.2077,
    "systolic_BP": -0.20885,
    "consciousness": 0.78533,
    "respiratory_rate": 0.72907,
    "o2_scale": -1.47600
}

# Función de animación
def animar_texto(texto, delay=0.2, puntos=3):
    """Animación simple con puntitos para simular proceso."""
    print(texto, end="")
    for _ in range(puntos):
        sys.stdout.flush()
        time.sleep(delay)
        print(".", end="")
    print("\n")

print("=" * 50)
print("      Bienvenido a la Calculadora de Riesgo Clínico")
print("=" * 50)
print("\nPor favor, ingrese los datos solicitados:\n")

# === INPUTS CON VALIDACIÓN ===
temperatura = float(input("🌡️  Temperatura del paciente (°C): "))
if temperatura < 34 or temperatura > 42:
    print("⚠️ Temperatura fuera de rango clínico (34–42 °C).")
    print("👉 El paciente se considera en riesgo ALTO automáticamente.\n")
    nivel = "🔴 Alto"
    riesgo = float("inf")
else:
    oxigeno = float(input("🫁 Nivel de oxígeno en sangre (%): "))
    if oxigeno < 80 or oxigeno > 100:
        print("⚠️ % de saturación fuera de rango clínico (80–100%).")
        print("👉 El paciente se considera en riesgo ALTO automáticamente.\n")
        nivel = "🔴 Alto"
        riesgo = float("inf")
    else:
        respiracion = int(input("😮‍💨 Respiraciones por minuto: "))
        if respiracion < 10 or respiracion > 30:
            print("⚠️ Respiraciones fuera de rango clínico (10–30).")
            print("👉 El paciente se considera en riesgo ALTO automáticamente.\n")
            nivel = "🔴 Alto"
            riesgo = float("inf")
        else:
            latidos = int(input("❤️ Latidos del corazón por minuto: "))
            if latidos < 40 or latidos > 130:
                print("⚠️ Latidos fuera de rango clínico (40–130).")
                print("👉 El paciente se considera en riesgo ALTO automáticamente.\n")
                nivel = "🔴 Alto"
                riesgo = float("inf")
            else:
                # === Nivel de conciencia ===
                print("\n🧠 Nivel de conciencia (elija un número):")
                print(textwrap.dedent("""\
                    1 - Consciente
                    2 - Responde al dolor
                    3 - Estado de confusión
                    4 - Da al menos respuestas verbales
                    5 - No responde
                """))
                while True:
                    try:
                        conciencia = int(input("👉 Selección: "))
                        if 1 <= conciencia <= 5:
                            break
                        else:
                            print("⚠️ Seleccione entre las 5 opciones (1–5). Intente nuevamente.")
                    except ValueError:
                        print("⚠️ Entrada no válida. Ingrese un número entre 1 y 5.")

                # === Oxígeno suplementario ===
                print("\n💨 ¿Usa asistencia de oxígeno?")
                print("    1 - Sí")
                print("    0 - No")
                while True:
                    try:
                        asistencia = int(input("👉 Selección: "))
                        if asistencia in [0, 1]:
                            break
                        else:
                            print("⚠️ Seleccione 0 o 1. Intente nuevamente.")
                    except ValueError:
                        print("⚠️ Entrada no válida. Ingrese 0 o 1.")

                # === Escala de oxigenoterapia ===
                print("\n📊 Escala de oxigenoterapia aplicada:")
                print("    1 - Tipo 1")
                print("    2 - Tipo 2")
                while True:
                    try:
                        o2_scala = int(input("👉 Selección: "))
                        if o2_scala in [1, 2]:
                            break
                        else:
                            print("⚠️ Seleccione 1 o 2. Intente nuevamente.")
                    except ValueError:
                        print("⚠️ Entrada no válida. Ingrese 1 o 2.")

                # === Presión arterial sistólica ===
                systolic_Bp = int(input("\n🩸 Presión arterial sistólica (mmHg): "))
                if systolic_Bp < 75 or systolic_Bp > 140:
                    print("⚠️ Presión arterial fuera del rango clínico (75–140).")
                    print("👉 El paciente se considera en riesgo ALTO automáticamente.\n")
                    nivel = "🔴 Alto"
                    riesgo = float("inf")
                else:
                    print("\n" + "=" * 50)
                    print("✅ Datos cargados correctamente. Gracias.")
                    print("=" * 50)

                    time.sleep(2)
                    animar_texto("🔎 Determinando el puntaje de riesgo")
                    time.sleep(2)

                    # === CÁLCULO DEL RIESGO ===
                    riesgo = (
                        coeficientes["temperatura"] * temperatura +
                        coeficientes["heart_rate"] * latidos +
                        coeficientes["respiratory_rate"] * respiracion +
                        coeficientes["consciousness"] * conciencia +
                        coeficientes["oxg"] * asistencia +
                        coeficientes["oxgsat"] * oxigeno +
                        coeficientes["o2_scale"] * o2_scala +
                        coeficientes["systolic_BP"] * systolic_Bp
                    )

                    print(f"📊 Puntaje de riesgo calculado: {riesgo:.2f}\n")
                    animar_texto("📈 Evaluando nivel de riesgo")
                    time.sleep(4)

                    # === CLASIFICACIÓN DEL RIESGO ===
                    if riesgo < -6.233:
                        nivel = "🟢 Normal"
                    elif -6.233 < riesgo < 5.919:
                        nivel = "🟡 Bajo"
                    elif 5.919 < riesgo < 19.262:
                        nivel = "🟠 Medio"
                    else:
                        nivel = "🔴 Alto"

                    print("=" * 50)
                    print("🏥 RESULTADO FINAL")
                    print("=" * 50)
                    print(f"👉 Puntaje total: {riesgo:.2f}")
                    print(f"👉 Nivel de riesgo: {nivel}")
                    print("=" * 50 + "\n")

```

