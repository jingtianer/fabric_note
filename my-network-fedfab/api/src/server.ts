import {Run, AddModel, QueryWetherAllReceived, QueryAllReceived, UpdateGlobal, NewRound} from './app'
import * as fs from 'fs-extra'
import * as http from "http"
function server(req:http.IncomingMessage, res:http.ServerResponse) {
    var post:string = ''
    const urlArray = (req.url == undefined ? "" : req.url).split('?')
    const path = urlArray[0]
    const params = urlArray[1]
    var search = new URLSearchParams(params)
    
    req.on('data', function(chunk){    
        post += chunk
    })
    req.on('end', function(){    
        //add lock
        try {
            const response = onPostReceived(path, search, post)
            response.then((value=> {
                res.writeHead(200, {'Content-Type': 'text/html'})
                res.write(JSON.stringify(value))
                res.end()
            }))
        } catch(e) {
            console.log(e)
            res.writeHead(404, {'Content-Type': 'text/plain'})
            res.end()
        }
        //Release lock
    })
}
http.createServer(function(req, res){
    server(req, res)
}).listen(3000)

http.createServer(function(req, res){
    server(req, res)
}).listen(3001)

http.createServer(function(req, res){
    server(req, res)
}).listen(3002)

http.createServer(function(req, res){
    server(req, res)
}).listen(3003)

function onPostReceived(path:string, search:URLSearchParams, body:string):Promise<string> {
    console.log("executing ${"+path+"}");
    if(path == "/invokeChaincode/AddModel") {
        return addModel(search, body)
    } else if(path == "/invokeChaincode/QueryWetherAllReceived") {
        return queryWetherAllReceived(search, body)
    } else if(path == "/invokeChaincode/QueryAllReceived") {
        return queryAllReceived(search, body)
    } else if(path == "/invokeChaincode/UpdateGlobal") {
        return updateGlobal(search, body)
    } else if(path == "/invokeChaincode/NewRound") {
        return newRound(search, body)
    }
    throw Error("No such Path")
}

// params : peer, org
// body : json
// {rid:"", cid:"", model:""}
function BasePath(rid:string):string {
    return "./data/"+ rid + "/"
}
function addModel(search:URLSearchParams, body:string):Promise<string> {
    const data = JSON.parse(body)
    const peer = search.get('peer')
    const org = search.get('org')
    console.log("received params: peer=${"+peer+"}, org=${"+org+"}")
    console.log("received body: rid=${"+data.rid+"}cid=${"+data.cid+"}")
    const fileName = BasePath(data.rid) + data.cid+".dat"
    fs.ensureFileSync(fileName)
    fs.writeFileSync(fileName, data.model)
    return AddModel(peer!!, org!!, data.rid, data.cid, fileName)
}

// params : peer, org
// body : json
// {rid:""}
function queryWetherAllReceived(search:URLSearchParams, body:string):Promise<string> {
    const data = JSON.parse(body)
    const peer = search.get('peer')
    const org = search.get('org')
    console.log("received params: peer=${"+peer+"}, org=${"+org+"}")
    console.log("received body: ${"+body+"}")
    return QueryWetherAllReceived(peer!!, org!!, data.rid)
}

// params : peer, org
// body : json
// {rid:""}
async function queryAllReceived(search:URLSearchParams, body:string):Promise<string> {
    const data = JSON.parse(body)
    const peer = search.get('peer')
    const org = search.get('org')

    console.log("received params: peer=${"+peer+"}, org=${"+org+"}")
    console.log("received body: ${"+body+"}")

    const files_json = await QueryAllReceived(peer!!, org!!, data.rid)
    let files =  Object.entries<string>(JSON.parse(files_json))
    let ret = Object.create(null)
    for(const i in files) {
        let file = files[i][1]
        let content = fs.readFileSync(file, 'utf-8')
        ret[files[i][0]] =  content
    }
    return JSON.stringify(ret)
}

// params : peer, org
// body : json
// {sid:"", model:""}
function updateGlobal(search:URLSearchParams, body:string):Promise<string> {
    const data = JSON.parse(body)
    const peer = search.get('peer')
    const org = search.get('org')
    console.log("received params: peer=${"+peer+"}, org=${"+org+"}")
    console.log("received body: ${"+data.sid+"}")
    return UpdateGlobal(peer!!, org!!, data.sid, data.model)
}

// params : peer, org
// body : json
// {rid:"", client_num:""}
function newRound(search:URLSearchParams, body:string):Promise<string> {
    const data = JSON.parse(body)
    const peer = search.get('peer')
    const org = search.get('org')
    console.log("received params: peer=${"+peer+"}, org=${"+org+"}")
    console.log("received body: ${"+body+"}")
    return NewRound(peer!!, org!!, data.rid, data.client_num)
}