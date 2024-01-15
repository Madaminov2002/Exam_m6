
CREATE TABLE "user2"(
                       "id" bigserial NOT NULL,
                       "user_name" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "user2" ADD PRIMARY KEY("id");
CREATE TABLE "profiles"(
                           "id" bigserial NOT NULL,
                           "user_id" BIGINT NOT NULL,
                           "nick_name" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "profiles" ADD PRIMARY KEY("id");
CREATE TABLE "posts"(
                        "id" bigserial NOT NULL,
                        "title" VARCHAR(255) NOT NULL,
                        "like" BIGINT NOT NULL,
                        "comment" VARCHAR(255) NOT NULL,
                        "post_time" DATE NOT NULL,
                        "profil_id" BIGINT NOT NULL
);
ALTER TABLE
    "posts" ADD PRIMARY KEY("id");
ALTER TABLE
    "posts" ADD CONSTRAINT "posts_profil_id_foreign" FOREIGN KEY("profil_id") REFERENCES "profiles"("id");
ALTER TABLE
    "profiles" ADD CONSTRAINT "profiles_user_id_foreign" FOREIGN KEY("user_id") REFERENCES "user2"("id");


INSERT INTO user2(user_name)VALUES
                                ('Suhrob'),
                                ('Behruz'),
                                ('Laziz'),
                                ('Asror');
INSERT INTO profiles(user_id, nick_name) VALUES
                                             (1,'madam1novv.s'),
                                             (2,'behruz_12'),
                                             (3,'laziz_1'),
                                             (4,'khamzaev.07');
INSERT INTO posts(title, "like", comment, post_time, profil_id) VALUES
                                                                    ('Love',30,'Hello','2024-11-23',1),
                                                                    ('Stile',35,'Hii','2024-02-02',2),
                                                                    ('Heart',100,'Good','2024-12-21',3),
                                                                    ('Car',32,'Exelent','2024-11-13',4);

-- 1 FUNCTION
create or replace FUNCTION return_post_data(f_title varchar)
returns table(p_id bigint,p_title varchar,p_like bigint,p_comment varchar,p_post_time date,p_profil_id bigint)
language plpgsql
as
    $$
    begin
        return query select * from posts where posts.title LIKE f_title||'%';
    end
    $$;

-- 2 PROCEDURE
create or replace procedure delete_post_data(post2_id bigint)
language plpgsql
as
    $$
    begin
        delete from posts where posts.id=post2_id;
    end
    $$;

-- VIEW
create view return_post_count as select user2.id, user2.user_name, count(posts.id) from user2 inner join profiles on user2.id=profiles.user_id inner join posts
on profiles.id=posts.profil_id group by user2.id, user2.user_name;

-- MATERIALIZED VIEW
create materialized view return_last_year_data as select id,title,posts.like from posts where extract(year from posts.post_time) < extract(year from now());
