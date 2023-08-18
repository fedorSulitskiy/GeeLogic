const pool = require("../../../config/database");

module.exports = {
  /**
   * Update an existing algorithm's details in the database.
   *
   * @param {Object} data - The data object containing updated algorithm information.
   * @param {number} data.algo_id - The ID of the algorithm to update.
   * @param {string} data.title - The updated title of the algorithm.
   * @param {string} data.code - The updated code of the algorithm.
   * @param {string} data.description - The updated description of the algorithm.
   * @param {string} data.photo - The updated photo of the algorithm.
   * @param {string} data.api - The updated API associated with the algorithm.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database update operation.
   * @returns {void}
   */
  update: (data, callBack) => {
    pool.query(
      `UPDATE algos SET
          title = ?,
          code = ?,
          description = ?,
          photo = ?,
          api = ?
      WHERE algo_id = ?`,
      [
        data.title,
        data.code,
        data.description,
        data.photo,
        data.api,
        data.algo_id,
      ],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Add or update the photo of an algorithm in the database.
   *
   * @param {Object} data - The data object containing the algorithm's ID and photo.
   * @param {number} data.algo_id - The ID of the algorithm.
   * @param {string} data.photo - The photo to associate with the algorithm.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database update operation.
   * @returns {void}
   */
  add_image: (data, callBack) => {
    pool.query(
      `UPDATE algos SET
          photo = ?
      WHERE algo_id = ?`,
      [data.photo, data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Increment the up-vote count for an algorithm in the database.
   *
   * @param {Object} data - The data object containing the algorithm's ID.
   * @param {number} data.algo_id - The ID of the algorithm to up-vote.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database update operation.
   * @returns {void}
   */
  up_vote: (data, callBack) => {
    pool.query(
      `UPDATE algos
          SET up_votes = up_votes + 1
      WHERE algo_id = ?`,
      [data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Increment the down-vote count for an algorithm in the database.
   *
   * @param {Object} data - The data object containing the algorithm's ID.
   * @param {number} data.algo_id - The ID of the algorithm to down-vote.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database update operation.
   * @returns {void}
   */
  down_vote: (data, callBack) => {
    pool.query(
      `UPDATE algos
          SET down_votes = down_votes + 1
      WHERE algo_id = ?`,
      [data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Remove an algorithm from the database.
   *
   * @param {Object} data - The data object containing the algorithm's ID.
   * @param {number} data.algo_id - The ID of the algorithm to remove.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database deletion operation.
   * @returns {void}
   */
  remove: (data, callBack) => {
    pool.query(
      `DELETE FROM algos 
      WHERE algo_id = ?`,
      [data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Remove a bookmark for a specific user and algorithm.
   *
   * @param {Object} data - The data object containing user and algorithm IDs.
   * @param {number} data.algo_id - The ID of the algorithm to remove the bookmark from.
   * @param {number} data.user_id - The ID of the user who bookmarked the algorithm.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database deletion operation.
   * @returns {void}
   */
  remove_bookmark: (data, callBack) => {
    pool.query(
      `DELETE FROM bookmarked
      WHERE algo_id = ? AND user_id = ?`,
      [data.algo_id, data.user_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
};
