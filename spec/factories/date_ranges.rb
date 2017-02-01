# == Schema Information
#
# Table name: dateRange
#
# id              :integer
# startDate       :date
# endDate         :date
# event_id        :integer
#


FactoryGirl.define do
    factory :date_range  do
        start_date Date.tomorrow.next_day(1)
        end_date Date.tomorrow.next_day(10)

        trait :with_negative_range do
            start_date Date.current.next_day(10)
            end_date Date.current.next_day(9)
        end

        trait :with_past_dates do
            start_date Date.current.prev_day(3)
            end_date Date.yesterday
        end

        trait :on_single_day do
            start_date Date.tomorrow
            end_date Date.tomorrow
        end

        trait :in_the_past_valid do
            start_date Date.current.prev_day(3)
            end_date Date.yesterday
            to_create {|instance| instance.save(validate: false) }
        end
    end 
end
