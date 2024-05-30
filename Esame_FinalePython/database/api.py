# Importazione delle librerie necessarie

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import sqlite3
from sqlite3 import Error

app = FastAPI()

# Funzione che crea la connessione con il db
def create_connection():
    try:
        conn = sqlite3.connect('/Users/marco/PycharmProjects/Esame_FinalePython/database/sqlite/wine_data.db')

        return conn
    except Error as e:
        print(e)
        return None

# Creazione della classe WineData che verrà usata per il corpo delle API
# Per le colonne: 'type' e 'best_quality' che contengono record con valori 0 e 1 ho optato per utilizzare la classe Field di pydantic per imporre dei vincoli sui valori da inserire
# Stesso ragionamento è stato fatto per la colonna 'quality': in questo caso i valori vanno da 0 a 10

# Creazione della classe WineData che servirà per le varie API
class WineData(BaseModel):
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
    quality: int = Field(..., ge=0, le=10)
    type: int = Field(..., ge=0, le=1)
    best_quality: int = Field(..., ge=0, le=1)


# ========== #
#   API's    #
# ========== #

# # API Get - Operazione per recuperare i dati dei vini presenti nel db
# Parametri: tutti
# Gestisce l'apertura e la chiusura del db dopo l'operazione + messaggio di errore se non c'è la connessione al db
# Implementata la raise Exception qualora non sia possibile recuperare i record
# Ho deciso di richiedere tutti i parametri per ottenere un determinato record per evitare la possibilità di incorrere in errori

@app.get("/get_wine/")
async def get_wine(fixed_acidity: float, volatile_acidity: float, citric_acid: float, residual_sugar: float, chlorides: float,
                   free_sulfur_dioxide: float, density: float, pH: float, sulphates: float, alcohol: float,
                   quality: int, type: int, best_quality: int):
    connection = create_connection()
    if connection is None:
        return {"Error: An error occurred during the database connection."}
    cursor = connection.cursor()

    try:
        select_query = "SELECT * FROM wine WHERE fixed_acidity=? AND volatile_acidity=? AND citric_acid=? AND residual_sugar=? AND chlorides=? AND free_sulfur_dioxide=? AND density=? AND pH=? AND sulphates=? AND alcohol=? AND quality=? AND type=? AND best_quality=?"
        cursor.execute(select_query, (fixed_acidity, volatile_acidity, citric_acid, residual_sugar, chlorides, free_sulfur_dioxide, density, pH, sulphates, alcohol, quality, type, best_quality))
        result = cursor.fetchone()
        if result:
            wine_data = {
                "fixed_acidity": result[0],
                "volatile_acidity": result[1],
                "citric_acid": result[2],
                "residual_sugar": result[3],
                "chlorides": result[4],
                "free_sulfur_dioxide": result[5],
                "density": result[6],
                "pH": result[7],
                "sulphates": result[8],
                "alcohol": result[9],
                "quality": result[10],
                "type": result[11],
                "best_quality": result[12]
            }
            return wine_data
        else:
            raise HTTPException(status_code=404, detail="Record not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        connection.close()


# API Get - Operazione per recuperare i dati del vino in base alla colonna 'quality'
# Gestisce l'apertura e la chiusura della connessione con il db
# Raise Exception: ritorna un messaggio di errore qualora non ci siano i dati richiesti dalla Get

@app.get("/get_wine_by_quality/")
async def get_wine_by_quality(quality: int):
    connection = create_connection()
    if connection is None:
        return {"Error: An error occurred during the database connection."}
    cursor = connection.cursor()

    try:
        select_query = "SELECT * FROM wine WHERE quality = ?"
        cursor.execute(select_query, (quality,))
        results = cursor.fetchall()
        if results:
            wine_data_list = []
            for result in results:
                wine_data = {
                    "fixed_acidity": result[0],
                    "volatile_acidity": result[1],
                    "citric_acid": result[2],
                    "residual_sugar": result[3],
                    "chlorides": result[4],
                    "free_sulfur_dioxide": result[5],
                    "density": result[6],
                    "pH": result[7],
                    "sulphates": result[8],
                    "alcohol": result[9],
                    "quality": result[10],
                    "type": result[11],
                    "best_quality": result[12]
                }
                wine_data_list.append(wine_data)
            return wine_data_list
        else:
            raise HTTPException(status_code=404, detail="No records found for the given quality")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        connection.close()


# API Get - Operazione che recupera i dati in base alla colonna 'type'
# REMAINDER:
# 'type': 0 --> vino rosso
# 'type': 1 --> vino bianco
# Gestione della connessione con il db
# Implementata la raise Exception --> ritorna messaggio di errore se non si trovano i dati in base al 'type'

@app.get("/get_wine_by_type/")
async def get_wine_by_type(type: int):
    connection = create_connection()
    if connection is None:
        return {"Error: An error occurred during the database connection."}
    cursor = connection.cursor()

    try:
        select_query = "SELECT * FROM wine WHERE type = ?"
        cursor.execute(select_query, (type,))
        results = cursor.fetchall()
        if results:
            wine_data_list = []
            for result in results:
                wine_data = {
                    "fixed_acidity": result[0],
                    "volatile_acidity": result[1],
                    "citric_acid": result[2],
                    "residual_sugar": result[3],
                    "chlorides": result[4],
                    "free_sulfur_dioxide": result[5],
                    "density": result[6],
                    "pH": result[7],
                    "sulphates": result[8],
                    "alcohol": result[9],
                    "quality": result[10],
                    "type": result[11],
                    "best_quality": result[12]
                }
                wine_data_list.append(wine_data)
            return wine_data_list
        else:
            raise HTTPException(status_code=404, detail="No records found for the given type")
    except Exception as e:
        raise HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        connection.close()


# API Post - Crea un nuovo record da inserire nel db
# Crea nuovo record inserendo tutti i parametri in JSON
@app.post("/create_wine/")
async def create_wine(wine: WineData):
    connection = create_connection()
    if connection is None:
        return {"Error: An error occurred during the database connection."}
    cursor = connection.cursor()
    query = """INSERT INTO wine (fixed_acidity, volatile_acidity, citric_acid, residual_sugar, chlorides,
               free_sulfur_dioxide, density, pH, sulphates, alcohol, quality, type, best_quality)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"""
    values = (wine.fixed_acidity, wine.volatile_acidity, wine.citric_acid, wine.residual_sugar, wine.chlorides,
              wine.free_sulfur_dioxide, wine.density, wine.pH, wine.sulphates, wine.alcohol, wine.quality, wine.type, wine.best_quality)

    try:
        cursor.execute(query, values)
        connection.commit()
        return {"message": "Wine successfully created"}
    except Error as e:
        return {"error": str(e)}
    finally:
        connection.close()


# API Put - Aggiorna un record esistente nel db
@app.put("/update_wine/")
async def update_wine(wine: WineData):
    connection = create_connection()
    if connection is None:
        return {"Error: An error occurred during the database connection."}
    cursor = connection.cursor()

    try:
        update_query = "UPDATE wine SET fixed_acidity=?, volatile_acidity=?, citric_acid=?, residual_sugar=?, chlorides=?, free_sulfur_dioxide=?, density=?, pH=?, sulphates=?, alcohol=?, quality=?, type=?, best_quality=? WHERE fixed_acidity=? AND volatile_acidity=? AND citric_acid=? AND residual_sugar=? AND chlorides=? AND free_sulfur_dioxide=? AND density=? AND pH=? AND sulphates=? AND alcohol=? AND quality=? AND type=? AND best_quality=?"
        cursor.execute(update_query, (wine.fixed_acidity, wine.volatile_acidity, wine.citric_acid, wine.residual_sugar, wine.chlorides, wine.free_sulfur_dioxide, wine.density, wine.pH, wine.sulphates, wine.alcohol, wine.quality, wine.type, wine.best_quality, wine.fixed_acidity, wine.volatile_acidity, wine.citric_acid, wine.residual_sugar, wine.chlorides, wine.free_sulfur_dioxide, wine.density, wine.pH, wine.sulphates, wine.alcohol, wine.quality, wine.type, wine.best_quality))
        connection.commit()
        return {"message": "Wine successfully updated"}
    except Exception as e:
        return HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        connection.close()


# API Delete - Cancella un record presente nel db
@app.delete("/delete_wine/")
async def delete_wine(wine: WineData):
    connection = create_connection()
    if connection is None:
        return {"Error: An error occurred during the database connection."}
    cursor = connection.cursor()

    try:
        delete_query = "DELETE FROM wine WHERE fixed_acidity=? AND volatile_acidity=? AND citric_acid=? AND residual_sugar=? AND chlorides=? AND free_sulfur_dioxide=? AND density=? AND pH=? AND sulphates=? AND alcohol=? AND quality=? AND type=? AND best_quality=?"
        cursor.execute(delete_query, (wine.fixed_acidity, wine.volatile_acidity, wine.citric_acid, wine.residual_sugar, wine.chlorides, wine.free_sulfur_dioxide, wine.density, wine.pH, wine.sulphates, wine.alcohol, wine.quality, wine.type, wine.best_quality))
        connection.commit()
        return {"message": "Wine successfully deleted"}
    except Exception as e:
        return HTTPException(status_code=500, detail="Internal Server Error")
    finally:
        connection.close()