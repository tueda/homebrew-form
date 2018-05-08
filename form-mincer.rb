require File.expand_path("Library/form_lib", __dir__)

class FormMincer < Formula
  desc "Package for massless three loop propagator-like integrals"
  homepage "http://www.nikhef.nl/~form/maindir/packages/mincer/mincer.html"
  url "http://www.nikhef.nl/~form/maindir/packages/mincer/mincer.h"
  version "20070206"
  sha256 "a79a0f6319b353c55a11f7f17e8b3456a8f0eac4689231bc061df198d96b9887"

  depends_on "form"

  resource "testmincer1" do
    url "http://www.nikhef.nl/~form/maindir/packages/mincer/testmincer1.frm"
    sha256 "0f98ddeaeedb8c0c778332255fbb8c86f7aae6377ebc44ee202e27623d1a9e54"
  end

  resource "testmincer2" do
    url "http://www.nikhef.nl/~form/maindir/packages/mincer/testmincer2.frm"
    sha256 "417d480fef6d5f5f1d6358425a54cd42344762d592d94b72184d6df93155cd14"
  end

  def install
    pkgformpath.install "mincer.h"

    resource("testmincer1").stage do
      pkgpath.install "testmincer1.frm"
    end

    resource("testmincer2").stage do
      pkgpath.install "testmincer2.frm"
    end
  end

  def caveats; <<~EOS
    #{formpath_message}
    EOS
  end

  test do
    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"testmincer1.frm"}")
          .lines.join
    assert_equal result(out, "F"), expr("
       - 6695/5184 - 1/48*ep^-3 + 41/288*ep^-2 - 1541/6912*ep^-1 + 5/4*z5 - 1/
      6*z3;
    ")

    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"testmincer2.frm"}")
          .lines.join
    assert_equal result(out, "F"), expr("
       - 25/64 + 5/16*ep^-2 - 1/2*ep^-1 + 3/8*z3 - 49/16*ep + 9/16*ep*z4 + 33/
               4*ep*z3;
    ")
  end
end
