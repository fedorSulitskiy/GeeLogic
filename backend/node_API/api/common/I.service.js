const pool = require('../../config/database');

module.exports = {
    create: (data, callBack) => {
        pool.query(
            `INSERT INTO algos(
                title,
                py_code,
                description,
                user_creator
            ) VALUES(?,?,?,?)`,
            [
                data.title,
                data.py_code,
                data.description,
                data.user_creator,
            ],
            (error, results, fields) => {
                if (error) {
                    return callBack(error);
                }
                return callBack(null, results);
            }
        );
    },
    show: callBack => {
        pool.query(
            `SELECT * FROM algos`,
            [],
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
                py_code = ?,
                description = ?,
                photo = ?
            WHERE algo_id = ?`,
            [
                data.title,
                data.py_code,
                data.description,
                data.photo,
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
            [
                data.photo,
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
    up_vote: (data, callBack) => {
        pool.query(
            `UPDATE algos
            SET up_votes = up_votes + 1
            WHERE algo_id = ?`,
            [
                data.algo_id
            ],
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
            [
                data.algo_id
            ],
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
            [
                data.algo_id
            ],
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
            [
                data.algo_id,
                data.tag_id
            ],
            (error, results, fields) => {
                if (error) {
                    return callBack(error);
                }
                return callBack(null, results);
            }
        );
    }
}