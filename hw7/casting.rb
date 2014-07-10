class Casting
  
  attr_reader :actors, :judges, :roles
  attr_writer :judges
  
  def initialize(actors, roles, judges)
    @actors = actors
    @roles = roles
    @judges = judges
    @actors.each {|actor| actor[:probations_time] ||= 0}
    @roles.each {|role| role[:tested_actors] ||= []}
  end
  
  def probation (actor,role)
    raise ArgumentError, 'Wrong actor info, it should be a hash' if actor.class != Hash
    raise ArgumentError, 'Wrong role info, it should be a hash' if role.class != Hash
    return 'Actor is too old for this role!' if actor[:age] > role[:age_range][1]
    return 'Actor is too young for this role!' if actor[:age] < role[:age_range][0]
    return 'Wrong sex of actor!' if actor[:sex] != role[:supposed_sex]
    return 'Only one attempt is allowed!' if role[:tested_actors].include?(actor[:name])
    result = 0
    role[:tested_actors].push(actor[:name])
    @judges.each do |judge|
      case judge
      when 'female'
        result += 1 + rand(7) if actor[:text_size] < 30
        result += 1 + rand(10) if actor[:text_size] > 30
      when 'male'
        result += 7 + rand(3) if actor[:sex] == 'female'
        result += 1 + rand(10) if actor[:sex] == 'male'
      end
      actor[:probations_time] += actor[:duration]
      return result / @judges.length
    end
  end

  def best_role(actor, *roles)
    result = {role: 'No applicable roles', score: 0, attempts: 0}
    roles.each do |role|
      s = self.probation(actor,role)
      result[:attempts] += 1
      if (s.is_a? Numeric) && s > result[:score] 
        result[:role] = role[:name]
        result[:score] = s
      end
    end
    actor[:best_role] = result
    result
  end
end
