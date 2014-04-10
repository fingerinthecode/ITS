exports.comment_create = function(doc, req) {
  var form = JSON.parse(req.body);
  if(doc === null) {
    form._id        = 'comment:'+form.parent_id+'-'+req.userCtx.name+'-'+req.uuid.substr(req.uuid.length -4);
    form.type       = 'comment';
    form.author     = req.userCtx.name;
    form.created_at = new Date().getTime();
    return [form, 'ok'];
  }
  throw({forbidden: 'Doc must not be null'});
}
