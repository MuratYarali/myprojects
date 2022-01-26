# Import Flask modules
from flask import Flask, render_template

# Create an object named app 
app = Flask(__name__)

# Create a function named head which shows the massage as "This is my first conditions experience" in `index.html` 
# and assign to the route of ('/')
@app.route("/")
def head():
   first = "This is my first conditions experience"
   return render_template("index.html")

@app.route("/list")
def header():
    names =['Apple', "Google", "Samsung","Honda", "Amazon", "IBM", "Microsoft", "Tesla"]
    return render_template("body.html", object = names)

# run this app in debug mode on your local.
if __name__== "__main__":
    app.run(debug=True)