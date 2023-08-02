const pool = require('../../config/database');

module.exports = {
    add_tag: (data, callBack) => {
        pool.query(
            `INSERT INTO tags(
                tag_name,
                tag_description
            ) VALUES(?,?)`,
            [
                data.tag_name,
                data.tag_description,
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