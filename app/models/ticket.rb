class Ticket < ApplicationRecord
    
    scope :by_month, -> {
        select("date_trunc('month', month) as m,                      \
                sum(restore_time)          as restore_time,           \
                sum(start_time)            as start_time")            \
        .where("restore_time IS NOT NULL and start_time IS NOT NULL") \
        .group("m").order("m")
    }

    def time_difference
        restore_time - start_time
    end

    def first_solution  # my solution
        self.class.by_month.where(sla: true).sum(&:time_difference)
    end

    def second_solution # not mine
      self.class.all.where(sla: true) \
        .sum('coalesce(restore_time - start_time, 0)')
    end

    def third_solution  # my solution
        self.class.all.where(sla:  true) \
          .where.not(restore_time: nil)  \
          .where.not(start_time:   nil)  \
          .sum(&:time_difference)
    end
    
end
