##########################################
#         컬렉션 공통 Methods
##########################################
Meteor.methods
  insertDoc : (collectionName, doc)->
    collection = Mongo.Collection.get collectionName
    Meteor.Notice.hook(collection, 'insert')
    return collection.insert doc

  removeDoc : (collectionName, docId)->
    collection = Mongo.Collection.get collectionName
    Meteor.Notice.hook(collection, 'remove')
    return collection.remove docId

  updateDoc : (collectionName, id, doc)->
    collection = Mongo.Collection.get collectionName
    Meteor.Notice.hook(collection, 'update')
    return collection.update id, {$set : doc}

  arrayMethod : (collectionName, type, docId, selectDoc, selectValue)->
    collection = Mongo.Collection.get collectionName
    obj = {}
    obj[selectDoc] = selectValue
    if (type is "push") and (collection.find({$and: [{_id:docId}, obj] }).count() is 0)
      return collection.update {_id:docId},{$push :obj}
    else if (type is "pull") and (collection.find({$and: [{_id:docId}, obj] }).count() is 1)
      return collection.update {_id:docId},{$pull :obj}
    else
      return false


