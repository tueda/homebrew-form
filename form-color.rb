require File.expand_path("../Library/form_lib", __FILE__)

class FormColor < Formula
  desc "Package for calculating color group coefficients"
  homepage "http://www.nikhef.nl/~form/maindir/packages/color/color.html"
  url "http://www.nikhef.nl/~form/maindir/packages/color/color.h"
  version "20090807"
  sha256 "616e225880fda51c5e1d37b8730a520b1994f05d70713e7e8b2fca2e2ab3fd00"

  depends_on "form"

  resource "color" do
    url "http://www.nikhef.nl/~form/maindir/packages/color/color.tar.gz"
    sha256 "f648fd368a03c0d7237f40ed42768095d7cc84f47009af61ddc4d421392f46f5"
  end

  def install
    pkgformpath.install "color.h"

    resource("color").stage do
      pkgpath.install Dir.glob(["*.frm", "*.prc"])
    end
  end

  def caveats; <<~EOS
    #{formpath_message}
    EOS
  end

  test do
    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"tloop.frm"}")
          .lines.join
    assert_equal result(out, "girth14"), expr("
       + 1/648*NA*cA^7
       - 8/15*d444(cOlpA1,cOlpA2,cOlpA3)*cA
       + 16/9*d644(cOlpA1,cOlpA2,cOlpA3)
    ")
  end
end
