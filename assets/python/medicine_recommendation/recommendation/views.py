# import pandas as pd
# import numpy as np
# from sklearn.model_selection import train_test_split
# from sklearn.preprocessing import LabelEncoder, OneHotEncoder
# from keras.models import Sequential
# from keras.layers import Dense, Dropout
# from sklearn.preprocessing import StandardScaler
# from keras import optimizers
# from keras.losses import Huber
# from django.http import HttpResponse

# # Read the CSV file
# data = pd.read_csv('drugs_for_common_treatments.csv')

# # Extract the relevant columns
# X = data[['drug_name', 'medical_condition', 'medical_condition_description']].copy()
# y = data['rating'].copy()

# # Convert categorical variables into numerical representation using one-hot encoding
# X_encoded = pd.get_dummies(X)

# # Split the dataset into training and testing sets
# X_train, X_test, y_train, y_test = train_test_split(X_encoded, y, test_size=0.2, random_state=42)

# # Scale the input features
# scaler = StandardScaler()
# X_train_scaled = scaler.fit_transform(X_train)
# X_test_scaled = scaler.transform(X_test)

# # Create a neural network model
# model = Sequential()
# model.add(Dense(256, activation='LeakyReLU', input_shape=(X_train_scaled.shape[1],)))
# model.add(Dense(128, activation='LeakyReLU'))
# model.add(Dense(64, activation='LeakyReLU'))
# model.add(Dense(32, activation='LeakyReLU'))
# model.add(Dense(16, activation='LeakyReLU'))
# model.add(Dense(8, activation='LeakyReLU'))
# model.add(Dense(1))

# optimizer = optimizers.Adam(learning_rate=0.001)

# # Compile the model
# model.compile(loss=Huber(), optimizer=optimizer, metrics=['accuracy'])

# # Train the model
# history = model.fit(X_train_scaled, y_train, epochs=100, batch_size=32, verbose=1)


# def load_model():
#     # Load the trained model
#     model = load_model('model.h5')  # Replace 'path_to_save_model' with the actual path to your saved model file
#     return model

# def preprocess_data(input_data):
#     # Preprocess the input data to match the format used for training
#     # Perform one-hot encoding and scaling as done during training
#     input_encoded = pd.get_dummies(input_data)
#     input_scaled = scaler.transform(input_encoded)
#     return input_scaled

# def recommendation_view(request):
#     # Get the input data from the user
#     user_input = request.GET.get('user_input')  # Modify this line to get the user input from the request

#     # Preprocess the input data
#     input_data = pd.DataFrame(data=[user_input], columns=['drug_name', 'medical_condition', 'medical_condition_description'])
#     input_scaled = preprocess_data(input_data)

#     # Load the trained model
#     model = load_model('model.h5')

#     # Make predictions on the input data
#     predictions = model.predict(input_scaled)

#     # Perform any post-processing or filtering based on the predictions

#     # Return the recommended medicine(s) to the user
#     return HttpResponse("Recommended medicine: Septra")  # Replace "XYZ" with the actual recommended medicine


# import pandas as pd
# from sklearn.preprocessing import StandardScaler
# from keras.models import load_model
# from django.http import HttpResponse
# from django.middleware.csrf import get_token

# # Read the CSV file
# data = pd.read_csv('drugs_for_common_treatments.csv')

# # Extract the relevant columns
# X = data[['drug_name', 'medical_condition', 'medical_condition_description']].copy()
# y = data['rating'].copy()

# # Convert categorical variables into numerical representation using one-hot encoding
# X_encoded = pd.get_dummies(X)

# # Scale the input features
# scaler = StandardScaler()
# X_scaled = scaler.fit_transform(X_encoded)

# # Create a neural network model
# model = load_model('model.h5')

# def preprocess_data(input_data):
#     # Preprocess the input data to match the format used for training
#     # Perform one-hot encoding and scaling as done during training
#     input_encoded = pd.get_dummies(input_data)
#     input_scaled = scaler.transform(input_encoded)
#     return input_scaled

# def recommendation_view(request):
#     # Get the input data from the user
#     disease = request.GET.get('disease')

#     # Find the medicine with the highest rating for the given disease
#     filtered_data = data[data['medical_condition'] == disease]
#     if len(filtered_data) == 0:
#         return HttpResponse("No medicine found for the given disease.")
    
#     highest_rating_index = filtered_data['rating'].idxmax()
#     recommended_medicine = filtered_data.loc[highest_rating_index, 'drug_name']

#     return HttpResponse(f"Recommended medicine: {recommended_medicine}")


# def get_csrf_token(request):
#     csrf_token = get_token(request)
#     response = HttpResponse()
#     response.set_cookie(key='csrftoken', value=csrf_token)
#     return response

import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import Pipeline
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt

data = pd.read_csv('drugs.csv')

@csrf_exempt
def predict_drug(medical_condition):
    medical_condition = medical_condition.lower()

    # Check if the medical_condition is a greeting
    greetings = ['hii', 'hello', 'hy', 'yo']
    if medical_condition in greetings:
        return "Hello! How can I help you?"

    # Check if the medical_condition is a farewell
    farewells = ['bye']
    if medical_condition in farewells:
        return "Thank you for using our service. Goodbye!"

    # If the medical_condition is not a greeting or farewell, perform drug prediction
    filtered_data = data[data['medical_condition'].str.lower() == medical_condition]

    if len(filtered_data) > 0:
        highest_rating = filtered_data['rating'].max()
        top_drug = filtered_data[filtered_data['rating'] == highest_rating]['drug_name'].values[0]
        return top_drug
    else:
        return "No drug found for the given medical condition."


X = data['medical_condition'].str.lower()
y = data['drug_name']

pipeline = Pipeline([
    ('vectorizer', CountVectorizer()),
    ('classifier', LogisticRegression())
])

pipeline.fit(X, y)


@csrf_exempt
def predict_drug_view(request):
    if request.method == 'POST':
        medical_condition = request.POST.get('medical_condition', '')

        predicted_drug = predict_drug(medical_condition)

        response = {predicted_drug}

        return HttpResponse(response)

    return HttpResponse({'error': 'Invalid request method'})


