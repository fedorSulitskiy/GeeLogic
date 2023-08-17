const express = require("express");
const cors = require("cors");

const api_add = require("../api/common/add/III.router");
const api_modify = require("../api/common/modify/III.router");
const api_search = require("../api/common/search/III.router");
const api_show = require("../api/common/show/III.router");
const adm = require("../api/admin/III.router");

module.exports = function (app) {
  app.use(express.json());
  app.use(
    cors({
      origin: "*",
    })
  );
  app.use("/node_api/", api_add);
  app.use("/node_api/", api_modify);
  app.use("/node_api/", api_search);
  app.use("/node_api/", api_show);
  app.use("/node_api/admin/", adm);
};
