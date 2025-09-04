
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

