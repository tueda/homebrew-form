require File.expand_path("Library/form_lib", __dir__)

class FormForcer < Formula
  desc "FORM program for four-loop massless propagator diagrams"
  homepage "https://github.com/benruijl/forcer"
  url "https://github.com/benruijl/forcer/archive/v1.0.0.tar.gz"
  sha256 "b2bf47591bfef313c233b4afab575d6b06d7943b183768206d2fee300b5e3f2c"

  depends_on "form"

  def install
    # Put the example into forcer/examples.
    Dir.mkdir "examples"
    mv "example.frm", "examples"
    mv "examples", "forcer"

    pkgformpath.install ["forcer.h", "forcer"]
  end

  def caveats; <<~EOS
    #{formpath_message}
    EOS
  end

  test do
    out = pipe_output("#{formbin} -q -p #{formpath} #{pkgpath/"examples/example.frm"}")
          .lines.join
    assert_equal result(out, "F"), expr("
       + ep^-3 * (
          + 1/24
          )

       + ep^-2 * (
          + 25/72
          )

       + ep^-1 * (
          + 433/216
          )

       + ep * (
          + 89089/1944
          - 57/32*z4
          - 725/72*z3
          )

       + 6457/648
          + 115/24*z3
    ")
  end
end
