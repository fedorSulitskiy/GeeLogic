/// Returns parsed Uri of node API with end point specified
/// TODO: implement for all apis once deployed
Uri nodeUri(String endpoint) {
  return Uri.parse('https://geelogic-node-api.onrender.com/node_api/$endpoint');
}