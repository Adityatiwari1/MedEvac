from wsgiref.simple_server import WSGIServer
from flask import Flask, request
import pandas as pd

app = Flask(__name__)

medicine_data = {}

df = pd.read_csv('drug.csv')

for _, row in df.iterrows():
    medicine = row['medicine']
    disease = row['disease']
    symptoms = row['disease_name'].split(';1')
    medicine_data[disease] = (medicine, symptoms)


@app.route('/', methods=['POST'])
def get_response():
    message = request.form['message']
    return process_message(message)


def process_message(message):
    if message.lower() == 'bye':
        return 'Goodbye!'
    elif message.lower() in ['hello', 'hi', 'hy', 'hiii']:
        return "Hello, how can I help you?"
    else:
        found_medicines = []
        for disease, (medicine, symptoms) in medicine_data.items():
            print("Disease: ",disease)
            if any(symptom.lower() in message.lower() for symptom in symptoms):
                found_medicines.append(medicine)

        if found_medicines:
            if len(found_medicines) == 1:
                return f"I recommend taking {found_medicines[0]} for your symptoms."
            else:
                return f"I recommend taking {', '.join(found_medicines)} for your symptoms."
        else:
            return "I'm sorry, I couldn't find any relevant medicine for your symptoms."

if __name__ == '__main__':
    http_server = WSGIServer(('', 5000), app)
    http_server.serve_forever()



