# social_network_system_design
System design of a social network for an educational course -
[System Design by Balun.Courses](https://balun.courses/courses/system_design)

---

Contents:
- [REST API](#api) 
- [Databases](#db)
- [Functional and non-functional requirements](#req)
- [Calculations](#calc)
- [Top-level design](#design)

<a id="api"></a>
## REST API

---
List of API operations:
- adding and removing friends;
- view the user's friends;
- viewing the user profile;
- posting a post to the feed;
- uploading media files for posts;
- view the feed of posts (*home and users)*;
- view user's dialogs and chats;
- Sending and reading messages in dialogues and chats.

Visualization of the REST API in accordance with the Open API Specification(Swagger):
- [API presented as a yml file for Swagger](api/rest_api.yml)

Use [Swagger Online Editor](https://editor.swagger.io) for easy viewing API, 
or [screenshots](#api/) in api directories.

<a id="db"></a>
## Database
- [Services database structures](architecture/)

Use [dbdiagram](https://dbdiagram.io/home ) for easy viewing
of , or [screenshots](architecture/) in architecture directories.

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
## Requirements applied in the design:

---
##### Functional requirements:
- private messages and chats (text and media),
- readability of messages,
- publication of posts in the feed (text and media),
- adding friends,
- adding relationships,
- adding subscriptions,
- adding a user profile.

##### Non-functional requirements:
- 50,000,000 DAU,
- Availability 99.95%,
- Messages are always saved,
- The response time for sending is 1 second,
- The response time to turn on is 5 seconds,
- The maximum message size is 4096 characters,
- The maximum media size is 2 GB,
- The average user:
  - Reads messages 10 times a day,
  - Writes messages 2 times a day,
  - Downloads media 1 time per day,
  - Downloads media 1 time per week,
  - Reads posts 10 times a day,
  - Writes a post 1 time a week,
  - The average media size is 1 MB,
- The data must be stored for 5 years,
- Geo-distribution to the central and eastern regions of Russia,
- There is no seasonality.

<a id="calc"></a>
## Calculation:

---
    DAU = 50 000 000
    Data retention = 5 years
    Replication factor  = 3

RPS and traffic of working with messages (sending/reading):

    On average, a user reads messages 10 times a day, writes 2 times a day
    RPS(read) = 50 000 000 * 10 / 86 400 ~= 5800 r/s
    RPD(write) = 50 000 000 * 2 / 86 400 ~= 1200 r/s

    traffic_per_second(write) = 1200 * 4096 * 2 B = 10 MB/s  
    traffic_per_year(write) =  10 * 86400 * 365 = 315 TB/year

    message_required_memory = 315 * 5 * 3 = 5 PB

RPS and traffic of working with media (sending/reading):

    On average, a user downloads media 1 time a day, downloads 1 time a week
    RPS(read) = 50 000 000 * 1 / 86 400 ~= 580 r/s
    RPD(write) = 50 000 000 * 1 / 7 / 86 400 ~= 85 r/s

    traffic_per_second(write) = 85 * 1 MB = 85 MB/s  
    traffic_per_year(write) =  85 * 86400 * 365 = 3 PB/year

    media_required_memory = 3 * 5 * 3 = 45 PB

RPS and traffic of working with posts (sending/reading):

    On average, a user reads posts 10 times a day, writes 1 time a week
    RPS(read) = 50 000 000 * 10 / 86 400 ~= 5800 r/s
    RPD(write) = 50 000 000 * 1 / 7 / 86 400 ~= 85 r/s

    traffic_per_second(write) = 85 * 4096 * 2 B = 1 MB/s  
    traffic_per_year(write) =  1 * 86400 * 365 = 31 TB/year

    post_required_memory = 31 * 5 * 3= 500 TB

Total memory required:

    required_memory = 5 PB + 45 PB + 500 TB = 50,5 PB

<a id="design"></a>
## Top-level design:

---

Use [PlantUML Online Editor](http://www.plantuml.com/plantuml/uml/) for easy viewing
of , or [screenshots](architecture/puml_containers/images) in containers directories.

### C1 level:
- #### [All services](architecture/puml_containers)
![c1_level.png](architecture%2Fpuml_containers%2Fimages%2Fc1_level.png)

---

### C2 level:
-  #### [Post service](architecture/puml_containers)
![post_service.png](architecture%2Fpuml_containers%2Fimages%2Fpost_service.png)

---

-  #### [Feed service](architecture/puml_containers)
![feed_service.png](architecture%2Fpuml_containers%2Fimages%2Ffeed_service.png)

---

-  #### [Message service](architecture/puml_containers)
![message_service.png](architecture%2Fpuml_containers%2Fimages%2Fmessage_service.png)

---

-  #### [User service](architecture/puml_containers)
![user_service.png](architecture%2Fpuml_containers%2Fimages%2Fuser_service.png)

---

-  #### [Feedback service](architecture/puml_containers)
![feedback_service.png](architecture%2Fpuml_containers%2Fimages%2Ffeedback_service.png)

---

-  #### [Media service](architecture/puml_containers)
![media_service.png](architecture%2Fpuml_containers%2Fimages%2Fmedia_service.png)
