require File.expand_path("../Library/form_lib", __FILE__)

class FormFmft < Formula
  desc "Fully Massive Four-loop Tadpoles"
  homepage "https://github.com/apik/fmft/"
  url "https://github.com/apik/fmft/archive/1.0.tar.gz"
  sha256 "479ccceba4ac60700a31477319c362a46edd09a2130838a95bcd42960e9b00b2"
  head "https://github.com/apik/fmft.git"

  depends_on "form"

  def install
    pkgpath.install ["example.frm", "fmft.pdf"]
    pkgformpath.install "fmft.hh"
  end

  def caveats; <<~EOS
    #{formpath_message}
    EOS
  end

  test do
    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"example.frm"}")
          .lines.join
    assert_equal result(out, "ex"), expr("
       + ep^-2 * (
          + 3/4*z3
          )

       + ep^-1 * (
          - 3/8*z4
          + 1/2*D6
          + 1/4*z3
          )

       + ep * (
          - 1416545/41472
          + 11/12*PR3ep1
          + 55/24*PR4dep1
          - 11/40*PR4ep1
          - 1/6*PR6ep0
          + 3/8*T1ep2
          + 1/6*PR7ep1
          + 47/48*PR4ep0
          + 235/48*PR4dep0
          + 1/2*PR8ep0
          + 1/4*PR9dep1
          + 1/4*PR9ep0
          - 2/3*PR10ep0
          + 7/48*T1ep
          - 3373/576*z2
          - 1575/64*S2
          + 81/16*S2*z2
          + 1/2*PR14ep0
          - 153/64*z4
          - 703/72*z3
          - 1/4*PR15ep0
          + 1/6*Oep(1,PR6)
          - 1/2*Oep(1,PR8)
          + 1/3*Oep(1,PR10)
          - 1/4*Oep(1,PR14)
          + 1/2*Oep(1,PR15)
          )

       + 1576909/15552
          + 1/6*PR6ep0
          - 7/6*T1ep2
          - 19/60*PR4ep0
          + 25/12*PR4dep0
          - 1/2*PR8ep0
          + 1/4*PR9dep0
          + 1/3*PR10ep0
          - 15/4*T1ep
          + 11131/216*z2
          - 927/8*S2
          - 63/4*S2*z2
          - 1/4*PR14ep0
          + 8*z4
          - 1/4*D6
          - 133/72*z3
          + 1/2*PR15ep0
    ")
  end
end
