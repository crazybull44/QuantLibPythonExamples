#ifndef ql_engines_dividend_i
#define ql_engines_dividend_i

%include ../ql/types.i
%include ../ql/common.i
%include ../ql/alltypes.i
%include ../ql/base.i

%{
using QuantLib::AnalyticDividendEuropeanEngine;
using QuantLib::FdOrnsteinUhlenbeckVanillaEngine;
using QuantLib::FdBlackScholesShoutEngine;
using QuantLib::FdHestonHullWhiteVanillaEngine;
%}

%shared_ptr(AnalyticDividendEuropeanEngine)
class AnalyticDividendEuropeanEngine : public PricingEngine {
  public:
    AnalyticDividendEuropeanEngine(
        ext::shared_ptr<GeneralizedBlackScholesProcess> process);
};

%shared_ptr(FdBlackScholesShoutEngine)
class FdBlackScholesShoutEngine : public PricingEngine {
  public:
    explicit FdBlackScholesShoutEngine(
        ext::shared_ptr<GeneralizedBlackScholesProcess>,
        Size tGrid = 100,
        Size xGrid = 100,
        Size dampingSteps = 0,
        const FdmSchemeDesc& schemeDesc = FdmSchemeDesc::Douglas());
};

%shared_ptr(FdOrnsteinUhlenbeckVanillaEngine)
class FdOrnsteinUhlenbeckVanillaEngine : public PricingEngine {
  public:
    %feature("kwargs") FdOrnsteinUhlenbeckVanillaEngine;
    FdOrnsteinUhlenbeckVanillaEngine(
        ext::shared_ptr<OrnsteinUhlenbeckProcess>,
        ext::shared_ptr<YieldTermStructure> rTS,
        Size tGrid = 100,
        Size xGrid = 100,
        Size dampingSteps = 0,
        Real epsilon = 0.0001,
        const FdmSchemeDesc& schemeDesc = FdmSchemeDesc::Douglas());
};

%shared_ptr(FdHestonHullWhiteVanillaEngine)
class FdHestonHullWhiteVanillaEngine : public PricingEngine {
  public:
    FdHestonHullWhiteVanillaEngine(
        const ext::shared_ptr<HestonModel>& model,
        ext::shared_ptr<HullWhiteProcess> hwProcess,
        Real corrEquityShortRate,
        Size tGrid = 50,
        Size xGrid = 100,
        Size vGrid = 40,
        Size rGrid = 20,
        Size dampingSteps = 0,
        bool controlVariate = true,
        const FdmSchemeDesc& schemeDesc = FdmSchemeDesc::Hundsdorfer());

    void enableMultipleStrikesCaching(const std::vector<Real>& strikes);
};

#endif
