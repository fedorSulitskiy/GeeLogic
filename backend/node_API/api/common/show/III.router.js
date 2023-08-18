const {
  show,
  show_by_id,
  show_by_user,
  show_tags,
  find_bookmark,
} = require("./II.controller");

const router = require("express").Router();

router.post("/show", show);
router.post("/show_by_id", show_by_id);
router.post("/show_by_user", show_by_user);
router.post("/show_tags", show_tags);
router.post("/find_bookmark", find_bookmark);

module.exports = router;
