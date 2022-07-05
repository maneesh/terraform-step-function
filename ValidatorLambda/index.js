console.log('Loading function');
const aws = require('aws-sdk');

exports.handler = (event, context, callback) => {
    const stepfunctions = new aws.StepFunctions();

    for (const record of event.Records) {
        const messageBody = JSON.parse(record.body);
        console.log("Message Body ", messageBody);
        const taskToken = messageBody.TaskToken;
        const error = new Error("Invalid Input");
        const isValid = ['REFUND','PURCHASE'].includes(messageBody.TransactionType);
        const params = {
            output: JSON.stringify({ TransactionType: messageBody.TransactionType, isValid}),
            taskToken: taskToken
        };

        console.log(`Calling Step Functions to complete callback task with params ${JSON.stringify(params)}`);

        stepfunctions.sendTaskSuccess(params, (err, data) => {
            if (err) {
                console.error(err.message);
                callback(err.message);
                return;
            }
            console.log(data);
            callback(null);
        });
    }
};