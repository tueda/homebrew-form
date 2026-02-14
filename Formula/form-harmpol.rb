require File.expand_path("../Library/form_lib", __dir__)

class FormHarmpol < Formula
  desc "FORM procedures and tables for the manipulation of HPLs"
  homepage "http://www.nikhef.nl/~form/maindir/packages/harmpol/harmpol.html"
  url "http://www.nikhef.nl/~form/maindir/packages/harmpol/harmpol.h"
  version "20070215"
  sha256 "79e506fc20ce2b2c955dd5d616b5968da2111b1f27b54ac1257c8e8d468aad9f"

  depends_on "form"
  depends_on "form-summer"

  resource "harmpolex" do
    url "http://www.nikhef.nl/~form/maindir/packages/harmpol/harmpolex.tar.gz"
    sha256 "c7c7465e331039ccfc9a7b4bdf7712549ec02134026dd6ac95697030e72aec86"
  end

  resource "htable7" do
    url "http://www.nikhef.nl/~form/maindir/packages/harmpol/htable7.prc.gz"
    sha256 "046f316522621e047ea7f773533318a05937bcbf81b736c4099caec330ab22da"
  end

  resource "htable8" do
    url "http://www.nikhef.nl/~form/maindir/packages/harmpol/htable8.prc.gz"
    sha256 "94a383f0c8f4dfe8b855f43739eb3243d3365278b31393bdd087392679d4be0a"
  end

  resource "htable9" do
    url "http://www.nikhef.nl/~form/maindir/packages/harmpol/htable9.prc.gz"
    sha256 "3b082b8e70ec61a8d621fdfdc571db4dcfc30872982100e74fda06dc8d5bf4f6"
  end

  def install
    pkgformpath.install "harmpol.h"

    resource("harmpolex").stage do
      pkgpath.install Dir.glob(["*.frm"])
    end

    resource("htable7").stage do
      pkgformpath.install "htable7.prc"
    end

    resource("htable8").stage do
      pkgformpath.install "htable8.prc"
    end

    resource("htable9").stage do
      pkgformpath.install "htable9.prc"
    end
  end

  def caveats; <<~EOS
    #{formpath_message}
    EOS
  end

  test do
    (testpath/"test.frm").write <<~EOS
      #include harmpol.h
      .global
      #call htables(6)
      CF int;
      L F1 = ln_(1+x)^2*ln_(1-x)^2*ln_(x)/x*int(x,0,1);
      id ln_(1+x) =  H(R(-1),x);
      id ln_(1-x) = -H(R(1),x);
      id ln_(x)   =  H(R(0),x);
      #call hbasis(H,x)
      id H(R(?a),x)/x*int(x,0,1) = H(R(0,?a),1)-H(R(0,?a),0);
      id H(R(?a,n?{1,-1},?b),0) = 0; * Provided there is a nonzero index
      #do i = 1,6
        id H(R(n1?,...,n`i'?),1) = Htab`i'(n1,...,n`i');
      #enddo
      P;
      .store
      L F2 = S(R(1,2,1,2),N);
      #call invmel(S,N,H,x)
      P;
      .end
    EOS
    out = pipe_output("#{formbin} -q -p #{formpath} test.frm").lines.join
    assert_equal result(out, "F1"), expr("
      2*s6 + 8*li6half + 8*ln2*li5half + 4*ln2^2*li4half + 1/9*ln2^6 - 31/8*z5
      *ln2 + 7/6*z3*ln2^3 - 37/16*z3^2 - 1/2*z2*ln2^4 - 129/140*z2^3;
    ")
    assert_equal result(out, "F2"), expr("
      1/2*z3^2 - 38/35*z2^3 - 1/2*H(R(1),x)*[1-x]^-1*z2^2 - H(R(1,2,1,0),x)*
      [1-x]^-1;
    ")
  end
end
