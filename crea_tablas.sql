create table POKEMON
(
    ID              NUMBER(4) generated as identity
        constraint PK_POKEMON
            primary key,
    NAME            VARCHAR2(60) not null,
    HP              NUMBER(3)    not null,
    ATK             NUMBER(3)    not null,
    DEF             NUMBER(3)    not null,
    SPATK           NUMBER(3)    not null,
    SPDEF           NUMBER(3)    not null,
    SPD             NUMBER(3)    not null,
    BST             NUMBER(4)    not null,
    NATIONAL_DEX_ID NUMBER(4)
)
/

create unique index IDX_POKEMON_NAME
    on POKEMON (NAME)
/

create table POKEMON_TYPE
(
    ID   NUMBER(2)    not null
        constraint PK_POKEMON_TYPE
            primary key,
    NAME VARCHAR2(15) not null
)
/

create unique index IDX_TYPE_NAME
    on POKEMON_TYPE (NAME)
/

create table NATURE
(
    ID   NUMBER(2)    not null
        constraint PK_NATURE
            primary key,
    NAME VARCHAR2(15) not null
)
/

create unique index IDX_NATURE_NAME
    on NATURE (NAME)
/

create table ABILITY
(
    ID          NUMBER(3) generated as identity
        constraint PK_ABILITY
            primary key,
    NAME        VARCHAR2(30)  not null,
    DESCRIPTION VARCHAR2(255) not null
)
/

create unique index IDX_ABILITY_NAME_DESCRIPTION
    on ABILITY (NAME, DESCRIPTION)
/

create table PKMN_ABILITY
(
    ID_POKEMON NUMBER(4) not null
        constraint FK_PKMN_ABILITY_POKEMON
            references POKEMON,
    ID_ABILITY NUMBER(3) not null
        constraint FK_PKMN_ABILITY_ABILITY
            references ABILITY,
    constraint PK_PKMN_ABILITY
        primary key (ID_POKEMON, ID_ABILITY)
)
/

create table ITEM
(
    ID          NUMBER(3) generated as identity
        constraint PK_ITEM
            primary key,
    NAME        VARCHAR2(50),
    DESCRIPTION VARCHAR2(255)
)
/

create unique index IDX_ITEMS_NAME_DESCRIPTION
    on ITEM (NAME, DESCRIPTION)
/

create table GENDER
(
    ID   NUMBER(2)    not null
        constraint PK_GENDER
            primary key,
    NAME VARCHAR2(10) not null
)
/

create table MOVE_CAT
(
    ID   NUMBER(1)    not null
        constraint PK_MOVE_CAT
            primary key,
    NAME VARCHAR2(10) not null
)
/

create table MOVE
(
    ID          NUMBER(4) generated as identity
        constraint PK_MOVE
            primary key,
    NAME        VARCHAR2(50) not null,
    ID_TYPE     NUMBER(2)    not null
        constraint FK_MOVE_TYPE
            references POKEMON_TYPE,
    ID_MOVE_CAT NUMBER(1)
        constraint FK_MOVE_CAT
            references MOVE_CAT,
    POWER       NUMBER(3),
    ACCURACY    NUMBER(3),
    PP          NUMBER(3),
    EFFECT      VARCHAR2(255),
    EFFECT_PROB NUMBER(3)
)
/

create unique index IDX_MOVE_NAME_DESCRIPTION
    on MOVE (NAME)
/

create table POKEMON_PASTE
(
    ID           NUMBER(4) generated as identity
        constraint PK_POKEMON_PASTE
            primary key,
    ID_POKEMON   NUMBER(4) not null
        constraint FK_POKEMON_PASTE_POKEMON
            references POKEMON,
    ID_ITEM      NUMBER(3)
        constraint FK_POKEMON_PASTE_ITEM
            references ITEM,
    NICKNAME     VARCHAR2(18),
    "level"      NUMBER(3) not null,
    ID_GENDER    NUMBER(2)
        constraint FK_POKEMON_PASTE_GENDER
            references GENDER,
    IS_SHINY     NUMBER(1),
    ID_TERA_TYPE NUMBER(2) not null
        constraint FK_POKEMON_PASTE_TERA
            references POKEMON_TYPE,
    ID_ABILITY   NUMBER(3) not null
        constraint FK_POKEMON_PASTE_ABILITY
            references ABILITY,
    MOVE1        NUMBER(3)
        constraint FK_POKEMON_PASTE_MOVE1
            references MOVE,
    MOVE2        NUMBER(3)
        constraint FK_POKEMON_PASTE_MOVE2
            references MOVE,
    MOVE3        NUMBER(3)
        constraint FK_POKEMON_PASTE_MOVE3
            references MOVE,
    MOVE4        NUMBER(3)
        constraint FK_POKEMON_PASTE_MOVE4
            references MOVE,
    HP_EV        NUMBER(3),
    ATK_EV       NUMBER(3),
    DEF_EV       NUMBER(3),
    SPATK_EV     NUMBER(3),
    SPDEF_EV     NUMBER(3),
    SPD_EV       NUMBER(3),
    HP_IV        NUMBER(3),
    ATK_IV       NUMBER(3),
    DEF_IV       NUMBER(3),
    SPATK_IV     NUMBER(3),
    SPDEF_IV     NUMBER(3),
    SPD_IV       NUMBER(3),
    HP           NUMBER(3),
    ATK          NUMBER(3),
    "def"        NUMBER(3),
    SPATK        NUMBER(3),
    SPDEF        NUMBER(3),
    SPD          NUMBER(3),
    ID_NATURE    NUMBER(2) not null
        constraint FK_POKEMON_PASTE_NATURE
            references NATURE
)
/

create table POKEMON_TYPE_COMBINATION
(
    ID_POKEMON NUMBER(4) not null
        constraint FK_POKEMON_TYPE_COMBINATION_POKEMON
            references POKEMON,
    ID_TYPE    NUMBER(2) not null
        constraint FK_POKEMON_TYPE_COMBINATION_TYPE
            references POKEMON_TYPE,
    constraint PK_POKEMON_TYPE_COMBINATION
        primary key (ID_POKEMON, ID_TYPE)
)
/

create table POKEMON_TYPINGS_CORRECTED
(
    POKEMON_ID NUMBER(4) not null,
    TYPE1      NUMBER,
    TYPE2      NUMBER
)
/

create view V_GET_PKMN as
SELECT "ID","NAME","HP","ATK","DEF","SPATK","SPDEF","SPD","BST","NATIONAL_DEX_ID" FROM syn_pkmn ORDER BY id
/

create view V_GET_ITEMS as
SELECT "ID","NAME","DESCRIPTION" FROM syn_itm
/

create view V_GET_ABILITIES as
SELECT "ID","NAME","DESCRIPTION" FROM syn_abi
/

create view V_GET_PKMN_TYPES as
SELECT "ID","NAME" FROM syn_type
/

create view V_GET_NATURES as
SELECT "ID","NAME" FROM syn_nat
/

create view V_GET_MOVES as
SELECT "ID","NAME","ID_TYPE","ID_MOVE_CAT","POWER","ACCURACY","PP","EFFECT","EFFECT_PROB" FROM syn_move
/

create view V_GET_POKEPASTE as
SELECT
    pp.id AS paste_id,
    pp.nickname,
    pp."level",
    CASE pp.is_shiny
        WHEN 0 THEN 'No'
        ELSE 'Yes'
    END AS is_shiny,
    p.name AS pokemon_name,
    t.name AS tera_type_name,
    a.name AS ability_name,
    i.name AS item_name,
    g.name AS gender_name,
    m1.name AS move1_name,
    m2.name AS move2_name,
    m3.name AS move3_name,
    m4.name AS move4_name,
    n.name AS nature_name,
    pp.hp,
    pp.atk,
    pp."def",
    pp.spatk,
    pp.spdef,
    pp.spd
FROM
    syn_pkmn_paste pp
    INNER JOIN syn_pkmn p ON pp.id_pokemon = p.id
    INNER JOIN syn_type t ON pp.id_tera_type = t.id
    INNER JOIN syn_abi a ON pp.id_ability = a.id
    LEFT JOIN syn_itm i ON pp.id_item = i.id
    INNER JOIN syn_gdr g ON pp.id_gender = g.id
    INNER JOIN syn_move m1 ON pp.move1 = m1.id
    LEFT JOIN syn_move m2 ON pp.move2 = m2.id
    LEFT JOIN syn_move m3 ON pp.move3 = m3.id
    LEFT JOIN syn_move m4 ON pp.move4 = m4.id
    INNER JOIN syn_nat n ON pp.id_nature = n.id
ORDER BY pp.id
/

create view V_GET_MOVE_TABLE as
SELECT
    m.id AS move_id,
    m.name AS move_name,
    INITCAP(mc.name) AS move_category,
    mt.name AS move_type,
    NVL(TO_CHAR(m.power), '—') AS power,
    NVL(TO_CHAR(m.accuracy), '—') AS accuracy,
    NVL(TO_CHAR(m.pp), '—') AS pp,
    m.effect,
    NVL(TO_CHAR(m.effect_prob), '—') AS effect_prob
FROM
    syn_move m
INNER JOIN
    syn_type mt ON m.id_type = mt.id
INNER JOIN
    syn_mvcat mc ON m.id_move_cat = mc.id
/

create view V_GET_POKEMON_TYPING as
SELECT UNIQUE
    p.id AS pokemon_name,
    CASE WHEN pt1.id < pt2.id THEN pt1.id ELSE pt2.id END AS type1,
    CASE WHEN pt1.id < pt2.id THEN pt2.id ELSE pt1.id END AS type2
FROM
    pokemon p
JOIN
    syn_pkmn_t ptc1 ON p.id = ptc1.id_pokemon
JOIN
    syn_type pt1 ON ptc1.id_type = pt1.id
LEFT JOIN
    syn_pkmn_t ptc2 ON p.id = ptc2.id_pokemon AND ptc1.id_type <> ptc2.id_type
LEFT JOIN
    syn_type pt2 ON ptc2.id_type = pt2.id
/

create view V_GET_PKMN_TYPING as
SELECT "POKEMON_ID","TYPE1","TYPE2" FROM pokemon_typings_corrected
/

create view V_GET_POKEMON_ABILITIES as
SELECT 
    id_POKEMON,
    LISTAGG(id_ABILITY, ',') WITHIN GROUP (ORDER BY id_ABILITY) AS Abilities
FROM 
    syn_pkmn_ab
GROUP BY 
    id_POKEMON
ORDER BY 
    id_POKEMON
/


