Initially, I wanted to help [this StackOverflow question](http://stackoverflow.com/q/42591051/1577357). Ended up, I explored the SQL `COALESCE` function.

The result for `COALESCE` is really fast (look at the query time in `ms`):

```
001 > Ticket.count
   (20.1ms)  SELECT COUNT(*) FROM "tickets"
=> 100000

002 > Ticket.new.first_solution
  Ticket Load (84.6ms)  SELECT date_trunc('month', month) as m, sum(restore_time) as restore_time, sum(start_time) as start_time FROM "tickets" WHERE (restore_time IS NOT NULL and start_time IS NOT NULL) AND "tickets"."sla" = $1 GROUP BY m ORDER BY m  [["sla", true]]
=> 2250862

003 > Ticket.new.second_solution
   (35.9ms)  SELECT SUM(coalesce(restore_time - start_time, 0)) FROM "tickets" WHERE "tickets"."sla" = $1  [["sla", true]]
=> 2250862

004 > Ticket.new.third_solution
  Ticket Load (242.5ms)  SELECT "tickets".* FROM "tickets" WHERE "tickets"."sla" = $1 AND ("tickets"."restore_time" IS NOT NULL) AND ("tickets"."start_time" IS NOT NULL)  [["sla", true]]
=> 2250862
 ```

 If you want to test this, run `rake db:drop db:create db:migrate db:seed` in your local machine after you clone and `bundle install`.

 It will take a while to load that 100,000 tickets data.

 Look at the code [here](app/models/ticket.rb).