USE pokemon;
# 1.포켓몬 중 type2가 없는 포켓몬의 수를 작성하는 쿼리를 작성해주세요
# (힌트) 가 없다 : 컬럼 is null
SELECT
    COUNT(pokemon.id)
FROM
    pokemon
WHERE
    type2 IS NULL;

# 2.type2가 없는 포켓몬의 type1과 type1의 포켓몬 수를 알려주는 쿼리를 작성해주세요.
# 단,type1의 포켓몬 수가 큰 순으로 정렬해주세요

SELECT
    type1,
    COUNT(pokemon.id) AS cnt
FROM
    pokemon
WHERE type2 IS NULL
GROUP BY
    type1
ORDER BY
    cnt DESC;

# 3.type2 상관없이 type1의 포켓몬 수를 알 수 있는 쿼리를 작성해주세요
SELECT
    type1,
    COUNT(pokemon.id) AS cnt
FROM
    pokemon
GROUP BY
    type1
ORDER BY
    cnt DESC

# 4.전설 여부에 따른 포켓몬 수를 알 수 있는 쿼리를 작성해주세요
SELECT
    is_legendary,
    COUNT(pokemon.id)
FROM
    pokemon
GROUP BY
    is_legendary

# 5.동명이인이 있는 이름은 무엇일까요?
SELECT
    name,
    COUNT(id) AS cnt
FROM
    trainer
GROUP BY
    name
HAVING
    cnt >=2;

# 6.테이블에서 트레이너의 정보를 알 수 있는 쿼리를 작성해주세요
SELECT
    *
FROM
    trainer;

# 7.trainer 테이블에서 iris, whitney, cynthia 트레이너의 정보를 알 수 있는 쿼리를 작성해주세요
SELECT
    *
FROM
    trainer
WHERE
    name IN('iris','whitney','cynthia');

# 8.전체 포켓몬 수는 얼마나 되나요?
SELECT
    COUNT(id)
FROM
    pokemon;

# 9.세대(generation)별로 포켓몬 수가 얼마나 되는지 알 수 있는 쿼리를 작성해주세요
SELECT
    generation,
    COUNT(id)
FROM
    pokemon
GROUP BY
    generation;

# 10.type2가 존재하는 포켓몬의 수는 얼마나 되나요?
SELECT
    COUNT(id) AS TYPE2_EXISTENCE_POKEMON_COUNT
FROM
    pokemon
WHERE
    type2 IS NOT NULL;

# 11.type2가 있는 포켓몬 중에 제일 많은 type1은 무엇인가요?
SELECT
    type1,
    COUNT(id) AS TYPE_1_MANY_ORDER
FROM
    pokemon
WHERE
    type2 IS NOT NULL
GROUP BY
    type1
ORDER BY
    TYPE_1_MANY_ORDER DESC
LIMIT 1;

# 12.단일(하나의타입만있는)타입 포켓몬 중 많은 type1은 무엇일까요?
SELECT
    type1,
    COUNT(id) AS TYPE_1_MANY_ORDER
FROM
    pokemon
WHERE
    type2 IS NULL
GROUP BY
    type1
ORDER BY
    TYPE_1_MANY_ORDER DESC
LIMIT 1;

# 13.포켓몬의 이름에 “파"가 들어가는 포켓몬은 어떤 포켓몬이 있을까요?
SELECT
    kor_name AS "포켓몬이름"
FROM
    pokemon
WHERE
    kor_name LIKE ('%파%');

# 14.뱃지가 6개 이상인 트레이너는 몇 명이 있나요?
SELECT
    COUNT(id) AS "뱃지를6개이상가진트레이너수"
FROM
    trainer
WHERE badge_count >= 6;

# 15.트레이너가 보유한 포켓몬(trainer_pokemon)이 제일 많은 트레이너는 누구일까요?
SELECT
    trainer_id,
    name,
    COUNT(pokemon_id) AS "보유한 포켓몬의 수"
FROM
    trainer_pokemon
JOIN
        trainer ON trainer.id = trainer_pokemon.trainer_id
GROUP BY
    trainer_id, name
ORDER BY
    COUNT(pokemon_id)  DESC;

# 16.포켓몬을 많이 풀어준 트레이너는 누구일까요?
SELECT
    trainer_id,
    name,
    COUNT(status) AS "풀어준 포멧몬 수"
from
    trainer_pokemon
JOIN trainer ON trainer.id = trainer_pokemon.trainer_id
WHERE
    status = 'Released'
GROUP BY
    trainer_id, name
ORDER BY
    COUNT(status) DESC;

# 17.트레이너 별로 풀어준 포켓몬의 비율이 20%가 넘는 포켓몬 트레이너는 누구일까요?
# 풀어준 포켓몬의 비율 = (풀어준포켓몬수/전체포켓몬의수)
# (힌트) COUNTIF(조건
SELECT
    trainer_id,
    name,
    (COUNT(case WHEN status = 'Released' THEN 1 ELSE NULL END)/COUNT(pokemon_id)) AS sta
from
    trainer_pokemon
JOIN trainer ON trainer.id = trainer_pokemon.trainer_id
GROUP BY
    trainer_id, name
HAVING
    sta > 0.2
ORDER BY
    sta DESC;

# 17-1
SELECT
    trainer_id,
    name,
    (SUM(status='Released')/COUNT(pokemon_id)) AS sta
from
    trainer_pokemon
JOIN trainer ON trainer.id = trainer_pokemon.trainer_id
GROUP BY
    trainer_id, name
HAVING
    sta > 0.2
ORDER BY
    sta DESC;

# 17-2
    SELECT
    trainer_id,
    name,
    (
        (SELECT COUNT(pokemon_id)
         FROM trainer_pokemon
         WHERE status = 'Released')
        /
        COUNT(pokemon_id)
    ) AS sta
    FROM
        trainer_pokemon
    JOIN
        trainer ON trainer.id = trainer_pokemon.trainer_id
    GROUP BY
        trainer_id, name
    HAVING
        sta > 0.2
    ORDER BY
        sta DESC;


# 17-3
SELECT
    trainer_id,
    name,
    (
        (SELECT COUNT(pokemon_id)
         FROM trainer_pokemon AS t_sub
         WHERE t_sub.trainer_id = t.trainer_id
           AND status = 'Released')
        /
        COUNT(pokemon_id)
    ) AS sta
FROM
    trainer_pokemon t
JOIN
    trainer ON trainer.id = t.trainer_id
GROUP BY
    trainer_id, name
HAVING
    sta > 0.2
ORDER BY
    sta DESC;

