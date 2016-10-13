fs = require('fs')
request = require('request')
#http = require('http');
https = require('https');
sutil = require('line-stream-util')

class ReadHeader
    constructor: (@url) ->

    read: (callback) ->
        if (@url.includes("https"))
            console.log("https")
            request(@url, (error, response, body) ->
                if (!error && response.statusCode == 200)
                    console.log(body);
            )

            https.get(@url).on('response', (response) ->
                body = ''
                i = 0
                response.on('data', (chunk) ->
                    i++
                    body += chunk
                    if (body.includes('\r'))
                        result = body.split('\r\n')[0].replace(/\s/g, "")
                    else
                        result = body.split('\n')[0].replace(/\s/g, "")
                    console.log('BODY Part: ' +result)
                    callback(null, result)
                )
                response.on('end', () ->
                    console.log(body)
                    console.log('Finished')
                )
            )
            return
        else if (@url.includes("file://"))
            names = @url.split('///')
            fs.createReadStream(names[1])
                .pipe(sutil.head(1)) # get head lines
                .pipe(sutil.split())
                .setEncoding('utf8')
                .on('data',
                    (data) ->
                        callback(null, data)
                        return
                )
                .on('error',(error) -> callback(error, null))

            return

module.exports = ReadHeader