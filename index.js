var http = require('http')
var client = require('redis').createClient(process.env.REDIS_ADDRESS);
console.log('connecting to redis: '+ process.env.REDIS_ADDRESS)

client.on('connect', function() {
    console.log('Redis client connected');
});

client.on('error', function (err) {
    console.log('Something went wrong ' + err);
    process.exit(1);
});


http.createServer(function (request, response) {
    response.writeHead(200, {'Content-Type': 'text/plain'});
    if (request.url == '/ping') {
        response.write('ok')
        response.end();
    } else {
        client.incr('requests', function (err, reply) {
            if (err) {
                console.log(error);
                throw error;
            }

            console.log("redis reply: " + reply);
            response.write('pageview counter: ' + reply);
            response.end();
        });
    }
}).listen(8888);


function resetCounter() {
    const now = new Date();
    console.log(now.getUTCHours()+':'+now.getUTCMinutes() + ':' +now.getUTCSeconds() +
                ' - reseting pageview counter');

    client.set('requests', 0 , function (err, reply) {
        if (err) {
            console.log(error);
            throw error;
        }
    });
}
setInterval(resetCounter, 60000);
