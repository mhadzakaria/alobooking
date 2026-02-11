# AloBooking

This is a booking management system.

## System Dependencies

* Ruby 3.4.4
* PostgreSQL

## Configuration

1.  Clone the repository.
2.  Install dependencies:
    ```bash
    bundle install
    ```
3.  Set up the database:
    Make sure PostgreSQL service is running.
    ```bash
    bin/rails db:create
    bin/rails db:migrate
    bin/rails db:seed
    ```

## Development

Run the server:
```bash
bin/rails server
```

## Endpoints

### UI
- `GET /booking`: The booking form and list of appointments.

### API
- `POST /api/v1/appointments`: Create a new appointment.
  - Body: `{ "appointment": { "doctor_id": ID, "patient_id": ID, "start_at": "ISO8601", "end_at": "ISO8601" } }`

## Tasks
### Task B – Data & Performance (Short Answer)
1. If the appointment data grows to millions of records, how would you handle:<br>
**ANSWER**:<br>
Indexing: I would add index on doctor_id and start_time, and possibly a composite index (doctor_id, start_time), or just to make sure does indexing already implemented on first time build the app.
Pagination: it should be already implemented on first time build the app. Another improve is set default filter like on first load we only show data 1 month ago or 1 year ago.
Query optimization: I planned to do this also
Caching: I planned to implement caching with on each row data(with dynamic key and set expiration), or implement on some part/section, and also apply caching carefully only on read-heavy endpoints, but not on booking creation
2. In your opinion, is MongoDB suitable for this use case? Why or why not?<br>
**ANSWER**:<br>
For now i'm not have production experince for mongo DB.
From what I know, MongoDB is NoSQL and more flexible with schema.
For appointment system that needs strong consistency and prevent overlapping booking, I think relational database feels safer.
MongoDB maybe can work, but I think we need more logic in application side.

### Task D – Reliability & Production Readiness
1. An error occurs only in production but cannot be reproduced locally. What are your steps?<br>
**ANSWER**:
- If we have implemented error tracking tools like Sentry, check the error message first.
- Or we can manually check logs first, for check which line got error.
- If we possible to see the production data, we can try to reproduce it on local by using same data as production.
- If error is expilicit from code, we can to fix it.
- If error is not expilicit from code, we can add handler for other case that not handled yet, catch the error and log it.
- Sometimes error caused because environtment configuration, so good try also if we try to run local app with production environment, so we can check the error.
- After fix it, we should deploy to staging first to make sure no more error, and then deploy to production.
2. How would you log and monitor appointment failures?<br>
**ANSWER**:<br>
I planned to send error to monitoring tools like Sentry, i send with clear details(like current user, current data id, etc) and puts error message to the log file to prevent incase Sentry or other tools is down.
3. If this API suddenly becomes slow, how would you investigate and mitigate the issue?<br>
**ANSWER**:<br>
Investigate:
- First, i will check the log file to identify which query or which part got slow.
- Checking monitoring tools, even i'm not using it yet, but i think it will be useful to see the current performance and which part got slow.
- Check server resource, if it's full or not like on memory or CPU
- I would also run EXPLAIN ANALYZE to check whether it uses index scan or sequential scan.
Mitigate:
- If query is slow, i planned to optimize by implement caching for frequently query, or improve the query.
- If server resource is full, i coordinate with DevOps to add more resource or we discuss for optimize it. Or if some part can is big and possible to move to the backgrond job i will do it.
In last step, i will checking for the root case what causing this and try to prevent it happen again.


### Task E – Security Awareness
1. How do you ensure a patient cannot book an appointment on behalf of another patient?<br>
**ANSWER**:<br>
- I planned to optimize the permitted params, to not include user_id as params that can be sent by user, so it will only use current user id.
- I planned to add make booking endpoint only can access by logged in user, so it will not possible to put another user_id from request.
2. How should secrets (API keys, database credentials) be handled?<br>
**ANSWER**:<br>
- I planned to use .env file to store secrets, and .env.example to show the example of secrets.
- I planned to add .env or secrets.yml to .gitignore to prevent secrets from being committed to the repository.
- In production I would use environment variables provided by deployment platform or secret manager.
3. Is rate limiting necessary for this endpoint? Explain your reasoning.<br>
**ANSWER**:<br>
In my opinion, yes, even for authenticated users, rate limiting is still necessary to prevent abuse and protect infrastructure. we can use per IP or per user_id to limit the request.

### Task F – AI‑Assisted Development
1. Do you use AI tools (e.g., GitHub Copilot, ChatGPT) in development?<br>
**ANSWER**:<br>
chatGPT, antigravity
2. Which parts of this task should not rely solely on AI‑generated code?<br>
**ANSWER**:<br>
I think all of the code should not rely solely on AI-generated code. Because AI-generated code can have bugs or security vulnerabilities, so it's important to review and test the code before using it.
But maybe on some part need more attention, like on:
- Busines rule, even we have saved/write the business rule one the prompt, we still need to clarify/review AI generated code, and make sure the busines rule still consistent.
- Architecture, some times AI generated code is overkill or not fit for the project, so we need to review and adjust it for scalability and readability.
