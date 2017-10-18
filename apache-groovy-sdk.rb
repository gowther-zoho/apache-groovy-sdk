class ApacheGroovySdk < Formula
  desc "Groovy SDK: A multi-faceted language for the Java platform"
  homepage "http://groovy-lang.org"
  url "https://dl.bintray.com/groovy/maven/apache-groovy-sdk-2.4.12.zip"
  sha256 "2dea0d021d74184ca2659f964d88b7e7c849e9e694b74289da682834f425bbb0"

  bottle :unneeded

  option "with-invokedynamic", "Install the InvokeDynamic version of Groovy (only works with Java 1.7+)"

  conflicts_with "groovy", :because => "both install the same binaries"
  conflicts_with "groovysdk", :because => "both install the same binaries"

  def install
    # We don't need Windows files
    rm_f Dir["bin/*.bat"]

    if build.with? "invokedynamic"
      Dir.glob("indy/*.jar") do |src_path|
        dst_file = File.basename(src_path, "-indy.jar") + ".jar"
        dst_path = File.join("lib", dst_file)
        mv src_path, dst_path
      end
    end

    libexec.install %w[bin conf lib embeddable src doc]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<-EOS
    You should set GROOVY_HOME:
      export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
