const { 
    create,
    show,
    update,
    add_image,
    up_vote,
    down_vote,
    remove, 
    add_tag,
} = require('./II.controller');

const router = require('express').Router();

router.post("/create", create);
router.get("/show", show);
router.patch("/update", update);
router.patch("/add_image", add_image);
router.patch("/up_vote", up_vote);
router.patch("/down_vote", down_vote);
router.delete("/remove", remove);
router.post("/add_tag", add_tag);

module.exports = router;