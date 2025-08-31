
                     ##BIENVENDIO AL APARTADO DE CÓDIGOS.
install.packages("readxl") #ejecutar solo la primera vez.

library(readxl) #empezar con este código en cada sesión.
datos <- read_excel("Riesgo_de_salud.xlsx") #asegurate de al excel llamarlo
#como el objeto datos. 


#PRIMERO HARÉ UNA LIMPIEZA, CAMBIANDO LAS VARIABLES CATEGÓRICAS (A, P, C, V, U)
#EN VARIABLES NUMÉRICAS.

datos$Consciousness <- ifelse(datos$Consciousness == "A", 5,
                                 ifelse(datos$Consciousness == "P", 4,
                                           ifelse(datos$Consciousness == "C", 3,
                                                       ifelse(datos$Consciousness == "V", 2,ifelse(datos$Consciousness == "U", 1, NA)))))
#ASÍ MISMO LA COLUMNA DE LA V. EXPLICADA ES CATEGÓRICA IGUAL, LO CAMBIAMOS CON EL
#MISMO PROCESO.

datos$Risk_Level <- ifelse(datos$Risk_Level=="Normal", 0, ifelse(datos$Risk_Level== "Low", 1, ifelse(datos$Risk_Level=="Medium", 2, ifelse(datos$Risk_Level=="High",3, NA))))

#COMO PARTE DE LA LIMPIEZA, LA TEMPERATURA ESTÁ EN FORMATO CHR, CAMBIAMOS A NUM
datos$Temperature <- as.numeric(datos$Temperature) #cambiar de chr a num

#Listo para trabajar.EL CAMINO MÁS SIMPLE ES EL SIGUIENTE: CREAR EL MODELO LINEAL

modelo <- lm(datos$Risk_Level ~ datos$Respiratory_Rate + datos$Oxygen_Saturation + datos$O2_Scale + datos$Systolic_BP + datos$Heart_Rate + datos$Temperature + datos$Consciousness + datos$On_Oxygen, data=datos)

summary(modelo) #AQUÍ TENEMOS LA INFORMACIÓN.
#TENEMOS UN RCUADRADO AJUSTADO DE 0.8766, POR LO QUE NUESTRO MODELO ES EXCELENTE
#EXPLICANDO.

---
  ## ACÁ VAMOS A UN ANÁLISIS MÁS DETALLADO. 
  
  
### ¿Y SI CONSEGUIMOS UN MEJOR MODELO PARA VER SI NUESTRA PREDICCIÓN MEJORA? ##
#En ese caso debemos deshacernos de variables no significativas, y ver si el R2 ajustado
#quedó mayor. Por ejemplo ¿cual es nuestra variable más débil? De alguna forma es
#el nivel de consciencia, pues explica un 0.0057595. ¿y si la quitamos del modelo,
#lograremos explicarlo mejor?


modeloSC <- lm(datos$Risk_Level ~ datos$Respiratory_Rate + datos$Oxygen_Saturation + datos$O2_Scale + datos$Systolic_BP + datos$Heart_Rate + datos$Temperature + datos$On_Oxygen, data=datos)
summary(modeloSC)
#MODELO ANTERIOR. CONCLUIMOS QUE ERA UNA VARIABLE QUE POCO EXPLICABA EL RIESGO EN LOS
#PACIENTES, PERO, DESHACERNOS DE ELLA NO MODIFICA IMPORTANTEMENTE NUESTRO RENDIMIENTO.

              #NUESTRO ANÁLISIS PUEDE PROSEGUIR, TRABAJAREMOS CON MODELOSC

# 1) Distribución de los residuos en el modelo.
residuos_modeloSC <- modeloSC$residuals
hist(residuos_modeloSC) # A simple vista, la distribución no es perfectamente simétrica:
                        #parece un poco sesgada a la derecha 
                        #(cola más larga hacia valores positivos).

#  2)En lugar del histograma, veamos los residuos a lo
#largo del gráfico normal Q-Q. Si hay normalidad, 
#los valores deben seguir una línea recta.

> qqnorm(residuos_modeloSC)
> qqline(residuos_modeloSC)
#o, otra forma de calcular lo mismo
plot(modelo, which=2) 
shapiro.test(residuals(modelo))
#Resultado: W = 0.99355, p-value = 0.0002567.
#Como el p-value < 0.05, se rechaza la hipótesis nula de normalidad 
#→ los residuos no siguen una distribución normal.

#EL MODELOSC Y SUS BETAS SIGUEN SIENDO INSESGADOS Y CONSISTENTES, SOLO QUE
#HACER TEST E INTERVALOS DE CONFIANZA (inf estad) YA NO SERAN TAN CONFIABLES POR ESTO QUE 
#ACABAMOS DE DESCUBRIR. 

#ANALISIS DE MULTICOLINEALIDAD
#CREAREMOS UN GRÁFICO PARA VER LA CORRELATIVIDAD DE LAS VARIABLES.
datos_analisis <- datos
install.packages("ggcorrplot")
library("ggcorrplot")
datos_analisis <- subset(datos_analisis, select= -Risk_Level) #RETIRAMOS ESTAS COLUM
datos_analisis <- subset(datos_analisis, select= -Patient_ID) #QUE SON CATEGÓRICAS.
corr_matrix = round(cor(datos_analisis), 2)
ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower",
           lab = TRUE)  #FINALMENTE CONCLUIMOS QUE NO HAY PELIGRO DE COLINEALIDAD.
#A LO SUMO EL RANGO DE RESPIRACIÓN Y DE LATIDOS POR MINUTO (0.68) SE APROXIMA 0.7
#Y ESO EXPLICA CIERTA CORRELACIÓN, PARA ELLO USAMOS EL CÓDIGO VIF PARA VER SI HAY
#REDUNDANCIA EN NUESTRAS VARIABLES (SI SUPERAN 5 CONSIDERAMOS REDUNDANCIA)
library(car)
vif(modelo) #NADA DE REDUNDANCIA. SI LO HUBIERA NOS CONVENÍA DESHACERNOS. 

#PERO... ¿Y SI AL DESHACERNOS DE UNO DE ESTAS DOS VARIABLES QUE, EN TEORÍA, 
#PARECEN EXPLICAR LO MISMO, DESCUBRO UN MEJOR MODELO?
  #PRIMERO ARMAREMOS DEL MODELO QUITANDO LA VARIABLE MENOS EXPLICATIVA ENTRE
  #RESPIRACIÓN Y LATIDOS POR MINUTO, EN ESE CASO LOS LATIDOS DEL CORAZÓN POR MIN.
MODELO3 <- lm(datos$Risk_Level ~ datos$Respiratory_Rate + datos$Oxygen_Saturation + datos$O2_Scale + datos$Systolic_BP + datos$Temperature + datos$On_Oxygen, data=datos)
summary(MODELO3)
#nuestro R2 ajustado se redujo. No parece ser lo indicado deshacernos de esta variable.
#Comparemos para sacarnos dudas, visulamente, con el grafico QQ de residuos
residuos_MODELO3 <- MODELO3$residuals
qqnorm(residuos_MODELO3)
qqline(residuos_MODELO3)
#ES APENAS INDISTINTO. CONCLUIMOS QUE, POR PEQUEÑAS DIFERENCIAS, NOS QUEDAMOS CON
#MODELOSC. 