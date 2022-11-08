const admin = require('firebase-admin')
admin.initializeApp()

const db = admin.firestore()
const rtdb = admin.database()
const messaging = admin.messaging()

module.exports = {
  db,
  rtdb,
  messaging,
  admin
}
