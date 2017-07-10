require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase

  setup do
     login_as(users(:user), :scope => :user)
  end

  test "Show upcoming events" do
    event = events(:first)

    Timecop.freeze(event.start - 1.day) do
      visit events_url
      within('nav', match: :first) do
        assert_selector :link, text: event.name, href: event_path(event), class: 'dropdown-item'
      end
    end
  end

  test "Show None when there is no upcoming event" do
    Timecop.freeze(Time.now + 100.year) do
      visit events_url
      within('nav', match: :first) do
        assert_selector '.dropdown-item', text: "None"
      end
    end
  end
end
