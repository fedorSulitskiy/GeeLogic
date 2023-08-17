const { add_tag } = require("./I.service");

const logger = require("../../logger/logger");

module.exports = {
  /**
   * Handle the request to add a new tag to the database.
   *
   * @param {Object} req - The Express request object.
   * @param {Object} res - The Express response object.
   * @returns {void}
   */
  add_tag: (req, res) => {
    const body = req.body;
    add_tag(body, (err, results) => {
      if (err) {
        logger.error(`"${err}" - 500`);
        return res.status(500).send("Database connection error");
      }
      logger.warn('"POST node_api/admin/add_tag" - 200');
      return res.status(200).send(results);
    });
  },
};
