100_000.times do |n|
  today = Date.today
  Ticket.create(
                 month:        (today.beginning_of_year..today.end_of_year).to_a.sample,
                 sla:          n.even? ? true : false,
                 restore_time: (1..100).to_a.sample,
                 start_time:   (1..10).to_a.sample
               )
end
