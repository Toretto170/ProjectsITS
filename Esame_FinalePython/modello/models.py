# Importazione delle librerie necessarie
import joblib
from fastapi import FastAPI
from pydantic import BaseModel, Field


#Creo applicazione
app = FastAPI()

# Creazione del BaseModel basato sulle features del modello
class WineQualityPredictionInput(BaseModel):
    fixed_acidity: float
    volatile_acidity: float
    citric_acid: float
    residual_sugar: float
    chlorides: float
    free_sulfur_dioxide: float
    density: float
    pH: float
    sulphates: float
    alcohol: float
    quality: int 

# Importazione del modello addestrato
model = joblib.load("/Users/marco/PycharmProjects/ai_ml_esame_finale/modello/modello_logistic_regression.pkl")

# API Post - definizione della route, definizione degli input per le features sulle quali il modello farà la previsione
@app.post("/predict_wine_quality/")
def predict_wine_quality(input_data: WineQualityPredictionInput):
    # Elenco delle features utilizzate dal modello
    input_features = [
        input_data.fixed_acidity,
        input_data.volatile_acidity,
        input_data.citric_acid,
        input_data.residual_sugar,
        input_data.chlorides,
        input_data.free_sulfur_dioxide,
        input_data.density,
        input_data.pH,
        input_data.sulphates,
        input_data.alcohol,
        input_data.quality
    ]

# Previsioni utilizzando il modello
# Predizione: 0 pessima qualità, 1 ottima qualità
    prediction = model.predict([input_features])
    return {"Model's prediction: " "[0: bad quality / 1: best quality] ": prediction.tolist()}