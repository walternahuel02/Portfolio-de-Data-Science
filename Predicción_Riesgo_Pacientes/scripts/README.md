
## ⚙️ Instalación y uso
```R
# instalar librerías necesarias
install.packages(c("readxl", "car", "ggcorrplot","ordinal"))

# cargar librerías
library(readxl)
library(car)
library(ggcorrplot)
library(ordinal)
```

Leer los datos (asegurarse de nombrar al objeto "datos" con el archivo excel de la carpeta data)
```R
datos <- read_excel("Riesgo_de_salud.xlsx")
```
### 🧹 Preprocesamiento
Se corrigió el formato de Temperature (de texto a numérico). 

```R

 datos$Temperature <- as.numeric(datos$Temperature) #cambiar de chr a num
```
Convertimos la columna de la variable explicada (el riesgo del paciente) en una variable ordinal que respete el valor del riesgo.
Así también haremos con la columna de Conciencia (Consciousness), pues también representa niveles, del 1 al 5.
```R
datos$Risk_Level <- factor(datos$Risk_Level,
                              levels = c("Normal","Low","Medium","High"),
                              ordered = TRUE)

datos$Consciousness <- as.numeric(factor(datos$Consciousness,
                                         levels = c("A","P","C","V","U"),
                                         ordered = TRUE))
```

##📈 Modelado
Ulitizamos clm para crear el modelo de regresión lineal múltiple, (a dif de usar lm, pues clm es aquel que respeta los valores ordinales.

```R
modelo <- lm(Risk_Level ~ Respiratory_Rate + Oxygen_Saturation + 
             O2_Scale + Systolic_BP + Heart_Rate + Temperature + 
             Consciousness + On_Oxygen, data=datos)

summary(modelo)
```
¡HEMOS LOGRADO PREDECIR EL RIESGO DE LOS PACIENTES!

<img width="452" height="298" alt="image" src="https://github.com/user-attachments/assets/2a7a45d0-7820-4fb2-a725-4ad7eb910249" />

📌 Los coeficientes del modelo muestran que variables como frecuencia respiratoria, frecuencia cardíaca, temperatura y necesidad de oxígeno aumentan el riesgo, mientras que mayor saturación de oxígeno en sangre y presión arterial sistólica lo reducen, indicando un patrón clínicamente coherente. 

La lectura es simple. Detrás de cada paciente hay un conteo de puntos que determinarán su riesgo. ¿Qué determina cuantos puntos tiene? Tomemos de ejemplo la variable TEMPERATURA, ceteris paribus. El estimador de Temperatura es de 2.71, esto indica que por cada grado de temperatura que tenga (C°), su nivel de riesgo aumentará 2.71 puntos. 

<img width="385" height="94" alt="image" src="https://github.com/user-attachments/assets/903bc6b2-cf46-4662-b2f0-784f754748bd" />

Abajo de la información de los estimadores obtenemos la siguiente tabla. Precisamente eso son los rangos númericos que nuestra regresión predice. Precisamente, si el paciente obtiene, por ejemplo, un valor de riesgo menor a -6.233 significa que se encuentra en la cohorte de pacientes con riesgo normal. Si supera ese valor pero aún se encuentra debajo de 5.919, está en la cohorte de riesgo bajo. Luego viene el rango de riesgo hasta 19.2 en donde estarías en la cohorte de riesgo medio. Y para los individuos que superen ese umbral, el riesgo que se les predice es de riesgo alto. 

##### Notar que, si un paciente llega y se le toma la información de cada columna, es posible usar esos datos, multiplicarlos por sus estimadores, predecir un nivel de riesgo y, considerando el rango en el que se encuentre ¡sabremos qué tipo de riesgo corre el paciente!


## 🔍 Análisis adicional

 ### Multicolinealidad
```R
datos_analisis <- datos
datos_analisis <- subset(datos_analisis, select= -Risk_Level) #RETIRAMOS ESTAS COLUM
datos_analisis <- subset(datos_analisis, select= -Patient_ID) #QUE SON CATEGÓRICAS.
corr_matrix = round(cor(datos_analisis), 2)
ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower",
           lab = TRUE)
```

<img width="1076" height="466" alt="image" src="https://github.com/user-attachments/assets/2bd87923-0f86-4176-812d-b6b813975f55" />
El mayor índice que podría indicar correlación se dio entre frecuencia respiratoria y cardíaca (r = 0.68). Rozando el valor crítico de 0.7
¿Hay colinealidad? es decir, usar ambas variables es redundante? 
Puedo crear un modelo lineal temporal, solo para probar la posible colinealidad. Solo así puedo usar el código VIF, y si este es mayor a 5, habría espacio a la redundancia.

```R
lm_temp <- lm(as.numeric(Risk_Level) ~ Respiratory_Rate + Oxygen_Saturation + O2_Scale + Systolic_BP +Heart_Rate + Temperature + On_Oxygen + Consciousness, data=datos)
car::vif(lm_temp)
```
VIF < 5 → no hay redundancia crítica.

## R² ajustado.
Como en esta ocasión por unsar clm no puedo directamente ver el R² ajustado clásico, si existe una manera de obtener un pseudo  R² para comparar entre modelos. Por el momento no hay otro mdoelo a comparar. (podríamos, a futuro, retirar una de las variables que consideremos que no sea significativa, y comparar entre estos dos modelos). 
La forma de sacar este pseudo  R² de nuestro modelo1 es de la siguiente manera.
```R
install.packages("MASS")
install.packages("pscl")
library(MASS)
library(pscl)
pR2(modelo)
```
<img width="767" height="72" alt="image" src="https://github.com/user-attachments/assets/9da5fb7f-079a-4177-8095-8c81b9c49540" />  

##### El Pseudo-R² de McFadden: cuando está entre 0.2–0.4 suele considerarse bueno, acá 0.90 es muy alto, indica que el modelo discrimina extremadamente bien entre categorías.
##### 2ML (Cox-Snell) = 0.9139. Es similar a R² clásico, pero máximo <1. Muy alto → excelente ajuste
##### r2CU (Nagelkerke) = 0.9784. Cox-Snell ajustado para tener máximo 1. Casi 1 → el modelo explica muy bien la variación relativa entre categorías de riesgo
##### Esto implica que los predictores juntos explican casi toda la información disponible para clasificar la variable ordinal.
##### Para el próximo modelo comparariamos McFadden contra McFadden, Cox-Snell contra Cox-Snell, etc. Si un modelo tiene pseudo-R² más alto en la misma métrica → ajuste mejor.






