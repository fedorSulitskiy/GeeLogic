const { create, add_tag, bookmark_algo, add_vote } = require("./II.controller");

const router = require("express").Router();

router.post("/create", create);
router.post("/add_tag", add_tag);
router.post("/bookmark_algo", bookmark_algo);
router.post("/add_vote", add_vote);

module.exports = router;
