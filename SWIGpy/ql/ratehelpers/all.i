#ifndef ql_ratehelpers_all_i
#define ql_ratehelpers_all_i

%include ../ql/types.i
%include ../ql/common.i
%include ../ql/alltypes.i
%include ../ql/base.i

%{
using QuantLib::DepositRateHelper;
using QuantLib::FraRateHelper;
using QuantLib::FuturesRateHelper;
using QuantLib::SwapRateHelper;
using QuantLib::BondHelper;
using QuantLib::FixedRateBondHelper;
using QuantLib::OISRateHelper;
using QuantLib::DatedOISRateHelper;
using QuantLib::FxSwapRateHelper;
using QuantLib::OvernightIndexFutureRateHelper;
using QuantLib::SofrFutureRateHelper;
%}

%shared_ptr(DepositRateHelper)
class DepositRateHelper : public RateHelper {
  public:
    DepositRateHelper(
        const Handle<Quote>& rate,
        const Period& tenor,
        Natural fixingDays,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        const DayCounter& dayCounter);
    DepositRateHelper(
        Rate rate,
        const Period& tenor,
        Natural fixingDays,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        const DayCounter& dayCounter);
    DepositRateHelper(
        const Handle<Quote>& rate,
        const ext::shared_ptr<IborIndex>& index);
    DepositRateHelper(
        Rate rate,
        const ext::shared_ptr<IborIndex>& index);
};

%shared_ptr(FraRateHelper)
class FraRateHelper : public RateHelper {
  public:
    FraRateHelper(
        const Handle<Quote>& rate,
        Natural monthsToStart,
        Natural monthsToEnd,
        Natural fixingDays,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        const DayCounter& dayCounter,
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date(),
        bool useIndexedCoupon = true);
    FraRateHelper(
        Rate rate,
        Natural monthsToStart,
        Natural monthsToEnd,
        Natural fixingDays,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        const DayCounter& dayCounter,
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date(),
        bool useIndexedCoupon = true);
    FraRateHelper(
        const Handle<Quote>& rate,
        Natural monthsToStart,
        const ext::shared_ptr<IborIndex>& index,
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date(),
        bool useIndexedCoupon = true);
    FraRateHelper(
        Rate rate,
        Natural monthsToStart,
        const ext::shared_ptr<IborIndex>& index,
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date(),
        bool useIndexedCoupon = true);
    FraRateHelper(
        const Handle<Quote>& rate,
        Natural immOffsetStart,
        Natural immOffsetEnd,
        const ext::shared_ptr<IborIndex>& iborIndex,
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date(),
        bool useIndexedCoupon = true);
    FraRateHelper(
        Rate rate,
        Natural immOffsetStart,
        Natural immOffsetEnd,
        const ext::shared_ptr<IborIndex>& iborIndex,
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date(),
        bool useIndexedCoupon = true);
};

%shared_ptr(FuturesRateHelper)
class FuturesRateHelper : public RateHelper {
  public:
    FuturesRateHelper(
        const Handle<Quote>& price,
        const Date& iborStartDate,
        Natural nMonths,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        const DayCounter& dayCounter,
        const Handle<Quote>& convexityAdjustment = Handle<Quote>(),
        Futures::Type type = Futures::IMM);
    FuturesRateHelper(
        Real price,
        const Date& iborStartDate,
        Natural nMonths,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        const DayCounter& dayCounter,
        Rate convexityAdjustment = 0.0,
        Futures::Type type = Futures::IMM);
    FuturesRateHelper(
        const Handle<Quote>& price,
        const Date& iborStartDate,
        const Date& iborEndDate,
        const DayCounter& dayCounter,
        const Handle<Quote>& convexityAdjustment = Handle<Quote>(),
        Futures::Type type = Futures::IMM);
    FuturesRateHelper(
        Real price,
        const Date& iborStartDate,
        const Date& iborEndDate,
        const DayCounter& dayCounter,
        Rate convexityAdjustment = 0.0,
        Futures::Type type = Futures::IMM);
    FuturesRateHelper(
        const Handle<Quote>& price,
        const Date& iborStartDate,
        const ext::shared_ptr<IborIndex>& index,
        const Handle<Quote>& convexityAdjustment = Handle<Quote>(),
        Futures::Type type = Futures::IMM);
    FuturesRateHelper(
        Real price,
        const Date& iborStartDate,
        const ext::shared_ptr<IborIndex>& index,
        Real convexityAdjustment = 0.0,
        Futures::Type type = Futures::IMM);
};

%shared_ptr(SwapRateHelper)
class SwapRateHelper : public RateHelper {
  public:
    SwapRateHelper(
        const Handle<Quote>& rate,
        const Period& tenor,
        const Calendar& calendar,
        Frequency fixedFrequency,
        BusinessDayConvention fixedConvention,
        const DayCounter& fixedDayCount,
        const ext::shared_ptr<IborIndex>& index,
        const Handle<Quote>& spread = Handle<Quote>(),
        const Period& fwdStart = 0 * Days,
        const Handle<YieldTermStructure>& discountingCurve = Handle<YieldTermStructure>(),
        Natural settlementDays = Null<Natural>(),
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date());
    SwapRateHelper(
        Rate rate,
        const Period& tenor,
        const Calendar& calendar,
        Frequency fixedFrequency,
        BusinessDayConvention fixedConvention,
        const DayCounter& fixedDayCount,
        const ext::shared_ptr<IborIndex>& index,
        const Handle<Quote>& spread = Handle<Quote>(),
        const Period& fwdStart = 0 * Days,
        const Handle<YieldTermStructure>& discountingCurve = Handle<YieldTermStructure>(),
        Natural settlementDays = Null<Natural>(),
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date());
    SwapRateHelper(
        const Handle<Quote>& rate,
        const ext::shared_ptr<SwapIndex>& index,
        const Handle<Quote>& spread = Handle<Quote>(),
        const Period& fwdStart = 0 * Days,
        const Handle<YieldTermStructure>& discountingCurve = Handle<YieldTermStructure>(),
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date());
    SwapRateHelper(
        Rate rate,
        const ext::shared_ptr<SwapIndex>& index,
        const Handle<Quote>& spread = Handle<Quote>(),
        const Period& fwdStart = 0 * Days,
        const Handle<YieldTermStructure>& discountingCurve = Handle<YieldTermStructure>(),
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date());
    Spread spread();
    ext::shared_ptr<VanillaSwap> swap();
};

%shared_ptr(BondHelper)
class BondHelper : public RateHelper {
  public:
    BondHelper(
        const Handle<Quote>& cleanPrice,
        const ext::shared_ptr<Bond>& bond,
        bool useCleanPrice = true);

    ext::shared_ptr<Bond> bond();
};

%{
std::vector<ext::shared_ptr<BondHelper>> convert_bond_helpers(
    const std::vector<ext::shared_ptr<RateHelper>>& helpers) {
    std::vector<ext::shared_ptr<BondHelper>> result(helpers.size());
    for (Size i = 0; i < helpers.size(); ++i)
        result[i] = ext::dynamic_pointer_cast<BondHelper>(helpers[i]);
    return result;
}
%}

%shared_ptr(FixedRateBondHelper)
class FixedRateBondHelper : public BondHelper {
  public:
    FixedRateBondHelper(
        const Handle<Quote>& cleanPrice,
        Size settlementDays,
        Real faceAmount,
        const Schedule& schedule,
        const std::vector<Rate>& coupons,
        const DayCounter& paymentDayCounter,
        BusinessDayConvention paymentConvention = Following,
        Real redemption = 100.0,
        const Date& issueDate = Date(),
        const Calendar& paymentCalendar = Calendar(),
        const Period& exCouponPeriod = Period(),
        const Calendar& exCouponCalendar = Calendar(),
        BusinessDayConvention exCouponConvention = Unadjusted,
        bool exCouponEndOfMonth = false,
        bool useCleanPrice = true);

    ext::shared_ptr<FixedRateBond> fixedRateBond();
};

%shared_ptr(OISRateHelper)
class OISRateHelper : public RateHelper {
    %feature("kwargs") OISRateHelper;

  public:
    OISRateHelper(
        Natural settlementDays,
        const Period& tenor,
        const Handle<Quote>& rate,
        const ext::shared_ptr<OvernightIndex>& index,
        const Handle<YieldTermStructure>& discountingCurve = Handle<YieldTermStructure>(),
        bool telescopicValueDates = false,
        Natural paymentLag = 0,
        BusinessDayConvention paymentConvention = Following,
        Frequency paymentFrequency = Annual,
        const Calendar& paymentCalendar = Calendar(),
        const Period& forwardStart = 0 * Days,
        const Spread overnightSpread = 0.0,
        Pillar::Choice pillar = Pillar::LastRelevantDate,
        Date customPillarDate = Date());
    ext::shared_ptr<OvernightIndexedSwap> swap();
};

%shared_ptr(DatedOISRateHelper)
class DatedOISRateHelper : public RateHelper {
  public:
    DatedOISRateHelper(
        const Date& startDate,
        const Date& endDate,
        const Handle<Quote>& rate,
        const ext::shared_ptr<OvernightIndex>& index,
        const Handle<YieldTermStructure>& discountingCurve = Handle<YieldTermStructure>());
};

%shared_ptr(FxSwapRateHelper)
class FxSwapRateHelper : public RateHelper {
  public:
    FxSwapRateHelper(
        const Handle<Quote>& fwdPoint,
        const Handle<Quote>& spotFx,
        const Period& tenor,
        Natural fixingDays,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        bool isFxBaseCurrencyCollateralCurrency,
        const Handle<YieldTermStructure>& collateralCurve,
        const Calendar& tradingCalendar = Calendar());
};

%shared_ptr(OvernightIndexFutureRateHelper)
class OvernightIndexFutureRateHelper : public RateHelper {
  public:
    OvernightIndexFutureRateHelper(
        const Handle<Quote>& price,
        const Date& valueDate,
        const Date& maturityDate,
        const ext::shared_ptr<OvernightIndex>& index,
        const Handle<Quote>& convexityAdjustment = Handle<Quote>(),
        OvernightIndexFuture::NettingType type = OvernightIndexFuture::Compounding);
};

%shared_ptr(SofrFutureRateHelper)
class SofrFutureRateHelper : public OvernightIndexFutureRateHelper {
  public:
    SofrFutureRateHelper(
        const Handle<Quote>& price,
        Month referenceMonth,
        Year referenceYear,
        Frequency referenceFreq,
        const ext::shared_ptr<OvernightIndex>& index,
        const Handle<Quote>& convexityAdjustment = Handle<Quote>(),
        OvernightIndexFuture::NettingType type = OvernightIndexFuture::Compounding);
    SofrFutureRateHelper(
        Real price,
        Month referenceMonth,
        Year referenceYear,
        Frequency referenceFreq,
        const ext::shared_ptr<OvernightIndex>& index,
        Real convexityAdjustment = 0.0,
        OvernightIndexFuture::NettingType type = OvernightIndexFuture::Compounding);
};

// allow use of RateHelper vectors
namespace std {
    %template(RateHelperVector) vector<ext::shared_ptr<RateHelper> >;
}

// allow use of RateHelper vectors
namespace std {
    %template(BondHelperVector) vector<ext::shared_ptr<BondHelper> >;
}

%inline %{
    const ext::shared_ptr<DepositRateHelper> as_depositratehelper(
        const ext::shared_ptr<RateHelper> helper) {
        return ext::dynamic_pointer_cast<DepositRateHelper>(helper);
    }
	const ext::shared_ptr<FraRateHelper> as_fraratehelper(
        const ext::shared_ptr<RateHelper> helper) {
        return ext::dynamic_pointer_cast<FraRateHelper>(helper);
    }
    const ext::shared_ptr<SwapRateHelper> as_swapratehelper(
        const ext::shared_ptr<RateHelper> helper) {
        return ext::dynamic_pointer_cast<SwapRateHelper>(helper);
    }
    const ext::shared_ptr<OISRateHelper> as_oisratehelper(
        const ext::shared_ptr<RateHelper> helper) {
        return ext::dynamic_pointer_cast<OISRateHelper>(helper);
    }
%}

#endif