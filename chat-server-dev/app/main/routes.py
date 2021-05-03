from flask import session, redirect, url_for, render_template, request
from . import main
from .forms import LoginForm


@main.route('/', methods=['GET', 'POST'])
def index():
    """Login form to enter a room."""
    form = LoginForm()
    if form.validate_on_submit():
        session['sender'] = form.sender.data
        session['friend'] = form.friend.data
        return redirect(url_for('.chat'))
    elif request.method == 'GET':
        form.sender.data = session.get('sender', '')
        form.friend.data = session.get('friend', '')
    return render_template('index.html', form=form)


@main.route('/chat')
def chat():
    """Chat room. The user's name and room must be stored in
    the session."""
    sender = session.get('sender', '')
    friend = session.get('friend', '')
    if sender == '' or friend == '':
        return redirect(url_for('.index'))
    return render_template('chat.html', sender=sender, friend=friend)
