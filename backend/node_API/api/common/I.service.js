const pool = require("../../config/database");

module.exports = {
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
  remove: (data, callBack) => {
    pool.query(
      `DELETE FROM algos WHERE algo_id = ?`,
      [data.algo_id],
      (error, results, fields) => {
        if (error) {
          return callBack(error);
        }
        return callBack(null, results);
      }
    );
  },
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
