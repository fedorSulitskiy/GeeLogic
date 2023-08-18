const { create, add_tag, bookmark_algo, add_vote } = require("./I.service");
const logger = require("../../../logger/logger");

module.exports = {
  create: (req, res) => {
    const body = req.body;
    create(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/create" - 200');
      return res.status(200).send(results);
    });
  },
  add_tag: (req, res) => {
    const body = req.body;
    add_tag(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/add_tag" - 200');
      return res.status(200).send(results);
    });
  },
  bookmark_algo: (req, res) => {
    const body = req.body;
    bookmark_algo(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/bookmark_algo" - 200');
      return res.status(200).send(results);
    });
  },
  add_vote: (req, res) => {
    const body = req.body;
    add_vote(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/add_vote" - 200');
      return res.status(200).send(results);
    });
  },
};
