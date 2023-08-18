/// Returns parsed Uri of node API with end point specified
/// TODO: implement for all apis once deployed
Uri nodeUri(String endpoint) {
  return Uri.parse('http://localhost:3000/node_api/$endpoint');
}