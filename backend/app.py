import os
from flask_restful import Resource, Api
from flask import Flask, request, jsonify

# Internal Imports
from database import *

app = Flask(__name__)
app.config['DEBUG'] = True
app.config['UPLOAD_FOLDER'] = 'UPLOADS'

if not os.path.isdir('UPLOADS'):
    os.mkdir('UPLOADS')

api = Api(app)
app.logger.setLevel(10)

# create_table()


def write_file(data, filename):
    path = os.path.join('UPLOADS', filename)
    if not os.path.isfile(path):
        with open(os.path.join('UPLOADS', filename), 'wb') as f:
            f.write(data)


@api.resource("/upload")
class UploadData(Resource):
    def post(self):
        uname = request.args.get('uname')
        fname = request.args.get('fname')
        data = request.get_data()
        write_file(data, filename=fname)
        insert_value(uname, fname)
        return jsonify(
            {'states': 200}
        )


@api.resource('/fetch')
class FetchOne(Resource):
    def get(self):
        username = request.args.get('uname')
        return_data = fetch_data(username)
        return jsonify(return_data)


@api.resource("/all")
class FetchAllData(Resource):
    def get(self):
        allData = showAll()
        return jsonify(allData)


if __name__ == '__main__':
    app.run(port=80, host='0.0.0.0')
