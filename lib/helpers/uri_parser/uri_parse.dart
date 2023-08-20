/// Returns parsed Uri of node API with end point specified
/// TODO: implement for all apis once deployed
Uri nodeUri(String endpoint) {
  const String deployed = "https://geelogic-node-api.onrender.com/node_api/";
  // const String local = "http://localhost:3000/node_api/";
  return Uri.parse('$deployed$endpoint');
}

/// Returns parsed Uri of python API with end point specified
Uri pythonUri(String endpoint) {
  // const String deployed = "https://geelogic-node-api.onrender.com/node_api/";
  const String local = "http://127.0.0.1:3001/python_api/";
  return Uri.parse('$local$endpoint');
}

/// Returns parsed Uri of thumbnail API with end point specified
Uri thumbnailUri(String endpoint) {
  // const String deployed = "https://geelogic-node-api.onrender.com/node_api/";
  const String local = "http://192.168.8.103:3002/thumbnail_api/";
  return Uri.parse('$local$endpoint');
}