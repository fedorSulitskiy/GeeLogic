const pool = require("../../../config/database");

module.exports = {
  /**
   * Create a new algorithm entry in the database.
   *
   * @param {object} data - The data object containing algorithm information.
   * @param {string} data.title - The title of the algorithm.
   * @param {string} data.code - The code of the algorithm.
   * @param {string} data.description - The description of the algorithm.
   * @param {string} data.user_creator - The user who created the algorithm.
   * @param {string} data.api - The API associated with the algorithm, python or javaSript.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database insertion operation.
   * @returns {void}
   */
  create: (data, callBack) => {
    pool.query(
      `INSERT INTO algos(
          title,
          code,
          description,
          user_creator,
          api
      ) VALUES(?,?,?,?,?)`,
      [data.title, data.code, data.description, data.user_creator, data.api],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Add a tag to an algorithm entry in the database.
   *
   * @param {Object} data - The data object containing tag and algorithm IDs.
   * @param {number} data.algo_id - The ID of the algorithm.
   * @param {number} data.tag_id - The ID of the tag to be added.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database insertion operation.
   * @returns {void}
   */
  add_tag: (data, callBack) => {
    pool.query(
      `INSERT INTO algo_tag(
          algo_id,
          tag_id
      ) VALUES(?,?)`,
      [data.algo_id, data.tag_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Bookmark an algorithm for a user in the database.
   *
   * @param {Object} data - The data object containing user and algorithm IDs.
   * @param {string} data.user_id - The ID of the user.
   * @param {number} data.algo_id - The ID of the algorithm to be bookmarked.
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database insertion operation.
   * @returns {void}
   */
  bookmark_algo: (data, callBack) => {
    pool.query(
      `INSERT INTO bookmarked(
          user_id,
          algo_id
      ) VALUES(?,?)`,
      [data.user_id, data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
  /**
   * Add a vote (up or down) for a specific algorithm by a user.
   *
   * @param {Object} data - The data object containing algorithm, user, and vote information.
   * @param {number} data.algo_id - The ID of the algorithm for which to add the vote.
   * @param {string} data.user_id - The ID of the user who is adding the vote.
   * @param {number} data.vote - The vote value (-1 for downvote, 1 for upvote).
   * @param {function} callBack - The callback function to handle the result.
   * @param {Error|null} callBack.error - An error object if an error occurred during the database operation.
   * @param {any} callBack.results - The results of the database insertion operation.
   * @returns {void}
   */
  add_vote: (data, callBack) => {
    pool.query(
      `INSERT INTO votes(
          algo_id, 
          user_id, 
          vote
      ) VALUES(?,?,?)`,
      [data.algo_id, data.user_id, data.vote],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
};
