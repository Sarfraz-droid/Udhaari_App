const functions = require('firebase-functions')
const { messaging, rtdb } = require('../auth')

const createChatService = functions.https.onCall(async (data) => {
  console.log('createChatService', data)
  const tokens = []

  for (let i = 0; i < data.members.length; i++) {
    const token = await rtdb.ref(`users/${data.members[i]}/token`).get()

    if (token.exists()) {
      tokens.push(token.val())
    }
  }

  console.log('tokens', tokens)

  if (tokens.length > 0) {
    messaging.sendMulticast({
      tokens,
      data: {
        type: 'create_chat',
        chat: JSON.stringify(data.chat),
        settings: JSON.stringify(data.settings)
      }
    })
  }
})

const createExpenseService = functions.https.onCall(async (data) => {
  const message = data.message
  const chat = data.chat
  const expense = data.expense
  const members = data.members
  const notification = data.notification

  const tokens = []

  for (let i = 0; i < members.length; i++) {
    const token = await rtdb.ref(`users/${members[i]}/token`).get()
    if (token.exists()) {
      tokens.push(token.val())
    }
  }

  console.log(expense)
  console.log(message)

  if (tokens.length > 0) {
    messaging.sendMulticast({
      tokens,
      data: {
        type: 'create_expense',
        message: JSON.stringify(message),
        chat: JSON.stringify(chat),
        expense: JSON.stringify(expense)
      },
      notification
    })
  }
  console.log('tokens', tokens)
})

const updateTransactionService = functions.https.onCall(async (data) => {
  const chat = data.chat
  const transaction = data.transaction
  const members = data.members
  const notification = data.notification

  const tokens = []

  for (let i = 0; i < members.length; i++) {
    const token = await rtdb.ref(`users/${members[i]}/token`).get()
    if (token.exists()) {
      tokens.push(token.val())
    }
  }

  if (tokens.length > 0) {
    messaging.sendMulticast({
      tokens,
      data: {
        type: 'update_transaction',
        chat: JSON.stringify(chat),
        transaction: JSON.stringify(transaction)
      },
      notification
    })
  }

  console.log('tokens', tokens)
})

const updateTokenService = functions.https.onCall(async (data) => {
  const uid = data.uid
  const token = data.token

  await rtdb.ref(`users/${uid}/token`).set(token)
})

module.exports = {
  createChatService,
  createExpenseService,
  updateTokenService,
  updateTransactionService
}
