#ifndef ql_engines_swing_i
#define ql_engines_swing_i

%include ../ql/types.i
%include ../ql/common.i
%include ../ql/alltypes.i
%include ../ql/base.i

%{
using QuantLib::FdSimpleBSSwingEngine;
using QuantLib::FdSimpleExtOUJumpSwingEngine;
%}

%shared_ptr(FdSimpleBSSwingEngine)
class FdSimpleBSSwingEngine : public PricingEngine {
  public:
    FdSimpleBSSwingEngine(
        ext::shared_ptr<GeneralizedBlackScholesProcess> process,
        Size tGrid = 50,
        Size xGrid = 100,
        const FdmSchemeDesc& schemeDesc = FdmSchemeDesc::Douglas());
};

%shared_ptr(FdSimpleExtOUJumpSwingEngine)
class FdSimpleExtOUJumpSwingEngine : public PricingEngine {
  public:
    %extend {
        FdSimpleExtOUJumpSwingEngine(
            const ext::shared_ptr<ExtOUWithJumpsProcess>& process,
            const ext::shared_ptr<YieldTermStructure>& rTS,
            Size tGrid = 50, Size xGrid = 200, Size yGrid=50,
            const std::vector<std::pair<Time,Real>>& shape = std::vector<std::pair<Time,Real>>(),
            const FdmSchemeDesc& schemeDesc = FdmSchemeDesc::Hundsdorfer()) {
            ext::shared_ptr<FdSimpleExtOUJumpSwingEngine::Shape> curve(
                new FdSimpleExtOUJumpSwingEngine::Shape(shape));

            return new FdSimpleExtOUJumpSwingEngine(
                    process, rTS, tGrid, xGrid, yGrid,
                    curve, schemeDesc);
        }
    }
};

#endif
