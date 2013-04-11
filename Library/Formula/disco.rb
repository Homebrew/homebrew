require 'formula'

class Disco < Formula
  homepage 'http://discoproject.org/'
  url 'https://github.com/discoproject/disco/archive/0.4.5.tar.gz'
  sha1 'c098ad91aa1a0676944c5548f8f860fb9b223002'
  # Periods in the install path cause disco-worker to complain so change to underscores.
  version '0_4_5'

  depends_on 'erlang'
  depends_on 'simplejson' => :python if MacOS.version == :leopard
  depends_on 'libcmph'

  def patches
    # Modifies config for single-node operation
    DATA
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "prefix", prefix
      s.change_make_var! "sysconfdir", etc
      s.change_make_var! "localstatedir", var
    end

    # Support for setup.py, which is called from within the Makefile
    temp_site_packages = lib/which_python/'site-packages'
    mkdir_p temp_site_packages
    ENV['PYTHONPATH'] = temp_site_packages
    py_install_opts = "--verbose --force --install-scripts=#{bin} " +
      "--install-lib=#{temp_site_packages} --install-data=#{share} --install-headers=#{include}"

    # Disco's "rebar" build tool refuses to build unless it's in a git repo, so
    # make a dummy one
    system "git init && git add master/rebar && git commit -a -m 'dummy commit'"

    system "make"
    system "make install PY_INSTALL_OPTS='#{py_install_opts}'"
    prefix.install %w[contrib doc examples]

    # Fix the config file to point at the linked files, not in to cellar
    # This isn't ideal - if there's a settings.py file left over from a previous disco
    # installation, it'll issue a Warning
    inreplace "#{etc}/disco/settings.py" do |s|
      s.gsub!("Cellar/disco/"+version+"/", "")
    end

  end


  def which_python
    # Update this once we have something like [this](https://github.com/mxcl/homebrew/issues/11204)
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def caveats; <<-EOS.undent
    Disco is a Python script. You must install homebrew's python or add the path
      #{HOMEBREW_PREFIX}/lib/python2.7/site-packages
    to your PYTHONPATH before running disco or ddfs.

    Please copy #{etc}/disco/settings.py to ~/.disco and edit it if necessary.
    The DDFS_*_REPLICA settings have been set to 1 assuming a single-machine install.
    Please see http://discoproject.org/doc/disco/start/install.html for further instructions.
    EOS
  end
end

__END__
diff -rupN disco-0.4.5/conf/gen.settings.sh my-edits/disco-0.4.5/conf/gen.settings.sh
--- disco-0.4.5/conf/gen.settings.sh  2013-03-28 12:21:30.000000000 -0400
+++ my-edits/disco-0.4.5/conf/gen.settings.sh 2013-04-10 23:10:00.000000000 -0400
@@ -23,8 +23,11 @@ DISCO_PORT = 8989
 # DISCO_PROXY_ENABLED = "on"
 # DISCO_HTTPD = "/usr/sbin/varnishd -a 0.0.0.0:\$DISCO_PROXY_PORT -f \$DISCO_PROXY_CONFIG -P \$DISCO_PROXY_PID -n/tmp -smalloc"

-DDFS_TAG_MIN_REPLICAS = 3
-DDFS_TAG_REPLICAS     = 3
-DDFS_BLOB_REPLICAS    = 3
+# Settings appropriate for single-node operation
+DDFS_TAG_MIN_REPLICAS = 1
+DDFS_TAG_REPLICAS     = 1
+DDFS_BLOB_REPLICAS    = 1
+
+DISCO_MASTER_HOST     = "localhost"

 EOF
