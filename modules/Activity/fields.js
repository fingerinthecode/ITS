var fields = require('couchtypes/fields');
var utils  = require('lib/utils');
var assert = utils.assert;
var _      = require('underscore')._;

exports.activityField = function(){
  return new fields.Field({
    permissions: {
      update: function (newDoc, oldDoc, newValue, oldValue, userCtx) {
        var lastActivity = newValue.pop();

        // assert(newValue.length >= 0, "Activity must be saved on update");

        assert(oldValue && _.isEqual(newValue, oldValue), "Old activity has been modified");

        assert(newDoc.hasOwnProperty(lastActivity.element)
              && oldDoc.hasOwnProperty(lastActivity.element),
              "Change on a field that does not exist");

        assert(lastActivity.author == userCtx.name, "Change must be done by logged in user");

        assert(!isNaN(lastActivity.date), "3rd element must be a timestamp");

        assert(_.isEqual(lastActivity.content, oldDoc[lastActivity.element]),
            "Previous version is not correctly saved");
      },
    },
  })
}