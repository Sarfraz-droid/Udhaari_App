const functions = require('firebase-functions')
const { rtdb, messaging } = require('../auth')

const updateGroupService = functions.firestore
  .document('chats/{chatID}')
  .onUpdate(async (change, context) => {
    console.log('updateGroupService', change)
    const updated = change.after.data()

    const tokens = []

    for (let i = 0; i < updated.members.length; i++) {
      const token = await rtdb.ref(`users/${updated.members[i]}/token`).get()

      if (token.exists()) {
        tokens.push(token.val())
      }
    }

    console.log('tokens', tokens)

    if (tokens.length > 0) {
      messaging.sendMulticast({
        tokens,
        data: {
          type: 'update_group',
          chat: JSON.stringify(updated),
          settings: JSON.stringify(updated.settings)
        }
      })
    }
  })

module.exports = {
  updateGroupService
}
