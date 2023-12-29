Table users {
  id integer [primary key]
  name varchar
  description text
  photo integer
  city varchar
  interests text
  created_at timestamp
}

Table follows {
  id integer [primary key]
  following_id integer
  followed_id integer
  created_at timestamp
}
Table relationship {
  id integer [primary key]
  user_id integer
  related_user_id integer
  relationship_type integer
  created_at timestamp
}
Table friends {
  id integer [primary key]
  user_id integer
  friend_id integer
  created_at timestamp
}

Table chats {
  id integer [primary key]
  user_id integer
  name varchar
  created_at timestamp
}
Table chats_users {
  chat_id integer
  user_id integer
  created_at timestamp
}
Table messages {
  id integer [primary key]
  user_id integer
  chat_id integer
  text text
  is_read bool
}

Table posts {
  id integer [primary key]
  user_id integer
  description text
  media url [note: 'Link to content']
  likes integer
  views integer
  created_at timestamp
}
Table tags {
  id integer [primary key]
  name varchar
  created_at timestamp
}
Table posts_tags {
  post_id integer
  tag_id integer
  created_at timestamp
}
Table comments {
  id integer [primary key]
  user_id integer
  post_id integer
  name varchar
  text text
  created_at timestamp
}

Table likes {
  id integer [primary key]
  user_id integer
  post_id integer
  comment_id integer
}

table s3_media_store {
  id integer [primary key]
  data media
}

Ref: users.id < posts.user_id // one-to-many

Ref: posts.id < posts_tags.post_id
Ref: tags.id < posts_tags.tag_id
Ref: comments.user_id < users.id
Ref: comments.post_id < posts.id

Ref: users.id < chats.user_id
Ref: chats.id < chats_users.chat_id
Ref: users.id < chats_users.user_id
Ref: chats.id < messages.chat_id
Ref: users.id < messages.user_id

Ref: users.id < follows.following_id
Ref: users.id < follows.followed_id
Ref: users.id < relationship.user_id
Ref: users.id < relationship.related_user_id
Ref: users.id < friends.user_id
Ref: users.id < friends.friend_id

Ref: users.id < likes.user_id
Ref: posts.id < likes.post_id
Ref: comments.id < likes.id
