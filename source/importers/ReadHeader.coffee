fs = require('fs')
https = require('https');
sutil = require('line-stream-util')

class ReadHeader
    constructor: (@url) ->
        console.log("URL:"+@url)
        return

    removeWhitespace = (data) ->
        if (data.includes('\r\n'))
            data = data.split('\r\n')[0].replace(/\s/g, "")
        else if (data.includes('\r'))
            data = data.split('\r')[0].replace(/\s/g, "")
        else
            data = data.split('\n')[0].replace(/\s/g, "")
        return data
    read: (callback) ->
        if (@url.includes("https"))
            httpsCall = https.get(@url).on('response', (response) ->
                body = ''
                i = 0
                response.on('data', (chunk) ->
                    httpsCall.abort()
                    i++
                    body += chunk
                    result = removeWhitespace(body)
                    callback(null, result)
                )
                response.on('end', () ->
                )
            )
            return
        else if (@url.includes("file://"))

            names = @url.split('//')
            fs.createReadStream(names[1])
                .pipe(sutil.head(1)) # get head lines
                .pipe(sutil.split())
                .setEncoding('utf8')
                .on('data',
                    (data) ->
                        data = removeWhitespace(data)
                        callback(null, data)
                        return
                )
                .on('error',(error) -> callback(error, null))

            return
        else
            callback("Need url.", null)

module.exports = ReadHeader