const {
  show,
  show_by_id,
  show_by_user,
  show_tags,
  find_bookmark,
  find_bookmarked_algos,
  find_vote,
} = require("./I.service");
const logger = require("../../../logger/logger");

module.exports = {
  show: (req, res) => {
    const body = req.body;
    show(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/show" - 200');
      return res.status(200).send(results);
    });
  },
  show_by_id: (req, res) => {
    const body = req.body;
    show_by_id(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/show_by_id" - 200');
      return res.status(200).send(results);
    });
  },
  show_by_user: (req, res) => {
    const body = req.body;
    show_by_user(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/show_by_user" - 200');
      return res.status(200).send(results);
    });
  },
  show_tags: (req, res) => {
    const body = req.body;
    show_tags(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/show_tags" - 200');
      return res.status(200).send(results);
    });
  },
  find_bookmark: (req, res) => {
    const body = req.body;
    find_bookmark(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/find_bookmark" - 200');
      return res.status(200).send(results);
    });
  },
  find_bookmarked_algos: (req, res) => {
    const body = req.body;
    find_bookmarked_algos(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/find_bookmarked_algos" - 200');
      return res.status(200).send(results);
    });
  },
  find_vote: (req, res) => {
    const body = req.body;
    find_vote(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"POST node_api/find_votes" - 200');
      return res.status(200).send(results);
    });
  },
};
