ng.factory('Demand', (CouchDB, db)->
  return CouchDB(db.url, db.name, 'demand')
)