const db = require('./db');
const uuid = require('uuid');


const handler = async (event) => {
    console.log("Event process purchase received ", event)
    // TODO implement
    
    const data = {
        transactionType: event.TransactionType,
        timeStamp: new Date().getTime(),
        message: "This message is from Process purchase lambda function"
    }
    const dataToSave = {};
    Object.keys(data).forEach(key => {
        dataToSave[key] = {'S': `${data[key]}`}
    });
    dataToSave.TransactionID = {S: uuid.v4()};
      console.log("dataToSave", dataToSave);

    await db.writeToDb(dataToSave);
    
    return data;
};

exports.handler = handler;
