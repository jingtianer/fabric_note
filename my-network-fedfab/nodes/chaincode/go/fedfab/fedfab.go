/*
SPDX-License-Identifier: Apache-2.0
*/

package main

import (
	"encoding/json"
	"fmt"
	"strconv"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-protos-go/peer"
)

type SmartContract struct {
}

type Round struct {
	Models map[string]string // ClientID to Model
	RoundID string
	ClientNum int64
}

// type Model struct {
// 	ModelWeight string `json:weight` //直接填json，不变
// 	SampleNum int64 `json:sample-num`
// }

type SimpleAsset struct {
}

func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) peer.Response {
	args := stub.GetStringArgs()
	if len(args) != 2 {
		return shim.Error("Incorrect arguments. Expecting a key and a value")
	}
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return shim.Error(fmt.Sprintf("Failed to create asset: %s", args[0]))
	}
	return shim.Success(nil)
}

func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	// Extract the function and args from the transaction proposal
	fn, args := stub.GetFunctionAndParameters()

	var result string
	var err error
	if fn == "NewRound" {
		result, err = NewRound(stub, args)
	} else if fn == "AddModel" { // assume 'get' even if fn is nil
		result, err = AddModel(stub, args)
	} else if fn == "QueryAllReceived" {
		result, err = QueryAllReceived(stub, args)
	} else if fn == "UpdateGlobal" {
		result, err = UpdateGlobal(stub, args)
	} else if fn == "QueryWetherAllReceived" {
		result, err = QueryWetherAllReceived(stub, args)
	} else {
		err = fmt.Errorf("function not implemented %s", fn)
	}
	if err != nil {
		return shim.Error(err.Error())
	}

	// Return the result as success payload
	return shim.Success([]byte(result))
}

// 参数依次是 RoundID string
func QueryRound(stub shim.ChaincodeStubInterface, args []string) (*Round, error){
	if len(args) != 1 {
		return nil, fmt.Errorf("incorrect arguments. Expecting a key and a value")
	}
	value, err := stub.GetState(args[0])
	if err != nil {
		return nil, fmt.Errorf("failed to get Round: %s", args[0])
	}
	
	round := new(Round)

	err = json.Unmarshal(value, round)

	if err != nil {
		return nil, fmt.Errorf("failed to get Round: %s", args[0])
	}
	
	return round, nil
}

// 参数依次是 RoundID string, ClientID string, model string
func AddModel(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	if len(args) != 3 {
		return "", fmt.Errorf("incorrect arguments. Expecting a key and a value")
	}
	round, err := QueryRound(stub, []string{args[0]})

	if err != nil {
		return "", fmt.Errorf("failed to set asset: %s", args[0])
	}

	round.Models[args[1]] = args[2]

	roundAsBytes, _ := json.Marshal(*round)

	err = stub.PutState(args[0], roundAsBytes)
	if err != nil {
		return "", fmt.Errorf("failed to set asset: %s", args[0])
	}
	return args[0], nil
}

// 参数依次是 RoundID string
func QueryWetherAllReceived(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	ret := false
	if len(args) != 1 {
		ret_json, _ := json.Marshal(ret)
		return string(ret_json), fmt.Errorf("incorrect arguments. Expecting a key and a value")
	}
	round, err := QueryRound(stub, []string{args[0]})

	if err != nil {
		ret_json, _ := json.Marshal(ret)
		return string(ret_json), fmt.Errorf("failed to set asset: %s", args[0])
	}
	ret = (round.ClientNum == int64(len(round.Models)))
	ret_json, _ := json.Marshal(ret)

	return string(ret_json), nil
}

// 参数依次是 ServerID string, model-weight string (json)
func UpdateGlobal(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	if len(args) != 2 {
		return "", fmt.Errorf("incorrect arguments. Expecting a key and a value")
	}
	err := stub.PutState(args[0],[]byte(args[1]))
	if err != nil {
		return "", fmt.Errorf("failed to set asset: %s", args[0])
	}
	return args[0], nil
}

// 参数依次是 RoundID string, ClientNum int64
func NewRound(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	if len(args) != 2 {
		return "", fmt.Errorf("incorrect arguments. Expecting a key and a value")
	}
	ClientNum, err := strconv.ParseInt(args[1], 10, 64)
	if err != nil {
		return "", fmt.Errorf("failed to set asset: %s", args[0])
	}
	round := Round{
		RoundID: string(args[0]),
		ClientNum: ClientNum,
		Models: map[string]string{},
	}
	roundAsBytes, _ := json.Marshal(round)

	err = stub.PutState(args[0], roundAsBytes)
	if err != nil {
		return "", fmt.Errorf("failed to set asset: %s", args[0])
	}
	return args[0], nil
}

// 参数依次是 RoundID string
func QueryAllReceived(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	if len(args) != 1 {
		return "", fmt.Errorf("incorrect arguments. Expecting a key")
	}

	round, err := QueryRound(stub, []string{args[0]})

	if err != nil {
		return "", fmt.Errorf("failed to get asset: %s with error: %s", args[0], err)
	}

	value, err := json.Marshal(round.Models)

	if err != nil {
		return "", fmt.Errorf("failed to get asset: %s with error: %s", args[0], err)
	}

	return string(value), nil
}

// main function starts up the chaincode in the container during instantiate
func main() {
	if err := shim.Start(new(SimpleAsset)); err != nil {
		fmt.Printf("error starting SimpleAsset chaincode: %s", err)
	}
}
