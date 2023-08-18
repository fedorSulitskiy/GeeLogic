const {
  show,
  show_by_id,
  show_by_user,
  show_tags,
  find_bookmark,
  find_bookmarked_algos,
  find_vote,
} = require("./II.controller");

const router = require("express").Router();

router.post("/show", show);
router.post("/show_by_id", show_by_id);
router.post("/show_by_user", show_by_user);
router.post("/show_tags", show_tags);
router.post("/find_bookmark", find_bookmark);
router.post("/find_bookmarked_algos", find_bookmarked_algos);
router.post("/find_vote", find_vote);

module.exports = router;
