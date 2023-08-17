const { search, search_tags } = require("./I.service");

const logger = require("../../../logger/logger");

module.exports = {
  search: (req, res) => {
    const body = req.body;
    search(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      // logger.info('"POST node_api/search" - 200');
      return res.status(200).send(results);
    });
  },
  search_tags: (req, res) => {
    const body = req.body;
    search_tags(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      // logger.info('"POST node_api/search_tags" - 200');
      return res.status(200).send(results);
    });
  },
};
