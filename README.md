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
    ```

## Development

Run the server:
```bash
bin/rails server
```
