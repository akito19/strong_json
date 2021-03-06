require "strong_json"

describe "StrongJSON.new" do
  it "tests the structure of a JSON object" do
    s = StrongJSON.new do
      let :item, object(name: string, count: numeric, price: numeric, comment: ignored)
      let :checkout, object(items: array(item), change: optional(number), type: enum(literal(1), symbol))
    end

    expect(s.checkout.coerce(items: [ { name: "test", count: 1, price: "2.33", comment: "dummy" }], type: 1)).to eq(items: [ { name: "test", count: 1, price: "2.33" }], type: 1)
  end

  it "tests enums" do
    s = StrongJSON.new do
      let :enum, object(e1: enum(string, number), e2: enum?(literal(1), literal(2)))
    end

    expect(s.enum.coerce(e1: "")).to eq(e1: "")
    expect(s.enum.coerce(e1: 0)).to eq(e1: 0)
    expect(s.enum.coerce(e1: 0, e2: 1)).to eq(e1: 0, e2: 1)
    expect(s.enum.coerce(e1: 0, e2: 2)).to eq(e1: 0, e2: 2)
    expect{ s.enum.coerce(e1: false) }.to raise_error(StrongJSON::Type::Error)
    expect{ s.enum.coerce(e1: "", e2: 3) }.to raise_error(StrongJSON::Type::Error)
  end
end
