const pool = require("../../config/database");

module.exports = {
  /**
   * Add a new tag to the database. Not included in the application, and only to be used manually.
   *
   * @param {object} data - The data object containing tag information.
   * @param {string} data.tag_name - The name of the tag to be added.
   * @param {string} data.tag_description - The description of the tag.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database insertion operation.
   * @returns {void}
   */
  add_tag: (data, callBack) => {
    pool.query(
      `INSERT INTO tags(
          tag_name,
          tag_description
      ) VALUES(?,?)`,
      [data.tag_name, data.tag_description],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
};
