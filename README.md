# social_network_system_design
System design of a social network for an educational course -
[System Design by Balun.Courses](https://balun.courses/courses/system_design)

---

Содержание:
- [REST API](#api) 
- [Databases](#db)
- [Functional and non-functional requirements](#req)
- [Calculations](#calc)
- [Top-level design](#design)

<a id="api"></a>
## REST API

---
Перечень операций API:
- добавление и удаление друзей;
- просмотр друзей пользователя;
- просмотр анкеты пользователя;
- публикация поста в ленту;
- загрузка медиа файлов для постов;
- просмотр ленты постов (*домашней и пользователей)*;
- просмотр диалогов и чатов пользователя;
- отправка и чтение сообщений в диалогах и чатах.

Визуализация REST API в соответствии с OpenAPI Specification(Swagger):

- [API представленное в виде yaml файла для Swagger](#api/rest_api.yml)

<a id="db"></a>
## Database
Используйте [dbdiagram](https://dbdiagram.io/home) для удобного изучения 
структур баз данных, либо [скриншоты](#architecture/) в директориях сервисов.

Replication, sharding and partitioning are as below, 
if the opposite is not specified.

Replication:
- replication factor 3
- master-slave (one sync + 2 async)
- leader election to choose a new master.

Sharding:
- **key based** by **user_id** to avoid multishard user requests

Partitioning:

- For storage cold data on HDD and hot data on SSD **messages** and **posts** partition by created_at

<a id="req"></a>
## Требования учтенные при проектировании:

---
##### Функциональные требования:
- личные сообщения и чаты (текст и медиа),
- прочитанность сообщений,
- публикация постов в ленту (текст и медиа),
- добавление друзей, 
- добавление отношений, 
- добавление подписок,
- добавление анкеты пользователя.

##### Нефункциональные требования:
- 50 000 000 DAU,
- Availability 99,95%,
- Cообщения всегда сохраняются,
- Response time на отправку - 1 секунда,
- Response time на получение - 5 секунд,
- Максимальный размер сообщения - 4096 символов,
- Максимальный размер медиа - 2 гб,
- В среднем пользователь:
  - Читает сообщения 10 раз в день,
  - Пишет сообщения 2 раз в день,
  - Скачивает медиа 1 раз в день,
  - Загружает медиа 1 раз в неделю,
  - Читает посты 10 раз в день,
  - Пишет пост 1 раз в неделю,
  - Средний размер медиа - 1 МБ,
- Данные должны храниться 5 лет,
- Геораспределенность на центральный и восточный регион России,
- Сезонности нет.

<a id="calc"></a>
## Calculation:

---
    DAU = 50 000 000
    Рассчетное время хранения данных = 5 лет
    Фактор репликации = 3

RPS и traffic работы с сообщениями (отправка/чтение):

    В среднем юзер читает сообщения 10 раз в день, пишет 2 раза в день
    RPS(read) = 50 000 000 * 10 / 86 400 ~= 5800 r/с
    RPD(write) = 50 000 000 * 2 / 86 400 ~= 1200 r/с

    traffic_per_second(write) = 1200 * 4096 * 2 Б = 10 МБ/с  
    traffic_per_year(write) =  10 * 86400 * 365 = 315 ТБ/год

    message_required_memory = 315 * 5 * 3 = 5 ПБ

RPS и traffic работы с медиа (отправка/чтение):

    В среднем юзер скачивает медиа 1 раз в день, загружает 1 раз в неделю
    RPS(read) = 50 000 000 * 1 / 86 400 ~= 580 r/s
    RPD(write) = 50 000 000 * 1 / 7 / 86 400 ~= 85 r/s

    traffic_per_second(write) = 85 * 1 МБ = 85 МБ/с  
    traffic_per_year(write) =  85 * 86400 * 365 = 3 ПБ/год

    media_required_memory = 3 * 5 * 3= 45 ПБ

RPS и traffic работы с постами (отправка/чтение):

    В среднем юзер читает посты 10 раз в день, пишет 1 раз в неделю
    RPS(read) = 50 000 000 * 10 / 86 400 ~= 5800 r/с
    RPD(write) = 50 000 000 * 1 / 7 / 86 400 ~= 85 r/с

    traffic_per_second(write) = 85 * 4096 * 2 Б = 1 МБ/с  
    traffic_per_year(write) =  1 * 86400 * 365 = 31 ТБ/год

    post_required_memory = 31 * 5 * 3= 500 ТБ

Итого суммарно необходимо памяти:

    required_memory = 5 ПБ + 45 ПБ + 500 ТБ = 50,5 ПБ

<a id="calc"></a>
## Top-level design:

---

### C1 level:
![c1_level.png](architecture%2Fpuml_containers%2Fimages%2Fc1_level.png)

---

### C2 level:
-  #### Post service
![post_service.png](architecture%2Fpuml_containers%2Fimages%2Fpost_service.png)

---

-  #### Feed service
![feed_service.png](architecture%2Fpuml_containers%2Fimages%2Ffeed_service.png)

---

-  #### Message service
![message_service.png](architecture%2Fpuml_containers%2Fimages%2Fmessage_service.png)

---

-  #### User service
![user_service.png](architecture%2Fpuml_containers%2Fimages%2Fuser_service.png)

---

-  #### Feedback service
![feedback_service.png](architecture%2Fpuml_containers%2Fimages%2Ffeedback_service.png)

---

-  #### Media service
![media_service.png](architecture%2Fpuml_containers%2Fimages%2Fmedia_service.png)
