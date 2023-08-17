const pool = require("../../../config/database");

module.exports = {
  /**
   * Search for distinct algorithm titles and IDs matching a keyword or associated tag names.
   *
   * @param {Object} data - The data object containing the search keyword.
   * @param {string} data.keyword - The keyword to search for in algorithm titles or associated tag names.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {Array} callBack.results - An array containing distinct algorithm titles and IDs that match the search criteria.
   * @returns {void}
   */
  search: (data, callBack) => {
    pool.query(
      `SELECT DISTINCT algos.title, algos.algo_id
          FROM algos
          LEFT JOIN algo_tag ON algos.algo_id = algo_tag.algo_id
          LEFT JOIN tags ON algo_tag.tag_id = tags.tag_id
          WHERE algos.title LIKE ?
            OR tags.tag_name LIKE ?
          ORDER BY
            CASE
                WHEN algos.title LIKE ? THEN 0
                ELSE 1
            END,
            algos.title`,
      [`%${data.keyword}%`, `%${data.keyword}%`, `%${data.keyword}%`],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Search for tags matching a keyword.
   *
   * @param {Object} data - The data object containing the search keyword.
   * @param {string} data.keyword - The keyword to search for in tag names.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {Array} callBack.results - An array containing tags that match the search criteria.
   * @returns {void}
   */
  search_tags: (data, callBack) => {
    pool.query(
      `SELECT * FROM
            tags 
        WHERE 
            tag_name 
        LIKE ?`,
      [`%${data.keyword}%`],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
};
