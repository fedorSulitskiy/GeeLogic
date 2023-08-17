const { search, search_tags } = require("./II.controller");

const router = require("express").Router();

router.post("/search", search);
router.post("/search_tags", search_tags);

module.exports = router;
