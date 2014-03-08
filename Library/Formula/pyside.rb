require 'formula'

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'https://download.qt-project.org/official_releases/pyside/pyside-qt4.8+1.2.1.tar.bz2'
  mirror 'https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.1.tar.bz2'
  sha1 'eec5bed37647dd8d3d1c7a610ad913312dd55910'

  head 'git://gitorious.org/pyside/pyside.git'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  if !Formula["python"].installed? && build.with?("python") &&
     build.with?("python3")
    odie <<-EOS.undent
      pyside: You cannot use system Python 2 and Homebrew's Python 3 simultaneously.
      Either `brew install python` or use `--without-python3`.
    EOS
  elsif build.without?("python3") && build.without?("python")
    odie "pyside: --with-python3 must be specified when using --without-python"
  end

  depends_on 'cmake' => :build
  depends_on 'qt'

  # if build.with? 'python3'
  #   if build.without? 'python'
  #     depends_on 'shiboken' => ['with-python3', 'without-python']
  #   else
  #     depends_on 'shiboken' => 'with-python3'
  #   end
  # else
  #   depends_on 'shiboken'
  # end

  def pythons
    pythons = []
    ["python", "python3"].each do |python|
      next if build.without? python
      version = /\d\.\d/.match `#{python} --version 2>&1`
      pythons << [python, version]
    end
    pythons
  end

  def patches
    DATA  # Fix moc_qpytextobject.cxx not found (https://codereview.qt-project.org/62479)
  end

  def install
    # Add out of tree build because one of its deps, shiboken, itself needs an
    # out of tree build in shiboken.rb.
    pythons.each do |python, version|
      ohai "Install for Python #{version}"
      mkdir "macbuild#{version}" do
        qt = Formula["qt"].opt_prefix
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/python#{version}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
          -DQT_SRC_DIR=#{qt}/src
        ]
        if version.to_s[0,1] == '2'
          args << "-DPYTHON_SUFFIX=-python#{version}"
        else
          python_suffix=".cpython-#{version.to_s[0,1]}#{version.to_s[2,3]}m"
          args << "-DPYTHON_SUFFIX=#{python_suffix}"
          args << "-DUSE_PYTHON3=1"
        end
        args << '..'
        system 'cmake', *args
        system 'make'
        system 'make', 'install'
      end
    end
  end

  test do
    pythons.each do |python, version|
      unless Formula[python].installed?
        ENV["PYTHONPATH"] = HOMEBREW_PREFIX/"lib/python#{version}/site-packages"
      end
      system python, '-c', "from PySide import QtCore"
    end
  end
end

__END__
diff --git a/PySide/QtGui/CMakeLists.txt b/PySide/QtGui/CMakeLists.txt
index 7625634..6e14706 100644
--- a/PySide/QtGui/CMakeLists.txt
+++ b/PySide/QtGui/CMakeLists.txt
@@ -403,7 +403,6 @@ ${CMAKE_CURRENT_BINARY_DIR}/PySide/QtGui/qwizard_wrapper.cpp
 ${CMAKE_CURRENT_BINARY_DIR}/PySide/QtGui/qworkspace_wrapper.cpp

 ${SPECIFIC_OS_FILES}
-${QPYTEXTOBJECT_MOC}
 ${QtGui_46_SRC}
 ${QtGui_47_SRC}
 ${QtGui_OPTIONAL_SRC}
@@ -434,7 +433,7 @@ create_pyside_module(QtGui
                      QtGui_deps
                      QtGui_typesystem_path
                      QtGui_SRC
-                     ""
+                     QPYTEXTOBJECT_MOC
                      ${CMAKE_CURRENT_BINARY_DIR}/typesystem_gui.xml)

 install(FILES ${pyside_SOURCE_DIR}/qpytextobject.h DESTINATION include/PySide/QtGui/)
