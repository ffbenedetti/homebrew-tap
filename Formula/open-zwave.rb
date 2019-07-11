class OpenZwave < Formula
  desc "Library that interfaces with selected Z-Wave PC controllers"
  homepage "http://www.openzwave.com"
  url "https://github.com/OpenZWave/open-zwave/archive/v1.6.tar.gz"
  sha256 "3b11dffa7608359c8c848451863e0287e17f5f101aeee7c2e89b7dc16f87050b"

  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  
  def install
    ENV["BUILD"] = "release"
    ENV["PREFIX"] = prefix

    # https://github.com/Homebrew/homebrew-core/pull/22486/files#r160018571
    # https://github.com/OpenZWave/open-zwave/issues/1416
    ENV["pkgconfigdir"] = "#{lib}/pkgconfig"

    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <openzwave/Manager.h>
      int main()
      {
        return OpenZWave::Manager::getVersionAsString().empty();
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}/openzwave",
                    "-L#{lib}", "-lopenzwave", "-o", "test"
    system "./test"
  end
end
