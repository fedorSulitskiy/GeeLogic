const pool = require("../../../config/database");

module.exports = {
  /**
   * Retrieve a limited set of algorithms based on specified conditions.
   *
   * @param {Object} data - The data object containing filtering and pagination information.
   * @param {string} data.apiCondition - API condition, e.g., '0' for JavaScript, '1' for Python.
   * @param {string} data.orderCondition - Order condition for sorting results.
   * @param {number} data.offset - Offset value for pagination.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {Object} callBack.results - The limited results and total count.
   * @param {Array} callBack.results.results - An array of limited algorithm results.
   * @param {number} callBack.results.totalCount - The total count of algorithms matching the conditions.
   * @returns {void}
   */
  show: (data, callBack) => {
    let totalCount, limitedResults;
    // Potential order conditions:
    //  => date_created
    //  => up_votes
    //  => down_votes
    //  => up_votes - down_votes
    // All need ASC or DESC specified

    // Potential api conditions:
    //  => '0'    - javascript
    //  => '1'    - python
    //  => '0, 1' - javascript and python
    pool.query(
      `SELECT * FROM algos
          WHERE api IN (${data.apiCondition})
          ORDER BY ${data.orderCondition} 
          LIMIT 5
          OFFSET ?`,
      [data.offset],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }

        limitedResults = results;

        // Second query to get total count
        pool.query(
          `SELECT COUNT(*) AS total FROM algos 
              WHERE api IN (${data.apiCondition})`,
          (countError, countResult, countFields) => {
            if (countError) {
              return callBack(countError);
            }

            totalCount = countResult[0].total;

            // After gathering all data, send the response
            callBack(null, {
              results: limitedResults,
              totalCount: totalCount,
            });
          }
        );
      }
    );
  },
  /**
   * Retrieve an algorithm by its ID.
   *
   * @param {Object} data - The data object containing the algorithm's ID.
   * @param {number} data.algo_id - The ID of the algorithm to retrieve.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {Array} callBack.results - An array containing the algorithm details.
   * @returns {void}
   */
  show_by_id: (data, callBack) => {
    pool.query(
      `SELECT * FROM algos
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
   * Retrieve algorithms created by a specific user.
   *
   * @param {Object} data - The data object containing the user's ID.
   * @param {string} data.user_creator - The ID of the user who created the algorithms.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {Array} callBack.results - An array containing the algorithms created by the user.
   * @returns {void}
   */
  show_by_user: (data, callBack) => {
    pool.query(
      `SELECT * FROM algos 
          WHERE user_creator = ?`,
      [data.user_creator],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Retrieve tags associated with a specific algorithm.
   *
   * @param {Object} data - The data object containing the algorithm's ID.
   * @param {number} data.algo_id - The ID of the algorithm for which to retrieve tags.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {Array} callBack.results - An array containing the tags associated with the algorithm.
   * @returns {void}
   */
  show_tags: (data, callBack) => {
    pool.query(
      `SELECT t.*
          FROM tags t
          INNER JOIN algo_tag at ON t.tag_id = at.tag_id
          WHERE at.algo_id = ?`,
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
   * Check if a bookmark exists for a specific user and algorithm.
   *
   * @param {Object} data - The data object containing user and algorithm IDs.
   * @param {string} data.user_id - The ID of the user.
   * @param {number} data.algo_id - The ID of the algorithm to check for a bookmark.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {boolean} callBack.results - `true` if a bookmark exists for the user and algorithm, `false` otherwise.
   * @returns {void}
   */
  find_bookmark: (data, callBack) => {
    pool.query(
      `SELECT * FROM bookmarked
          WHERE user_id = ? AND algo_id = ?`,
      [data.user_id, data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        if (results.length === 0) {
          return callBack(null, false);
        }
        return callBack(null, true);
      }
    );
  },
  /**
   * Retrieve a list of algorithms bookmarked by a specific user.
   *
   * @param {Object} data - The data object containing user ID.
   * @param {string} data.user_id - The ID of the user for whom to retrieve bookmarked algorithms.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {Array} callBack.results - An array containing the algorithms bookmarked by the user.
   * @returns {void}
   */
  find_bookmarked_algos: (data, callBack) => {
    pool.query(
      `SELECT a.*
          FROM algos a
          JOIN bookmarked b ON a.algo_id = b.algo_id
      WHERE b.user_id = ?
      `,
      [data.user_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Check if any votes (up or down) exist for a specific user and algorithm.
   *
   * @param {Object} data - The data object containing user and algorithm IDs.
   * @param {string} data.user_id - The ID of the user for whom to check for existing votes.
   * @param {number} data.algo_id - The ID of the algorithm for which to check for existing votes.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database query operation.
   * @returns {void}
   */
  find_vote: (data, callBack) => {
    pool.query(
      `SELECT * FROM votes WHERE user_id = ? AND algo_id = ?`,
      [data.user_id, data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results[0]);
      }
    );
  },
};
