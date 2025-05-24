from flask import Flask, jsonify, send_file
import random

app = Flask(__name__)

fortunes = [
    "You will have a great day!",
    "Something amazing is about to happen.",
    "The stars are aligning for success.",
    "Keep going, you're almost there.",
    "Good news is on the way!"
]

@app.route("/")
def index():
    return send_file("index.html")

@app.route("/api/fortune")
def get_fortune():
    return jsonify({"fortune": random.choice(fortunes)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
