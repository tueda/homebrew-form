require File.expand_path("../Library/form_lib", __dir__)

class FormSummer < Formula
  desc "Package for harmonic sums"
  homepage "http://www.nikhef.nl/~form/maindir/packages/summer/summer.html"
  url "http://www.nikhef.nl/~form/maindir/packages/summer/summer.h.gz"
  version "20140325"
  sha256 "6699d592e92804dde143422d396d4eb7118129f7be38180e40d9cd1a22b8d71f"

  depends_on "form"

  resource "summerex" do
    url "http://www.nikhef.nl/~form/maindir/packages/summer/summerex.tar.gz"
    sha256 "0bde4a7c1dcd7a6e3b166e1ad3cf0d79ae8be197739cd341a9a7e7e6909a8268"
  end

  resource "table7" do
    url "http://www.nikhef.nl/~form/maindir/packages/summer/table7.prc.gz"
    sha256 "4887b530f7f8fa63238598154cb52b09919b5edcbb0d92d8ff8108a8ea6e1f62"
  end

  resource "table8" do
    url "http://www.nikhef.nl/~form/maindir/packages/summer/table8.prc.gz"
    sha256 "0d955c6e4ff9096baa84da9877ab382d5535b55d316c2fad954ab684275f80bc"
  end

  resource "table9" do
    url "http://www.nikhef.nl/~form/maindir/packages/summer/table9.prc.gz"
    sha256 "36f300878564abfcf55fef831e19968245d6ce2903f35284664297e3d2ce86e8"
  end

  def install
    pkgformpath.install "summer.h"

    resource("summerex").stage do
      pkgpath.install Dir.glob(["*.frm", "*.h"])
    end

    resource("table7").stage do
      pkgformpath.install "table7.prc"
    end

    resource("table8").stage do
      pkgformpath.install "table8.prc"
    end

    resource("table9").stage do
      pkgformpath.install "table9.prc"
    end
  end

  def caveats; <<~EOS
    #{formpath_message}
    EOS
  end

  test do
    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"test2.frm"}")
          .lines.join
    assert_equal result(out, "F"), expr("0")

    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"test4.frm"}")
          .lines.join
    assert_equal result(out, "F"), expr("
       - S(R(1,1,1,1,1,1,1),N)
    ")
  end
end
