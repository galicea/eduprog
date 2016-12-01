from flask import Flask
from flask import render_template, request, send_from_directory, jsonify
from pprint import pprint

app = Flask(__name__, template_folder='./')
app.config['DEBUG'] = True

@app.route('/<path:path>')
def send_static(path):
    return send_from_directory('./', path)


@app.route('/test_corgis', methods=["GET", "POST"])
@app.route('/test_corgis/', methods=["GET", "POST"])
def test_corgis():
    pprint(request.values)
    return jsonify({"success": False, "message": "Nie zaimplementowane!"})



@app.route('/save_code', methods=["GET", "POST"])
@app.route('/save_code/', methods=["GET", "POST"])
def save_code():
    pprint(request.values)
    return jsonify({"success": True, "message": "Na razie bez zapisu!"})




@app.route('/submit_grade', methods=["GET", "POST"])
@app.route('/submit_grade/', methods=["GET", "POST"])
def submit_grade():
    pprint(request.values)
    return jsonify({"success": False, "message": "Submit grade?!"})


    
@app.route('/save_events', methods=["GET", "POST"])
@app.route('/save_events/', methods=["GET", "POST"])
def save_events():
    pprint(request.values)
    return jsonify({"success": True, "message": "Zapisalem slad!"})


@app.route('/')
def index():
    return render_template('pyscript.html')

if __name__ == "__main__":
    app.run(port=8000)