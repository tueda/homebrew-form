require File.expand_path("Library/form_lib", __dir__)

class FormXsummer < Formula
  desc "Package for transcendental functions and symbolic summation"
  homepage "https://www-zeuthen.desy.de/~moch/xsummer/index.html"
  url "https://www-zeuthen.desy.de/~moch/xsummer/XSummer1.0.tar.gz"
  version "1.1"
  sha256 "4ce02d472911d6d3e11fa11c3d352bea64784319bcf23b6bec3541630d726ae6"

  depends_on "form"

  resource "srcv1.1" do
    url "https://www-zeuthen.desy.de/~moch/xsummer/srcv1.1.tar.gz"
    sha256 "7ab6da95f6d05a43f99931f7346c680fd3bb3da9fc938b611e4b17418f50cffd"
  end

  def install
    header_file = "xsummer.h"
    include_guard_id = "XSUMMERWRAPPERHFILE"
    (buildpath/header_file).write <<~EOS
      #ifndef `#{include_guard_id}'
      #define #{include_guard_id}
      #appendpath #{pkgpath}/src
      #appendpath #{pkgpath}/summer
      #endif
    EOS
    pkgformpath.install header_file
    pkgpath.install "summer", "examples"
    
    resource("srcv1.1").stage do
      (pkgpath/"src").install Dir.glob(["*.h", "*.prc"])
    end
  end

  def caveats; <<~EOS
    An auxiliary wrapper file xsummer.h is generated, which does #appendpath for necessary paths.

    #{formpath_message}
    EOS
  end

  test do
    (testpath/"test.frm").write <<~EOS
      #include xsummer.h
      #define MAXSUM "1"
      #define MAXWEIGHT "20"
      #include declvars.h
      nwrite stat;
      L demo = sum(j1,1,n) * bino(n,j1) * pow(-x1,j1) * den(j1+1)
      * S(R(1,1),X(x2,x3),j1+1);
      id bino(x1?,x2?) = fac(x1)*invfac(x2)*invfac(x1-x2);
      #call DoSum(1,1)
      print;
      .end;
    EOS
    out = pipe_output("#{formbin} -q -p #{formpath} test.frm").lines.join
    assert_equal result(out, "demo"), expr("
      + acc(-1)*pow(1 - x1,1 + n)*den( - x1)*den(1 + n)
      *S(R(1,1),X(den(1 - x1) - den(1 - x1)*x1*x2,den(1 - x1*x2))
      ,1 + n)*theta( - 1 + n)+ acc(1)*pow(1 - x1,1 + n)*den( - x1)
      *den(1 + n)*S(R(1,1),X(den(1 - x1)- den(1 - x1)*x1*x2,
      den(1 - x1*x2) - den(1 - x1*x2)*x1*x2*x3),1 + n)*theta( - 1 + n)
      + acc(1)*den( - x1)*theta( - 1 + n)*x1*x2*x3
    ")
  end
end
