USE pokemon;

SELECT *
FROM pokemon
LIMIT 10;

SELECT *
FROM trainer
LIMIT 10;

SELECT *
FROM trainer_pokemon
LIMIT 10;

SELECT id
FROM trainer
ORDER BY id DESC;

# 1. 트레이너가 보유한 포켓몬들은 얼마나 있는지 알 수 있는 쿼리를 작성해주세요.
SELECT
    p.kor_name AS pokemon_name,
    COUNT(tp.status) AS pokemon_cnt
FROM trainer_pokemon tp
LEFT JOIN pokemon.pokemon p on p.id = tp.pokemon_id
WHERE tp.status IN('Active', 'Training')
GROUP BY p.kor_name
ORDER BY pokemon_cnt DESC;

# 2. 각 트레이너가 가진 포켓몬 중에서 ‘Grass’ 타입의 포켓몬 수를 계{산해주세요. (단, 편의를 위해 type1 기준으로 계산해주세요.)
WITH TRAINER_NAME AS(
    SELECT
        tp.trainer_id,
        COUNT(p.type1) AS cnt
    FROM trainer_pokemon tp
    LEFT JOIN pokemon.pokemon p on p.id = tp.pokemon_id
    WHERE p.type1 LIKE 'Grass' AND tp.status IN('Active', 'Training')
    GROUP BY tp.trainer_id
    ORDER BY tp.trainer_id
)

SELECT
    t.name AS '트레이너 이름',
    TN.cnt AS '보유한 Grass 타입 포켓몬 수'
FROM trainer t
LEFT JOIN TRAINER_NAME TN on t.id = TN.trainer_id
WHERE TN.cnt IS NOT NULL;

# 3. 트레이너의 고향(hometown)과 포켓몬을 포획한 위치(location)를 비교하여,
# 자신의 고향에서 포켓몬을 포획한 트레이너의 수를 계산해주세요.
# *참고status 상관 없이 구해주세요.

SELECT
    COUNT(DISTINCT(t.id)) AS '트레이너 수'
FROM trainer_pokemon tp
LEFT JOIN trainer t on t.id = tp.trainer_id
WHERE t.hometown = tp.location;

# 4.  Master 등급인 트레이너들은 어떤 타입의 포켓몬을 제일 많이 보유하고 있을까요?
# *참고 ‘보유했다’의 정의는 1번 문제의 정의와 동일임

SELECT
    p.type1,
    COUNT(t.achievement_level) AS MASTER_trainer_cnt
FROM trainer_pokemon tp
LEFT JOIN pokemon.trainer t on t.id = tp.trainer_id
LEFT JOIN pokemon.pokemon p on p.id = tp.pokemon_id
WHERE tp.status IN('Active', 'Training') AND t.achievement_level LIKE 'Master'
GROUP BY p.type1
ORDER BY MASTER_trainer_cnt DESC
LIMIT 1;

# 5. Incheon 출신 트레이너들은 1세대, 2세대 포켓몬을 각각 얼마나 보유하고 있나요?
SELECT
    t.name AS name,
    SUM(p.generation = 1) AS '1세대',
    SUM(p.generation = 2) AS '2세대'
FROM trainer_pokemon tp
LEFT JOIN pokemon.pokemon p on p.id = tp.pokemon_id
LEFT JOIN pokemon.trainer t on t.id = tp.trainer_id
WHERE t.hometown LIKE 'Incheon' AND tp.status IN('Active', 'Training')
GROUP BY t.name;

# 6. 트레이너가 잡았던 포켓몬의 총 공격력(attack)과 방어력(defense)의 합을 계산하고, 이 합이 가장 높은 트레이너를 찾으세요.
WITH A_d AS(
    SELECT
        p.id,
        p.attack + p.defense AS total_ability
    FROM pokemon p
)

SELECT
    t.name,
    MAX(ad.total_ability) AS max_ability
FROM trainer_pokemon tp
LEFT JOIN A_d ad ON ad.id = tp.pokemon_id
LEFT JOIN pokemon.trainer t on t.id = tp.trainer_id
GROUP BY t.name
ORDER BY max_ability DESC
LIMIT 1;

# 7. 각 트레이너가 가진 포켓몬 중에서 공격력(attack)이 100 이상인 포켓몬과 100 미만인 포켓몬의 수를 각각 계산해주세요.
# 트레이너의 이름과 두 조건에 해당하는 포켓몬의 수를 출력해주세요.

WITH at_up_down AS(
    SELECT
        tp.trainer_id,
        COUNT(p.attack>=100) AS UP,
        COUNT(p.attack<100) AS DOWN
    FROM trainer_pokemon tp
    LEFT JOIN pokemon.pokemon p on p.id = tp.pokemon_id
    GROUP BY tp.trainer_id
)
SELECT
    t.name,
    a.UP AS "공격력이 100이상인 포켓몬 수",
    a.DOWN AS "공격력이  100 미만인 포켓몬 수"
FROM trainer t
LEFT JOIN at_up_down a ON a.trainer_id = t.id
ORDER BY a.UP DESC;
