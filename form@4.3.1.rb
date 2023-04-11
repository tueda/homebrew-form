class FormAT431 < Formula
  desc "Symbolic manipulation system for very big expressions"
  homepage "http://www.nikhef.nl/~form/"
  url "https://github.com/vermaseren/form/releases/download/v4.3.1/form-4.3.1.tar.gz"
  sha256 "f1f512dc34fe9bbd6b19f2dfef05fcb9912dfb43c8368a75b796ec472ee8bbce"

  option "with-debug", "Build also the debug versions"
  option "without-test", "Skip build-time tests"
  option "with-mpich", "Build also the MPI versions with MPICH"
  option "with-open-mpi", "Build also the MPI versions with Open MPI"

  depends_on "zlib" => :recommended unless OS.mac?
  depends_on "gmp" => :recommended
  depends_on "mpich" => :optional
  depends_on "open-mpi" => :optional

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
    system "make"
    system "make", "check" if build.with? "test"
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
