const {
  update,
  add_image,
  up_vote,
  down_vote,
  remove,
  remove_bookmark,
  remove_vote,
} = require("./I.service");

const logger = require("../../../logger/logger");

module.exports = {
  update: (req, res) => {
    const body = req.body;
    update(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"PATCH node_api/update" - 200');
      return res.status(200).send(results);
    });
  },
  add_image: (req, res) => {
    const body = req.body;
    add_image(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"PATCH node_api/add_image" - 200');
      return res.status(200).send(results);
    });
  },
  up_vote: (req, res) => {
    const body = req.body;
    up_vote(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"PATCH node_api/up_vote" - 200');
      return res.status(200).send(results);
    });
  },
  down_vote: (req, res) => {
    const body = req.body;
    down_vote(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"PATCH node_api/down_vote" - 200');
      return res.status(200).send(results);
    });
  },
  remove: (req, res) => {
    const body = req.body;
    remove(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"PATCH node_api/remove" - 200');
      return res.status(200).send(results);
    });
  },
  remove_bookmark: (req, res) => {
    const body = req.body;
    remove_bookmark(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"DELETE node_api/remove_bookmark" - 200');
      return res.status(200).send(results);
    });
  },
  remove_vote: (req, res) => {
    const body = req.body;
    remove_vote(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.info('"DELETE node_api/remove_vote" - 200');
      return res.status(200).send(results);
    });
  },
};
