Table celebrity_posts {
  id string
  user_id string [note: 'if follower counts more than 10000']
  posts_id list
  created_at datetime
}
