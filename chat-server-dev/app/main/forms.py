from flask_wtf import Form
from wtforms.fields import IntegerField, SubmitField
from wtforms.validators import Required


class LoginForm(Form):
    """Accepts a nickname and a room."""
    sender = IntegerField('Sender UserID', validators=[Required()])
    friend = IntegerField('Friend UserID', validators=[Required()])
    submit = SubmitField('Enter Chatroom')
