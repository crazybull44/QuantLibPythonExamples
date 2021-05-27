#ifndef ql_indexes_all_i
#define ql_indexes_all_i

%include ../ql/types.i
%include ../ql/common.i
%include ../ql/alltypes.i
%include ../ql/base.i

%{
using QuantLib::IndexManager;
%}

class IndexManager {
  private:
    IndexManager();
  public:
    static IndexManager& instance();
    void setHistory(const std::string& name, const TimeSeries<Real>& fixings);
    const TimeSeries<Real>& getHistory(const std::string& name) const;
    bool hasHistory(const std::string& name) const;
    std::vector<std::string> histories() const;
    void clearHistory(const std::string& name);
    void clearHistories();
};

%{
using QuantLib::InterestRateIndex;
using QuantLib::BMAIndex;
using QuantLib::IborIndex;
using QuantLib::OvernightIndex;
using QuantLib::Libor;
using QuantLib::DailyTenorLibor;
using QuantLib::SwapIndex;
using QuantLib::SwapSpreadIndex;
using QuantLib::OvernightIndexedSwapIndex;
%}

%fragment("zeroinflationindex", "header") {
using QuantLib::Region;
using QuantLib::CustomRegion;
using QuantLib::InflationIndex;
using QuantLib::ZeroInflationIndex;
using QuantLib::YoYInflationIndex;
}
%fragment("zeroinflationindex");

%{
using QuantLib::AUCPI;
%}

%shared_ptr(InterestRateIndex)
class InterestRateIndex : public Index {
  protected:
    InterestRateIndex();
  public:
    std::string familyName() const;
    Period tenor() const;
    Natural fixingDays() const;
    Date fixingDate(const Date& valueDate) const;
    Date maturityDate(const Date& valueDate) const;
    Date valueDate(const Date& fixingDate) const;
    const Currency& currency() const;
    const DayCounter& dayCounter() const;

    Rate forecastFixing(const Date& fixingDate) const;
    Rate pastFixing(const Date& fixingDate) const;
};

%shared_ptr(BMAIndex)
class BMAIndex : public InterestRateIndex {
  public:
    explicit BMAIndex(
        const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
    BMAIndex(const Handle<YieldTermStructure>& h,
             const Calendar& fixingCalendar);
    bool isValidFixingDate(const Date& fixingDate) const;
    Handle<YieldTermStructure> forwardingTermStructure() const;
    Date maturityDate(const Date& valueDate) const;
    Schedule fixingSchedule(const Date& start,
                            const Date& end);
};

%shared_ptr(IborIndex)
class IborIndex : public InterestRateIndex {
  public:
    IborIndex(
        const std::string& familyName,
        const Period& tenor,
        Integer settlementDays,
        const Currency& currency,
        const Calendar& calendar,
        BusinessDayConvention convention,
        bool endOfMonth,
        const DayCounter& dayCounter,
        const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
    BusinessDayConvention businessDayConvention() const;
    bool endOfMonth() const;
    Handle<YieldTermStructure> forwardingTermStructure() const;
    ext::shared_ptr<IborIndex> clone(
        const Handle<YieldTermStructure>&) const;
};

%inline %{
    ext::shared_ptr<IborIndex> as_iborindex(
        const ext::shared_ptr<InterestRateIndex>& index) {
        return ext::dynamic_pointer_cast<IborIndex>(index);
    }
%}

%shared_ptr(OvernightIndex)
class OvernightIndex : public IborIndex {
  public:
    OvernightIndex(
        const std::string& familyName,
        Integer settlementDays,
        const Currency& currency,
        const Calendar& calendar,
        const DayCounter& dayCounter,
        const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
    %extend {
        ext::shared_ptr<OvernightIndex> clone(const Handle<YieldTermStructure>& h) {
            return ext::dynamic_pointer_cast<OvernightIndex>(self->clone(h));
        }
    }
};

%shared_ptr(Libor)
class Libor : public IborIndex {
  public:
    Libor(
        const std::string& familyName,
        const Period& tenor,
        Natural settlementDays,
        const Currency& currency,
        const Calendar& financialCenterCalendar,
        const DayCounter& dayCounter,
        const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
};

%shared_ptr(DailyTenorLibor)
class DailyTenorLibor : public IborIndex {
  public:
    DailyTenorLibor(
        const std::string& familyName,
        Natural settlementDays,
        const Currency& currency,
        const Calendar& financialCenterCalendar,
        const DayCounter& dayCounter,
        const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
};

%shared_ptr(SwapIndex)
class SwapIndex : public InterestRateIndex {
  public:
    SwapIndex(
        const std::string& familyName,
        const Period& tenor,
        Integer settlementDays,
        const Currency& currency,
        const Calendar& calendar,
        const Period& fixedLegTenor,
        BusinessDayConvention fixedLegConvention,
        const DayCounter& fixedLegDayCounter,
        const ext::shared_ptr<IborIndex>& iborIndex);
    SwapIndex(
        const std::string& familyName,
        const Period& tenor,
        Integer settlementDays,
        const Currency& currency,
        const Calendar& calendar,
        const Period& fixedLegTenor,
        BusinessDayConvention fixedLegConvention,
        const DayCounter& fixedLegDayCounter,
        const ext::shared_ptr<IborIndex>& iborIndex,
        const Handle<YieldTermStructure>& discountCurve);
    Period fixedLegTenor() const;
    BusinessDayConvention fixedLegConvention() const;
    ext::shared_ptr<IborIndex> iborIndex() const;
    Handle<YieldTermStructure> forwardingTermStructure() const;
    Handle<YieldTermStructure> discountingTermStructure() const;
    ext::shared_ptr<SwapIndex> clone(
        const Handle<YieldTermStructure>& h) const;
    ext::shared_ptr<SwapIndex> clone(
        const Handle<YieldTermStructure>& forwarding,
        const Handle<YieldTermStructure>& discounting) const;
    ext::shared_ptr<SwapIndex> clone(
        const Period& tenor) const;
};

namespace std {
    %template(SwapIndexVector) vector<ext::shared_ptr<SwapIndex> >;
}

%shared_ptr(SwapSpreadIndex)
class SwapSpreadIndex : public InterestRateIndex {
  public:
    SwapSpreadIndex(
        const std::string& familyName,
        const ext::shared_ptr<SwapIndex>& swapIndex1,
        const ext::shared_ptr<SwapIndex>& swapIndex2,
        const Real gearing1 = 1.0,
        const Real gearing2 = -1.0);
    Rate forecastFixing(const Date& fixingDate) const;
    Rate pastFixing(const Date& fixingDate) const;
    ext::shared_ptr<SwapIndex> swapIndex1();
    ext::shared_ptr<SwapIndex> swapIndex2();
    Real gearing1();
    Real gearing2();
};

%define export_xibor_instance(Name)
%{
using QuantLib::Name;
%}

%shared_ptr(Name)
class Name : public IborIndex {
  public:
    Name(const Period& tenor,
         const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
};
%enddef

%define export_quoted_xibor_instance(Name,Base)
%{
using QuantLib::Name;
%}

%shared_ptr(Name)
class Name : public Base {
  public:
    Name(const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
};
%enddef

%define export_overnight_instance(Name)
%{
using QuantLib::Name;
%}

%shared_ptr(Name)
class Name : public OvernightIndex {
  public:
    Name(const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
};
%enddef

%define export_daily_libor_instance(Name)
%{
using QuantLib::Name;
%}

%shared_ptr(Name)
class Name : public DailyTenorLibor {
  public:
    Name(const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
};
%enddef

%define export_swap_instance(Name)
%{
using QuantLib::Name;
%}

%shared_ptr(Name)
class Name : public SwapIndex {
  public:
    Name(const Period &tenor,
         const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
    Name(const Period &tenor,
         const Handle<YieldTermStructure>& h1,
         const Handle<YieldTermStructure>& h2);
};
%enddef

%define export_quoted_swap_instance(Name,Base)
%{
using QuantLib::Name;
%}

%shared_ptr(Name)
class Name : public Base {
  public:
    Name(const Handle<YieldTermStructure>& h = Handle<YieldTermStructure>());
    Name(const Handle<YieldTermStructure>& h1,
         const Handle<YieldTermStructure>& h2);
};
%enddef

%inline %{
    ext::shared_ptr<SwapIndex> as_swap_index(
        const ext::shared_ptr<InterestRateIndex>& index) {
        return ext::dynamic_pointer_cast<SwapIndex>(index);
    }
%}

export_xibor_instance(AUDLibor);
export_xibor_instance(CADLibor);
export_xibor_instance(Cdor);
export_xibor_instance(CHFLibor);
export_xibor_instance(DKKLibor);
export_xibor_instance(Bbsw);
export_xibor_instance(Bkbm);
export_xibor_instance(Euribor);
export_xibor_instance(Euribor365);
export_xibor_instance(EURLibor);
export_xibor_instance(GBPLibor);
export_xibor_instance(Jibar);
export_xibor_instance(JPYLibor);
export_xibor_instance(Mosprime);
export_xibor_instance(NZDLibor);
export_xibor_instance(Pribor);
export_xibor_instance(Robor);
export_xibor_instance(SEKLibor);
export_xibor_instance(Shibor);
export_xibor_instance(Tibor);
export_xibor_instance(THBFIX);
export_xibor_instance(TRLibor);
export_xibor_instance(USDLibor);
export_xibor_instance(Wibor);
export_xibor_instance(Zibor);
export_xibor_instance(Bibor);

export_daily_libor_instance(USDLiborON);
export_daily_libor_instance(GBPLiborON);
export_daily_libor_instance(CADLiborON);

export_quoted_xibor_instance(Bbsw1M,Bbsw);
export_quoted_xibor_instance(Bbsw2M,Bbsw);
export_quoted_xibor_instance(Bbsw3M,Bbsw);
export_quoted_xibor_instance(Bbsw4M,Bbsw);
export_quoted_xibor_instance(Bbsw5M,Bbsw);
export_quoted_xibor_instance(Bbsw6M,Bbsw);
export_quoted_xibor_instance(Bkbm1M,Bkbm);
export_quoted_xibor_instance(Bkbm2M,Bkbm);
export_quoted_xibor_instance(Bkbm3M,Bkbm);
export_quoted_xibor_instance(Bkbm4M,Bkbm);
export_quoted_xibor_instance(Bkbm5M,Bkbm);
export_quoted_xibor_instance(Bkbm6M,Bkbm);
export_quoted_xibor_instance(EuriborSW,Euribor);
export_quoted_xibor_instance(Euribor2W,Euribor);
export_quoted_xibor_instance(Euribor3W,Euribor);
export_quoted_xibor_instance(Euribor1M,Euribor);
export_quoted_xibor_instance(Euribor2M,Euribor);
export_quoted_xibor_instance(Euribor3M,Euribor);
export_quoted_xibor_instance(Euribor4M,Euribor);
export_quoted_xibor_instance(Euribor5M,Euribor);
export_quoted_xibor_instance(Euribor6M,Euribor);
export_quoted_xibor_instance(Euribor7M,Euribor);
export_quoted_xibor_instance(Euribor8M,Euribor);
export_quoted_xibor_instance(Euribor9M,Euribor);
export_quoted_xibor_instance(Euribor10M,Euribor);
export_quoted_xibor_instance(Euribor11M,Euribor);
export_quoted_xibor_instance(Euribor1Y,Euribor);
export_quoted_xibor_instance(Euribor365_SW,Euribor365);
export_quoted_xibor_instance(Euribor365_2W,Euribor365);
export_quoted_xibor_instance(Euribor365_3W,Euribor365);
export_quoted_xibor_instance(Euribor365_1M,Euribor365);
export_quoted_xibor_instance(Euribor365_2M,Euribor365);
export_quoted_xibor_instance(Euribor365_3M,Euribor365);
export_quoted_xibor_instance(Euribor365_4M,Euribor365);
export_quoted_xibor_instance(Euribor365_5M,Euribor365);
export_quoted_xibor_instance(Euribor365_6M,Euribor365);
export_quoted_xibor_instance(Euribor365_7M,Euribor365);
export_quoted_xibor_instance(Euribor365_8M,Euribor365);
export_quoted_xibor_instance(Euribor365_9M,Euribor365);
export_quoted_xibor_instance(Euribor365_10M,Euribor365);
export_quoted_xibor_instance(Euribor365_11M,Euribor365);
export_quoted_xibor_instance(Euribor365_1Y,Euribor365);
export_quoted_xibor_instance(EURLiborSW,EURLibor);
export_quoted_xibor_instance(EURLibor2W,EURLibor);
export_quoted_xibor_instance(EURLibor1M,EURLibor);
export_quoted_xibor_instance(EURLibor2M,EURLibor);
export_quoted_xibor_instance(EURLibor3M,EURLibor);
export_quoted_xibor_instance(EURLibor4M,EURLibor);
export_quoted_xibor_instance(EURLibor5M,EURLibor);
export_quoted_xibor_instance(EURLibor6M,EURLibor);
export_quoted_xibor_instance(EURLibor7M,EURLibor);
export_quoted_xibor_instance(EURLibor8M,EURLibor);
export_quoted_xibor_instance(EURLibor9M,EURLibor);
export_quoted_xibor_instance(EURLibor10M,EURLibor);
export_quoted_xibor_instance(EURLibor11M,EURLibor);
export_quoted_xibor_instance(EURLibor1Y,EURLibor);
export_quoted_xibor_instance(BiborSW,Bibor);
export_quoted_xibor_instance(Bibor1M,Bibor);
export_quoted_xibor_instance(Bibor2M,Bibor);
export_quoted_xibor_instance(Bibor3M,Bibor);
export_quoted_xibor_instance(Bibor6M,Bibor);
export_quoted_xibor_instance(Bibor9M,Bibor);
export_quoted_xibor_instance(Bibor1Y,Bibor);

export_overnight_instance(Aonia);
export_overnight_instance(Eonia);
export_overnight_instance(Sonia);
export_overnight_instance(FedFunds);
export_overnight_instance(Nzocr);
export_overnight_instance(Sofr);

export_swap_instance(EuriborSwapIsdaFixA);
export_swap_instance(EuriborSwapIsdaFixB);
export_swap_instance(EuriborSwapIfrFix);
export_swap_instance(EurLiborSwapIsdaFixA);
export_swap_instance(EurLiborSwapIsdaFixB);
export_swap_instance(EurLiborSwapIfrFix);
export_swap_instance(ChfLiborSwapIsdaFix);
export_swap_instance(GbpLiborSwapIsdaFix);
export_swap_instance(JpyLiborSwapIsdaFixAm);
export_swap_instance(JpyLiborSwapIsdaFixPm);
export_swap_instance(UsdLiborSwapIsdaFixAm);
export_swap_instance(UsdLiborSwapIsdaFixPm);

class Region {
  public:
    std::string name() const;
    std::string code() const;
  protected:
    Region();
};

class CustomRegion : public Region {
  public:
    CustomRegion(const std::string& name,
                 const std::string& code);
};

%shared_ptr(InflationIndex)
class InflationIndex : public Index {
  protected:
    InflationIndex();
  public:
    std::string familyName() const;
    Region region() const;
    bool revised() const;
    bool interpolated() const;
    Frequency frequency() const;
    Period availabilityLag() const;
    Currency currency() const;
};

%shared_ptr(ZeroInflationIndex)
class ZeroInflationIndex : public InflationIndex {
  public:
    ZeroInflationIndex(
        const std::string& familyName,
        const Region& region,
        bool revised,
        bool interpolated,
        Frequency frequency,
        const Period& availabilityLag,
        const Currency& currency,
        const Handle<ZeroInflationTermStructure>& h = Handle<ZeroInflationTermStructure>());
    Handle<ZeroInflationTermStructure> zeroInflationTermStructure() const;
    ext::shared_ptr<ZeroInflationIndex> clone(
        const Handle<ZeroInflationTermStructure>& h) const;
};

%shared_ptr(YoYInflationIndex)
class YoYInflationIndex : public InflationIndex {
  public:
    YoYInflationIndex(const std::string& familyName,
                      const Region& region,
                      bool revised,
                      bool interpolated,
                      bool ratio,
                      Frequency frequency,
                      const Period& availabilityLag,
                      const Currency& currency,
                      const Handle<YoYInflationTermStructure>& ts = Handle<YoYInflationTermStructure>());
    bool ratio() const;
    Handle<YoYInflationTermStructure> yoyInflationTermStructure() const;
    ext::shared_ptr<YoYInflationIndex> clone(
        const Handle<YoYInflationTermStructure>& h) const;
};

%define export_zii_instance(Name)
%{
using QuantLib::Name;
%}
%shared_ptr(Name)
class Name : public ZeroInflationIndex {
  public:
    Name(bool interpolated,
         const Handle<ZeroInflationTermStructure>& h = Handle<ZeroInflationTermStructure>());
};
%enddef

%define export_yii_instance(Name)
%fragment("Name","header") {
using QuantLib::Name;
}
%fragment("Name");

%shared_ptr(Name)
class Name : public YoYInflationIndex {
  public:
    Name(bool interpolated,
         const Handle<YoYInflationTermStructure>& h = Handle<YoYInflationTermStructure>());
};
%enddef

export_zii_instance(EUHICP);
export_zii_instance(EUHICPXT);
export_zii_instance(FRHICP);
export_zii_instance(UKRPI);
export_zii_instance(USCPI);
export_zii_instance(ZACPI);

export_yii_instance(YYEUHICP);
export_yii_instance(YYEUHICPXT);
export_yii_instance(YYEUHICPr);
export_yii_instance(YYFRHICP);
export_yii_instance(YYFRHICPr);
export_yii_instance(YYUKRPI);
export_yii_instance(YYUKRPIr);
export_yii_instance(YYUSCPI);
export_yii_instance(YYUSCPIr);
export_yii_instance(YYZACPI);
export_yii_instance(YYZACPIr);

%shared_ptr(AUCPI)
class AUCPI : public ZeroInflationIndex {
  public:
    AUCPI(Frequency frequency,
          bool revised,
          bool interpolated,
          const Handle<ZeroInflationTermStructure>& h = Handle<ZeroInflationTermStructure>());
};

%shared_ptr(OvernightIndexedSwapIndex)
class OvernightIndexedSwapIndex : public SwapIndex {
  public:
    OvernightIndexedSwapIndex(
        const std::string& familyName,
        const Period& tenor,
        Natural settlementDays,
        Currency currency,
        const ext::shared_ptr<OvernightIndex>& overnightIndex,
        bool telescopicValueDates = false);

    ext::shared_ptr<OvernightIndex> overnightIndex() const;
    ext::shared_ptr<OvernightIndexedSwap> underlyingSwap(
        const Date& fixingDate) const;
};

%inline %{
    ext::shared_ptr<OvernightIndexedSwap> as_overnight_swap_index(
        const ext::shared_ptr<InterestRateIndex>& index) {
        return ext::dynamic_pointer_cast<OvernightIndexedSwap>(index);
    }
%}

#endif