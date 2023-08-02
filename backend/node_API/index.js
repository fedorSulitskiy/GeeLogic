require('dotenv').config();
const express = require('express');
const app = express();

const logger = require('./logger/logger');

require('./startup/routes')(app);

const port = process.env.APP_PORT;
const server = app.listen(port, () => {
    logger.info(`Server up and running on port ${port}`);
});