class FormAT430 < Formula
  desc "Symbolic manipulation system for very big expressions"
  homepage "http://www.nikhef.nl/~form/"
  url "https://github.com/vermaseren/form/releases/download/v4.3.0/form-4.3.0.tar.gz"
  sha256 "b234e0d095f73ecb0904cdc3b0d8d8323a9fa7f46770a52fb22267c624aafbf6"

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
