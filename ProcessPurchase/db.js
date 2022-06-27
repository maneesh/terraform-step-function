const AWS = require('aws-sdk');

const ddb = new AWS.DynamoDB({version : '2012-08-10'});

const tableName = 'TransactionHistoryTable';

const writeToDb = async(data)=>{
    try{
        await ddb.putItem({
            "TableName":tableName,
            "Item": data
        }).promise();
    }catch(error){
        console.log("Error ", error);
        throw error;
    }
}

module.exports = {
    writeToDb
}
