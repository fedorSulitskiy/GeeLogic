const {
  update,
  add_image,
  up_vote,
  down_vote,
  remove,
  remove_bookmark,
  remove_vote
} = require("./II.controller");

const router = require("express").Router();

router.patch("/update", update);
router.patch("/add_image", add_image);
router.patch("/up_vote", up_vote);
router.patch("/down_vote", down_vote);
router.delete("/remove", remove);
router.delete("/remove_bookmark", remove_bookmark);
router.delete("/remove_vote", remove_vote);

module.exports = router;
