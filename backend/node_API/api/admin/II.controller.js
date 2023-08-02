const { 
    add_tag,
} = require('./I.service');
const logger = require('../../logger/logger');



module.exports = {
    add_tag: (req, res) => {
        const body = req.body;
        add_tag(body, (err, results) => {
            if (err) {
                logger.error(`"${err}" - 500`);
                return res.status(500).send('Database connection error');
            }
            logger.warn('"POST node_api/admin/add_tag" - 200');
            return res.status(200).send(results);
        });
    },
}