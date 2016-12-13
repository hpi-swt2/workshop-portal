RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    page.body.index(earlier_content) < page.body.index(later_content)
  end
end

RSpec::Matchers.define :contain_ordered do |elements|
  match do
    (elements.count - 1).times do |i|
      first = elements[i]
      second = elements[i + 1]
      expect(first).to appear_before(second)
    end
  end
end
