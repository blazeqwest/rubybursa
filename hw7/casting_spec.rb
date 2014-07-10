require_relative 'casting'

describe Casting do
casting = Casting.new([
      {name: 'Brad Pitt', age: 50, sex: 'male', topic: 'Kids', duration: 30, text_size: 45},
      {name: 'Jack Nicholson', age: 77, sex: 'male', topic: 'Some', duration: 20, text_size: 25},
      {name: 'Zooey Deschanel', age: 34, sex: 'female', topic: 'Some some', duration: 35, text_size: 60},
      {name: 'Elle Fanning', age: 16, sex: 'female', topic: 'Some topic', duration: 10, text_size: 20}],
    [
      {name: 'Romeo', supposed_sex: 'male', age_range: [12,20]},
      {name: 'Juliet', supposed_sex: 'female', age_range: [12,20]},
      {name: 'Oldman', supposed_sex: 'male', age_range: [70,90]},
      {name: 'Oldman', supposed_sex: 'male', age_range: [70,90]}
      ],
    ['male', 'female', 'female', 'male'])
  it 'should set probations_time for each actor to 0 by default' do
    casting.actors.each do |actor|
      expect(actor[:probations_time]).to eq(0)
    end
  end

  it 'should set tested_actors for each role to [] by default' do
    casting.roles.each do |role|
      expect(role[:tested_actors]).to eq([])
    end
  end

  it 'should have actors' do
    expect(casting.actors).not_to be eql(nil)
  end
  
  it 'should have judges' do
    expect(casting.judges).not_to be eql(nil)
  end

  it 'should have roles' do
    expect(casting.roles).not_to be eql(nil)
  end

  it 'it should be able to manage probations' do
    expect(casting.probation(casting.actors[0], casting.roles[0])).not_to be eql(nil)
  end

  it 'each actor should be able to take probation only if he fits age range for a role' do
    expect(casting.probation(casting.actors[0], casting.roles[0])).to eq('Actor is too old for this role!')
    expect(casting.probation(casting.actors[0], casting.roles[2])).to eq('Actor is too young for this role!')
  end

  it 'each actor should apply on a role only for the same sex as his(hers)' do
    expect(casting.probation(casting.actors[3], casting.roles[0])).to eq('Wrong sex of actor!')
    expect(casting.probation(casting.actors[1], casting.roles[2])).not_to eq('Wrong sex of actor!')
  end
  
  it 'female judges should mark speach with less than 30 words no more than 7 points' do
    female_judging = casting
    female_judging.judges = ['female']
    7.times do 
      expect(casting.probation(casting.actors[3], casting.roles[1])).to be <= 7 
      casting.roles[1][:tested_actors] = []
    end
  end

  it 'male judges should mark each speach no less than 7 points for female actors age 18-25' do
    male_judging = casting
    male_judging.judges = ['male']
    7.times do 
      expect(casting.probation(casting.actors[3], casting.roles[1])).to be >= 7
      casting.roles[1][:tested_actors] = []
    end

  end

  it 'each attempt has a result wich is equal to average score from all judges' do
    10.times do 
      expect(casting.probation(casting.actors[3], casting.roles[1])).to be <= 10
      casting.roles[1][:tested_actors] = []
    end
  end
  
  it 'each probation result should not be less than a zero' do
    10.times do 
      expect(casting.probation(casting.actors[3], casting.roles[1])).not_to be eq(10)
      casting.roles[1][:tested_actors] = []
    end
  end

  it 'it should find best matching role' do
    expect(casting.best_role(casting.actors[1])).not_to eq({role: 'No applicable roles', score: 0})
  end

  it 'each actor should make only one attempt to each role' do
    casting.probation(casting.actors[3], casting.roles[1])
    expect(casting.probation(casting.actors[3], casting.roles[1])).to eq("Only one attempt is allowed!")
    casting.roles[1][:tested_actors] = []
  end

  it 'it should count total duration of probation taken' do
    casting.roles.each {|role| casting.probation(casting.actors[3], role) }
    expect(casting.actors[3][:probations_time]).to be > 0
    casting.roles.each { |role| role[:tested_actors] = [] }
  end

  it 'actor should have maximum audtion score eq or less than 10 and it should not be negative' do
    casting.actors.each do |actor|
      casting.roles.each do |role|
         p = casting.probation(actor,role)
        (1..10).should cover(p) if p.is_a? Numeric 
      end
    end
    casting.roles.each { |role| role[:tested_actors] = [] }
  end
end
