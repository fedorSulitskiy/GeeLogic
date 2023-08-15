const { 
    create,
    show,
    search,
    show_by_id,
    show_by_user,
    show_tags,
    update,
    add_image,
    up_vote,
    down_vote,
    remove, 
    add_tag,
    search_tags,
} = require('./II.controller');

const router = require('express').Router();

router.post("/create", create);
router.post("/show", show);
router.post("/search", search);
router.post("/show_by_id", show_by_id);
router.post("/show_by_user", show_by_user);
router.post("/show_tags", show_tags);
router.patch("/update", update);
router.patch("/add_image", add_image);
router.patch("/up_vote", up_vote);
router.patch("/down_vote", down_vote);
router.delete("/remove", remove);
router.post("/add_tag", add_tag);
router.post("/search_tags", search_tags);

module.exports = router;