require File.expand_path("../Library/form_lib", __FILE__)

class FormFmft < Formula
  desc "Fully Massive Four-loop Tadpoles"
  homepage "https://github.com/apik/fmft/"
  url "https://github.com/apik/fmft/archive/0.1.tar.gz"
  sha256 "0ee8fd2f72a2d7cbe725e750fbd59aefe1c610d88e482d2de62d5074524fb47d"

  MIN_EXTRA_WEIGHT = 11
  MAX_EXTRA_WEIGHT = 20

  (MIN_EXTRA_WEIGHT..MAX_EXTRA_WEIGHT).each do |i|
    option "with-weight#{i}", "Install up to weight #{i} tables"
  end

  depends_on "form" => :run

  resource "isp-w11" do
    url "https://dl.bintray.com/apik/FMFT/isp-w11.tar.gz"
    sha256 "6e5e3b184302340a57c47cbc7b056985a0f3d2174ad3ae7f80f65677ac807936"
  end

  resource "isp-w12" do
    url "https://dl.bintray.com/apik/FMFT/isp-w12.tar.gz"
    sha256 "754586b721c839f0e4682aca3dc8f144e561809eadbd390eb2cbcbd9659462cf"
  end

  resource "isp-w13" do
    url "https://dl.bintray.com/apik/FMFT/isp-w13.tar.gz"
    sha256 "7095cad713e397c4392ea8283c24196c158563b5c919336f4fa4a36695bdd767"
  end

  resource "isp-w14" do
    url "https://dl.bintray.com/apik/FMFT/isp-w14.tar.gz"
    sha256 "9bbf9b2a78a2fef8eec50181dbfb95cba15451a4ef1aed9a36bfa3559a6fb964"
  end

  resource "isp-w15" do
    url "https://dl.bintray.com/apik/FMFT/isp-w15.tar.gz"
    sha256 "17a5d5dab2e90ebedd2d1750bf49c5987862ee14876fabb1ed19518c81dbfdeb"
  end

  resource "isp-w16" do
    url "https://dl.bintray.com/apik/FMFT/isp-w16.tar.gz"
    sha256 "bfb9d825ede9590081a16610cd3cf819de2b17131595bc3e16d755a545eda548"
  end

  resource "isp-w17" do
    url "https://dl.bintray.com/apik/FMFT/isp-w17.tar.gz"
    sha256 "2b3bd6826f5c7b174279f34d3c68c5bca99fee47a352b5e6c56be2e9b2b53cd0"
  end

  resource "isp-w18" do
    url "https://dl.bintray.com/apik/FMFT/isp-w18.tar.gz"
    sha256 "cb1cdb78ca9892f25a706a09b2658a4284c9eff2d1420f08b1f13b58cb0621f1"
  end

  resource "isp-w19" do
    url "https://dl.bintray.com/apik/FMFT/isp-w19.tar.gz"
    sha256 "676ff1e78d822708b0082aa561bd118b1b6b25585662f6394ca950da8f2c4438"
  end

  resource "isp-w20" do
    url "https://dl.bintray.com/apik/FMFT/isp-w20.tar.gz"
    sha256 "b7e8762663a35a4ed4383cb24e05b314823fddf8529ec1d51f97ac2158e26a1e"
  end

  def install
    max_weight = MIN_EXTRA_WEIGHT - 1
    (MIN_EXTRA_WEIGHT..MAX_EXTRA_WEIGHT).each do |i|
      max_weight = i if build.with?("weight" + i.to_s)
    end
    (MIN_EXTRA_WEIGHT..max_weight).each do |i|
      resource("isp-w#{i}").stage do
        mv Dir.glob("isp*"), buildpath/"isp"
      end
    end

    pkgformwrapper "fmft.hh", ["isp", "example.frm", "intG.tbl"]
  end

  def caveats; <<-EOS.undent
    #{formpath_message}
    EOS
  end

  test do
    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"example.frm"}")
          .lines.join
    assert_equal result(out, "ex"), expr("
       + ep^-4 * (
          - 967/1152
          )

       + ep^-3 * (
          - 75319/4608
          )

       + ep^-2 * (
          - 1132657/18432
          - 967/576*z2
          + 3593/64*S2
          )

       + ep^-1 * (
          - 19471361/221184
          + 3593/864*T1ep
          - 32203/2304*z2
          + 41749/256*S2
          + 10033/432*z3
          )

       + ep * (
          + 5646893693083/12899450880
          + 197/144*PR1ep1
          - 1621/1296*PR2ep1
          + 1369/864*PR3ep1
          - 23867/8640*PR4dep1
          + 1117/2880*PR4ep1
          + 2*PR6ep0
          + 29359/10368*T1ep2
          - 665/1296*PR7ep1
          - 2320283/1555200*PR4ep0
          - 314261/311040*PR4dep0
          + 35/96*PR8ep0
          + 269/216*PR10ep0
          - 224507/41472*T1ep
          - 1229235437/44789760*z2
          - 13190651/36864*S2
          + 29359/768*S2*z2
          - 3727949/82944*z4
          - 31104149/559872*z3
          - 569/432*Oep(1,PR6)
          - 53/216*Oep(1,PR8)
          - 395/432*Oep(1,PR10)
          - 5/144*Oep(2,PR1)
          + 5/288*Oep(2,PR2)
          - 13/48*Oep(2,PR3)
          + 13/288*Oep(2,PR4)
          + 65/288*Oep(2,PR4d)
          + 13/72*Oep(2,PR7)
          )

       + 79964242039/214990848
          - 5/144*PR1ep1
          + 5/288*PR2ep1
          - 13/48*PR3ep1
          + 65/288*PR4dep1
          + 13/288*PR4ep1
          - 569/432*PR6ep0
          - 22/27*T1ep2
          + 13/72*PR7ep1
          + 6689/12960*PR4ep0
          - 859/405*PR4dep0
          - 53/216*PR8ep0
          - 395/432*PR10ep0
          - 19841/3456*T1ep
          - 49574717/746496*z2
          - 1363279/3072*S2
          - 11*S2*z2
          - 347/216*z4
          - 16705811/233280*z3
    ")
  end
end
