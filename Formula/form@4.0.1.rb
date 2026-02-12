class FormAT401 < Formula
  desc "Symbolic manipulation system for very big expressions"
  homepage "http://www.nikhef.nl/~form/"
  url "https://github.com/vermaseren/form.git", :tag => "v4.0-20120410"
  version "4.0.1"
  patch :DATA

  option "with-debug", "Build also the debug versions"
  option "without-test", "Skip build-time tests"
  option "with-mpich", "Build also the MPI versions with MPICH"
  option "with-open-mpi", "Build also the MPI versions with Open MPI"

  depends_on "zlib" => :recommended unless OS.mac?
  depends_on "gmp" => :recommended
  depends_on "mpich" => :optional
  depends_on "open-mpi" => :optional
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def normalize_flags(flags)
    # Don't use optimization flags given by Homebrew.
    return flags if flags.nil?
    a = flags.split(" ")
    a.delete_if do |item|
      item == "-Os" || item == "-w"
    end
    a.join(" ")
  end

  def install
    ENV["CFLAGS"] = normalize_flags(ENV["CFLAGS"])
    ENV["CXXFLAGS"] = normalize_flags(ENV["CXXFLAGS"])
    system "autoreconf", "-i"
    args = [
      "--prefix=#{prefix}",
      "--program-suffix=-#{version}",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
    ]
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-parform" if build.with?("open-mpi") || build.with?("mpich")
    args << "--without-gmp" if build.without? "gmp"
    system "./configure", *args
    system "make", "DATE=Apr 10 2012"
    # NOTE: The test suite depends on Linux strace.
    system "make", "check" if build.with?("test") && OS.linux?
    system "make", "install"
  end

  test do
    (testpath/"test.frm").write <<~EOS
      Off stats;
      Off finalstats;
      Off totalsize;
      On highfirst;
      Symbols a, b;
      Local F = (a + b)^2;
      Print;
      .end
    EOS
    result = <<-EOS

   F =
      a^2 + 2*a*b + b^2;

    EOS
    assert_equal result, pipe_output("#{bin}/form-#{version} -q test.frm")
  end
end
__END__
diff --git a/check/form.rb b/check/form.rb
index 2c5d87e..8253a41 100644
--- a/check/form.rb
+++ b/check/form.rb
@@ -35,7 +35,7 @@ def cleanup_tempfiles
 end
 
 # determine OS we are running on
-osname = Config::CONFIG["target_os"]
+osname = RbConfig::CONFIG["target_os"]
 if osname =~ /linux/
 	LINUX = true
 elsif osname =~ /mswin32/
diff --git a/configure.ac b/configure.ac
index 09d1044..27b68da 100644
--- a/configure.ac
+++ b/configure.ac
@@ -11,7 +11,7 @@ AC_INIT([FORM], FORM_VERSION, [form@nikhef.nl])
 AC_CONFIG_SRCDIR([sources/form3.h])
 AC_CONFIG_HEADERS([config.h])
 
-AM_INIT_AUTOMAKE([gnu 1.7 dist-bzip2])
+AM_INIT_AUTOMAKE([1.13 foreign -Wall dist-bzip2 serial-tests])
 
 AC_DEFINE(MAJORVERSION, FORM_MAJORVERSION, [Major version of FORM.])
 AC_DEFINE(MINORVERSION, FORM_MINORVERSION, [Minor version of FORM.])
