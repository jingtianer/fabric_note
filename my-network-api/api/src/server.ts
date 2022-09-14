import {Run, Get, Set} from './app'

import * as http from "http"
import * as url from "url"
import * as util from "util"
import querystring, { ParsedUrlQuery } from 'querystring'
http.createServer(function(req, res){
    var post:string = ''
    var qString:ParsedUrlQuery
    
    const urlArray = (req.url == undefined ? "" : req.url).split('?')
    const path = urlArray[0]
    const params = urlArray[1]
    var search = new URLSearchParams(params)
    
    req.on('data', function(chunk){    
        post += chunk
    })
    req.on('end', function(){    
        qString = querystring.parse(post)
        try {
            const response = onPostReceived(path, search, post)
            response.then((value=> {
                res.writeHead(200, {'Content-Type': 'text/plain'})
                res.write(value)
                res.end()
            }))
        } catch(e) {
            console.log(e)
            res.writeHead(404, {'Content-Type': 'text/plain'})
            res.end()
        }
    })
    
    // 解析 url 参数
 
}).listen(3000)

function onPostReceived(path:string, search:URLSearchParams, body:string):Promise<string> {
    if(path == "/invokeChaincode") {
        return invokeChaincode(search, body)
    }
    throw Error("No such Path")
}

function invokeChaincode(search:URLSearchParams, body:string):Promise<string> {
    console.log(body)
    const data = JSON.parse(body)
    if (data.function == "get") {
        return Get(data.peer, data.org, data.key)
    } else {
        return Set(data.peer, data.org, data.key, data.val)
    }
}