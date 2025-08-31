# Proyecto: Predicción de Riesgo en Pacientes

## 📌 Descripción del Dataset
Este conjunto de datos contiene información de salud de **1000 pacientes reales**, cuidadosamente depurada y **anonimizada** para proteger la privacidad.  
Incluye constantes vitales y parámetros clínicos junto con su correspondiente **nivel de riesgo de salud** (Normal, Bajo, Medio, Alto).  

El dataset está diseñado para investigación en **ciencia de datos, aprendizaje automático y análisis de salud**, permitiendo:
- Crear modelos predictivos para la **detección temprana de pacientes de alto riesgo**.
- Construir visualizaciones que apoyen la **toma de decisiones médicas**.

### Columnas disponibles:
- `Patient_ID`: Identificador único y anónimo del paciente.  
- `Respiratory_Rate`: Frecuencia respiratoria (respiraciones por minuto).  
- `Oxygen_Saturation`: Saturación de oxígeno (%) en sangre.  
- `O2_Scale`: Escala de oxigenoterapia utilizada.  
- `Systolic_BP`: Presión arterial sistólica (mmHg).  
- `Heart_Rate`: Frecuencia cardíaca (latidos por minuto).  
- `Temperature`: Temperatura corporal (°C).  
- `Consciousness`: Nivel de conciencia (`A = Alert`, `P = Pain response`, `C = Confusion`, `V = Verbal`, `U = Unresponsive`).  
- `On_Oxygen`: Si el paciente recibe oxígeno suplementario (`0 = No`, `1 = Sí`).  
- `Risk_Level`: Nivel de riesgo (`Normal`, `Bajo`, `Medio`, `Alto`).  

---

## 🎯 Objetivo del Proyecto
Este proyecto tiene un doble propósito:
1. **Aprendizaje en Ciencia de Datos**:  
   - Limpieza y codificación de variables categóricas en R.  
   - Creación de modelos de regresión para predecir el nivel de riesgo de los pacientes.  

2. **Visualización de Datos en Power BI**:  
   - Construcción de un **dashboard interactivo** que permita explorar las variables clínicas y su relación con el nivel de riesgo.  

---

## 🛠️ Tecnologías utilizadas
- **Lenguaje**: R  
- **Visualización**: Power BI  
- **Gestión de proyecto**: GitHub  

---

## 📂 Estructura del Repositorio
```bash
.
├── data/             # Dataset original (anonimizado)
├── scripts/          # Código en R para análisis y modelado
├── dashboard/        # Archivos del dashboard en Power BI
└── README.md         # Descripción general del proyecto
🚀 Próximos pasos
Explorar métricas de desempeño del modelo predictivo.

Refinar el dashboard para incluir indicadores clave.

Documentar hallazgos y conclusiones.

⚠️ Nota
Este proyecto se utiliza únicamente con fines educativos y de aprendizaje en ciencia de datos.
No debe ser interpretado como una herramienta médica real ni reemplaza la opinión de profesionales de la salud.
