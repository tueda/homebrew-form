require "formula"

class Formula
  # FORM excutable for running tests.
  # Example: form
  def formbin
    ENV["FORM"] || "form"
  end

  # $FORMPATH for brewed form packages.
  # Example: /usr/local/share/form
  def formpath
    share/"#{HOMEBREW_PREFIX/"share/form"}"
  end

  # $FORMPATH for each form package, linked to "formpath".
  # Example: /usr/local/Cellar/form-foo/0.1/share/form
  def pkgformpath
    share/"form"
  end

  # A directory that may be used to place extra files for each package.
  # Example: /usr/local/Cellar/form-foo/0.1/share/form/foo
  def pkgpath
    pkgformpath/"#{name.sub(/form-/, "")}"
  end

  # Create a wrapper header file and install the library using a subdirectory.
  # This mechanism works when the library has only one main header file (with a
  # unique file name) expected to be included in user programs.
  def pkgformwrapper(header_file, other_files)
    other_files = [*other_files]
    pkgpath.install [header_file] + other_files
    include_guard_id = "#{name.gsub(/form-|-|_|\./, "").upcase}WRAPPERHFILE"
    (buildpath/header_file).write <<~EOS
      #ifndef `#{include_guard_id}'
      #define #{include_guard_id}
      #appendpath #{pkgpath}
      #include #{pkgpath}/#{header_file}
      #endif
    EOS
    pkgformpath.install header_file
  end

  # FORMPATH message for "caveats" of each formula.
  def formpath_message
    <<~EOS.chomp
      Add the following to your .bashrc or equivalent:
        export FORMPATH="#{HOMEBREW_PREFIX}/share/form:$FORMPATH"
    EOS
  end

  # Extract a printed expressions in FORM output.
  def result(output, exprname, index = -1)
    matches = output.scan(/^[ \t]+#{Regexp.escape(exprname)}\s*=(.+?);/m)
    r = matches[index].first if !matches.empty? && !matches[index].nil?
    r.gsub(/\s+/, "") if !r.nil?
  end

  # String representation of an expression to be compared with a return-value of
  # "result"
  def expr(str)
    str.gsub(/\s+/, "").chomp(";")
  end
end
