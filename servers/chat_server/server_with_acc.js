var app = require('express')();
var server = require('http').Server(app);
var io = require('socket.io')(server);


server.listen(3000);

io
    .of('/')
    .on('connection', (socket) => {
        socket.on('send_message' , (data) => {
            console.log(data);
            socket.broadcast.emit('messages' , {
                senderId : data.senderId,
                message : data.message
            });
            socket.emit('confirm' , {
                messageId : data.messageId
            });
        });
    });
