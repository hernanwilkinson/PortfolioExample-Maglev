require "./subclass_responsibility"

class Measure
  def == (anObject)
    if self.is_a? (Measure)
      (self-anObject).isZero?
    else
      false
    end
  end

  def + (anotherMeasure)
    raise SubclassResponsibility
  end

  def - (anotherMeasure)
    self+anotherMeasure.negated()
  end

  def negated()
    raise SubclassResponsibility
  end

  def addSimpleMeasure(aSimpleMeasure)
    raise SubclassResponsibility
  end

  def addCompoundMeasure(aCompoundMeasure)
    raise SubclassResponsibility
  end

  def isZero?
    raise SubclassResponsibility
  end

  def at (aUnit)
    raise SubclassResponsibility
  end
end

class SimpleMeasure < Measure

  def self.nothing()
    self.new(0,self.nothingUnit())
  end

  def self.nothingUnit()
    :nothing
  end

  def initialize(amount,unit)
    @amount = amount
    @unit = unit
  end

  def amount
    @amount
  end

  def unit
    @unit
  end

  def to_s
    if @unit==self.class.nothingUnit
      @amount.to_s
    else
      #TODO Very simple trick, but should do better
      if @amount.abs==1
        @amount.to_s + ' ' + @unit.to_s
      else
        @amount.to_s + ' ' + @unit.to_s + "s"
      end
    end
  end

  def + (anotherMeasure)
    anotherMeasure.addSimpleMeasure(self)
  end

  def - (anotherMeasure)
    self+anotherMeasure.negated()
  end

  def negated()
    SimpleMeasure.new(-@amount,@unit)
  end

  def addSimpleMeasure(aSimpleMeasure)
    if self.sameUnitAs?(aSimpleMeasure)
      self.class.new(amount+aSimpleMeasure.amount,@unit)
    else
      measures = Hash.new()
      measures[@unit] = self
      measures[aSimpleMeasure.unit] = aSimpleMeasure
      CompoundMeasure.new(measures)
    end
  end

  def addCompoundMeasure(aCompoundMeasure)
    aCompoundMeasure.addSimpleMeasure(self)
  end

  def sameUnitAs?(aSimpleMeasure)
    @unit == aSimpleMeasure.unit
  end

  def zero
    self.class.new(0,@unit)
  end

  def isZero?
    @amount==0
  end

  def positive?
    @amount>0
  end

  def at (aUnit)
    if @unit==aUnit
      self
    else
      self.class.new(0,aUnit)
    end
  end
end

class CompoundMeasure < Measure

  def initialize(measures)
    @measures = measures
  end

  def to_s
    stringRepresentation = ''
    @measures.values.each_with_index do |measure,index|
      if !measure.isZero?
        if measure.positive?
          if index==0
            stringRepresentation = stringRepresentation+measure.to_s
          else
            stringRepresentation = stringRepresentation+'+'+measure.to_s
          end
        else
          stringRepresentation = stringRepresentation+measure.to_s
        end
      end
    end
    stringRepresentation
  end

  def + (anotherMeasure)
    anotherMeasure.addCompoundMeasure(self)
  end

  def negated()
    newMeasures = {}
    @measures.each do |aUnit, aSimpleMeasure|
      newMeasures[aUnit] = aSimpleMeasure.negated()
    end
    self.class.new(newMeasures)
  end

  def addSimpleMeasure(aSimpleMeasure)
    newMeasures = @measures.clone()
    addToMeasures(aSimpleMeasure, newMeasures)
    self.class.new(newMeasures)
  end

  def addCompoundMeasure(aCompoundMeasure)
    newMeasures = @measures.clone()
    otherMeasures = aCompoundMeasure.each_measure do |aUnit,aSimpleMeasure|
      addToMeasures(aSimpleMeasure, newMeasures)
    end
    self.class.new(newMeasures)
  end

  def addToMeasures(aSimpleMeasure, newMeasures)
    newMeasures[aSimpleMeasure.unit] ||= aSimpleMeasure.zero()
    newMeasures[aSimpleMeasure.unit] += aSimpleMeasure
  end

  def at (aUnit)
    @measures[aUnit] || SimpleMeasure.new(0,aUnit)
  end

  def each_measure(&block)
    @measures.each(&block)
  end

  def isZero?
    @measures.all? { |unit,aSimpleMeasure| aSimpleMeasure.isZero? }
  end
end
