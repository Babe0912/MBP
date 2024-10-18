/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("ko1ncujxk8rl4he")

  // remove
  collection.schema.removeField("k5nrpmr7")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "tskjg1on",
    "name": "Name",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("ko1ncujxk8rl4he")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "k5nrpmr7",
    "name": "avatar",
    "type": "file",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "mimeTypes": [
        "image/jpeg",
        "image/png",
        "image/webp",
        "image/svg+xml",
        "image/gif"
      ],
      "thumbs": [],
      "maxSelect": 1,
      "maxSize": 5242880,
      "protected": false
    }
  }))

  // remove
  collection.schema.removeField("tskjg1on")

  return dao.saveCollection(collection)
})
