const functions = require('firebase-functions')
const {
  createChatService,
  createExpenseService,
  updateTokenService,
  updateTransactionService
} = require('./helpers/onCallFunction')
const { updateGroupService } = require('./helpers/onUpdateFunction')
require('./auth')

exports.onChatUpdate = updateGroupService

exports.createExpense = functions.firestore
  .document('expenses/{expensesID}')
  .onCreate((snap, context) => {
    const newValue = snap.data()
    console.log('New value: ', newValue)
    return null
  })

exports.handleTransaction = functions.firestore
  .document('expenses/{expensesID}/transactions/{transactionID}')
  .onCreate((snap) => {
    const newValue = snap.data()
    console.log('New value: ', newValue)
    return null
  })

exports.createChat = createChatService

exports.sendExpense = createExpenseService

exports.updateTransaction = updateTransactionService

exports.updateToken = updateTokenService

exports.writeMessage = functions.https.onCall(async (data) => {
  //  Grab the text parameter.
  const original = data.text
  //  Returns the text received.
  return `Successfully received: ${original}`
})
