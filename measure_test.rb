require "test/unit"
require "./measure"

class MeasureTest < Test::Unit::TestCase

  def setup
    @peso = :peso
    @dollar = :dollar
    @tenPesos = SimpleMeasure.new(10,@peso)
    @twentyPesos = SimpleMeasure.new(20,@peso)
    @fiveDollars = SimpleMeasure.new(5,@dollar)
  end

  def euro
    :euro
  end

  def testTheSumOfMeasuresOfSameUnitIsTheSumOfItsAmountsWithThatUnit
    self.assert_equal(@twentyPesos, @tenPesos+@tenPesos)
  end

  def testTheSumOfMeasuresOfDifferentUnitsKeepsThemSeparate
    balance = @tenPesos+@fiveDollars

    self.assert_equal(balance.at(@peso),@tenPesos)
    self.assert_equal(balance.at(@dollar),@fiveDollars)

  end

  def testASimpleMeasureCanBeSumToACompoundMeasure
    balance = (@tenPesos+@fiveDollars)+@tenPesos

    self.assert_equal(balance.at(@peso),@twentyPesos)
    self.assert_equal(balance.at(@dollar),@fiveDollars)
  end

  def testACompoundMeasureCanBeSumToASimpleMeasure
    balance = @tenPesos+(@fiveDollars+@tenPesos)

    self.assert_equal(balance.at(@peso),@twentyPesos)
    self.assert_equal(balance.at(@dollar),@fiveDollars)

  end

  def testCompoundMeasureIsImmutable
    balance = @tenPesos+@fiveDollars
    balance+@tenPesos

    self.assert_equal(balance.at(@peso),@tenPesos)
    self.assert_equal(balance.at(@dollar),@fiveDollars)
  end

  def testSubtractingMeasureOfSameUnitIsTheSubtractionOfItsAmountsWithTheSameUnit
    minusTenPesos = SimpleMeasure.new(-10,@peso)
    self.assert_equal(minusTenPesos, @tenPesos-@twentyPesos)
  end

  def testSubtractingMeasureOfDifferentUnitYieldsToACompoundMeasure
    balance = @tenPesos-@fiveDollars

    self.assert_equal(balance.at(@peso),@tenPesos)
    self.assert_equal(balance.at(@dollar),@fiveDollars.negated())
  end

  def testASimpleMeasureCanBeSubtractedToACompoundMeasure
    balance = (@tenPesos-@fiveDollars)-@twentyPesos

    self.assert_equal(balance.at(@peso),@tenPesos.negated())
    self.assert_equal(balance.at(@dollar),@fiveDollars.negated())
  end

  def testACompoundMeasureCanBeSubtractedToASimpleMeasure
    balance = @tenPesos-(@fiveDollars+@twentyPesos)

    self.assert_equal(balance.at(@peso),@tenPesos.negated())
    self.assert_equal(balance.at(@dollar),@fiveDollars.negated())
  end

  def testSubtractingToACompoundMeasureCanYieldToASimpleMeasure
    balance = (@tenPesos-@fiveDollars)-@tenPesos

    self.assert_equal(balance,@fiveDollars.negated())
  end

  def testCompoundMeasuresAreEqualWhenTheyHaveTheSameMeasures
    aCompoundMeasure = @tenPesos+@fiveDollars
    anotherCompoundMeasure = @fiveDollars+@tenPesos

    self.assert_equal(aCompoundMeasure,anotherCompoundMeasure)
  end

  def testCompoundMeasuresAreNotEqualWhenTheyHaveDifferentMeasures
    aCompoundMeasure = @tenPesos+@fiveDollars

    self.assert_not_equal(aCompoundMeasure,aCompoundMeasure+@tenPesos)
  end

  def testNothingIsZero
    self.assert(SimpleMeasure.nothing().isZero?)
  end

  def testNothingIsEqualToMeasuresWithAmountZero
    self.assert_equal(SimpleMeasure.nothing(),SimpleMeasure.new(0,@peso))
  end

  def testCompundMeasureRespondsToIsZeroAsExpected
    zeroPesos = SimpleMeasure.new(0,@peso)
    zeroDollars = SimpleMeasure.new(0,@dollar)

    self.assert((zeroPesos+zeroDollars).isZero?)
  end

  def testAtReturnsZeroIfCompoundMeasureDoesNotHaveAMeasureOfThatUnit
    self.assert((@tenPesos+@fiveDollars).at(self.euro()).isZero?)
  end

  def testAtReturnsZeroIfSimpleMeasureIsOfDifferentUnit
    self.assert((@tenPesos.at(self.euro())).isZero?)
  end

  def testAtReturnsSelfIfSimpleMeasureIsOfSameUnit
    self.assert_equal(@tenPesos.at(@peso),@tenPesos)
  end

  def testWhenAmountIsOneAbsUnitIsPrintedAsSingular
    self.assert_equal(SimpleMeasure.new(1,@peso).to_s,"1 peso")
    self.assert_equal(SimpleMeasure.new(-1,@peso).to_s,"-1 peso")
  end

  def testWhenAmountIsNotOneAbsUnitIsPrintedAsPlural
    self.assert_equal(SimpleMeasure.new(1.1,@peso).to_s,"1.1 pesos")
  end

  def testNothingIsPrintedAsZero
    self.assert_equal(SimpleMeasure.nothing.to_s,"0")
  end

  def testCompoundMeasureDoesNotPrintTheInitialPlus
    self.assert(!(@tenPesos+@fiveDollars).to_s.start_with?("+"))
  end

  def testCompoundMeasurePrintsTheInitialMinusWhenFirstMeasureIsNegative
    self.assert((@tenPesos.negated-@fiveDollars).to_s.start_with?("-"))
  end

  def testCompoundMeasureDoesNotPrintZeros
    zeroEuro = SimpleMeasure.new(0,self.euro)
    self.assert(!(@tenPesos+@fiveDollars+zeroEuro).to_s.include?("0 euros"))
  end


end
