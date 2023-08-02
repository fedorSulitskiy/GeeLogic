const { 
    add_tag
} = require('./II.controller');

const router = require('express').Router();

router.post("/add_tag", add_tag);

module.exports = router;