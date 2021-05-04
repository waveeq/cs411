from flask import session
from flask_socketio import emit, join_room, leave_room
from .. import socketio


@socketio.on('joined', namespace='/chat')
def joined(message):
    """Sent by clients when they enter a room.
    A status message is broadcast to all people in the room."""
    sender = int(message['sender'])
    friend = int(message['friend'])

    if sender < friend:
        room = str(sender) + 'x' + str(friend)
    else:
        room = str(friend) + 'x' + str(sender)
    
    print("===== someone joining with userID = ", sender, ", to room = ", room)

    join_room(room)

    emit('status', {'msg': str(sender)+ ' has entered the room.'}, room=room)


@socketio.on('text', namespace='/chat')
def text(message):
    """Sent by a client when the user entered a new message.
    The message is sent to all people in the room."""
    sender = int(message['sender'])
    friend = int(message['friend'])

    if sender < friend:
        room = str(sender) + 'x' + str(friend)
    else:
        room = str(friend) + 'x' + str(sender)

    emit('message', message, room=room)


@socketio.on('left', namespace='/chat')
def left(message):
    """Sent by clients when they leave a room.
    A status message is broadcast to all people in the room."""
    sender = int(message['sender'])
    friend = int(message['friend'])

    if sender < friend:
        room = str(sender) + 'x' + str(friend)
    else:
        room = str(friend) + 'x' + str(sender)
        
    leave_room(room)

    emit('status', {'msg': str(sender) + ' has left the room.'}, room=room)

