from flask import Flask, request, current_app
import json
import socket

# get hostname
hostname = socket.gethostname()
app = Flask(__name__)

# entrypoint hello
@app.route("/hello/<username>")
def hello(username):
    # create output message
    message_template = "Hello {username} from {hostname}"
    message = message_template.format(username = username.title(), hostname = hostname)
    data = json.dumps({'mesage': message}, indent=2, sort_keys=True)
    # print data for logs
    print( data )
    # return pretty json
    return current_app.response_class(data, mimetype="application/json")

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True, threaded=True)