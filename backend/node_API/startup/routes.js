const express = require('express');

const api = require('../api/common/III.router');
const adm = require('../api/admin/III.router');

module.exports = function(app) {
    app.use(express.json());
    app.use("/node_api/", api);
    app.use("/node_api/admin/", adm);
}