library(readxl)
library(ordinal)
library(ggcorrplot)
library(car)


datos$Temperature <- as.numeric(datos$Temperature) #cambiar de chr a num

datos$Consciousness <- as.numeric(factor(datos$Consciousness,
                                         levels = c("A","P","C","V","U"),
                                         ordered = TRUE))

datos$Risk_Level <- factor(datos$Risk_Level,
                              levels = c("Normal","Low","Medium","High"),
                              ordered = TRUE)



modelo1 <- clm(Risk_Level ~ Respiratory_Rate + Oxygen_Saturation + O2_Scale + Systolic_BP +Heart_Rate + Temperature + On_Oxygen + Consciousness, data=datos)

summary(modelo1)


datos_analisis <- datos
datos_analisis <- subset(datos_analisis, select= -Risk_Level) #RETIRAMOS ESTAS COLUM
datos_analisis <- subset(datos_analisis, select= -Patient_ID) #QUE SON CATEGÓRICAS.
corr_matrix = round(cor(datos_analisis), 2)
ggcorrplot(corr_matrix, hc.order = TRUE, type = "lower",
           lab = TRUE)


cor(datos[, c("Heart_Rate","Respiratory_Rate")])
lm_temp <- lm(as.numeric(Risk_Level) ~ Respiratory_Rate + Oxygen_Saturation + O2_Scale + Systolic_BP +Heart_Rate + Temperature + On_Oxygen + Consciousness, data=datos)
car::vif(lm_temp)
summary(lm_temp)

install.packages("MASS")
install.packages("pscl")
library(MASS)
library(pscl)
pR2(modelo1)