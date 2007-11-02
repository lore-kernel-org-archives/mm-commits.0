From: akpm@linux-foundation.org
Subject: + uml-fix-urls-in-kconfig-and-help-strings.patch added to -mm tree
Date: Fri, 02 Nov 2007 11:42:08 -0700
Message-ID: <200711021842.lA2Ig8QO005878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755693AbXKBSmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 14:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: magotari@gmail.com, jdike@linux.intel.com


The patch titled
     uml: fix URLs in Kconfig and help strings
has been added to the -mm tree.  Its filename is
     uml-fix-urls-in-kconfig-and-help-strings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix URLs in Kconfig and help strings
From: Karol Swietlicki <magotari@gmail.com>

This patch updates links which broke during the transition to the new UML
website.

Signed-off-by: Karol Swietlicki <magotari@gmail.com>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/Kconfig             |    2 +-
 arch/um/Kconfig.char        |    2 +-
 arch/um/Kconfig.debug       |    4 ++--
 arch/um/Kconfig.net         |   12 ++++++------
 arch/um/include/chan_user.h |    2 +-
 5 files changed, 11 insertions(+), 11 deletions(-)

diff -puN arch/um/Kconfig~uml-fix-urls-in-kconfig-and-help-strings arch/um/Kconfig
--- a/arch/um/Kconfig~uml-fix-urls-in-kconfig-and-help-strings
+++ a/arch/um/Kconfig
@@ -145,7 +145,7 @@ config HPPFS
 	  by removing or changing anything in /proc which gives away the
 	  identity of a UML.
 
-	  See <http://user-mode-linux.sf.net/hppfs.html> for more information.
+	  See <http://user-mode-linux.sf.net/old/hppfs.html> for more information.
 
 	  You only need this if you are setting up a UML honeypot.  Otherwise,
 	  it is safe to say 'N' here.
diff -puN arch/um/Kconfig.char~uml-fix-urls-in-kconfig-and-help-strings arch/um/Kconfig.char
--- a/arch/um/Kconfig.char~uml-fix-urls-in-kconfig-and-help-strings
+++ a/arch/um/Kconfig.char
@@ -18,7 +18,7 @@ config SSL
           lines on the UML that are usually made to show up on the host as
           ttys or ptys.
 
-          See <http://user-mode-linux.sourceforge.net/input.html> for more
+          See <http://user-mode-linux.sourceforge.net/old/input.html> for more
           information and command line examples of how to use this facility.
 
           Unless you have a specific reason for disabling this, say Y.
diff -puN arch/um/Kconfig.debug~uml-fix-urls-in-kconfig-and-help-strings arch/um/Kconfig.debug
--- a/arch/um/Kconfig.debug~uml-fix-urls-in-kconfig-and-help-strings
+++ a/arch/um/Kconfig.debug
@@ -9,7 +9,7 @@ config GPROF
 	  This allows profiling of a User-Mode Linux kernel with the gprof
 	  utility.
 
-	  See <http://user-mode-linux.sourceforge.net/gprof.html> for more
+	  See <http://user-mode-linux.sourceforge.net/old/gprof.html> for more
 	  details.
 
 	  If you're involved in UML kernel development and want to use gprof,
@@ -22,7 +22,7 @@ config GCOV
 	  This option allows developers to retrieve coverage data from a UML
 	  session.
 
-	  See <http://user-mode-linux.sourceforge.net/gprof.html> for more
+	  See <http://user-mode-linux.sourceforge.net/old/gprof.html> for more
 	  details.
 
 	  If you're involved in UML kernel development and want to use gcov,
diff -puN arch/um/Kconfig.net~uml-fix-urls-in-kconfig-and-help-strings arch/um/Kconfig.net
--- a/arch/um/Kconfig.net~uml-fix-urls-in-kconfig-and-help-strings
+++ a/arch/um/Kconfig.net
@@ -14,7 +14,7 @@ config UML_NET
 
         For more information, including explanations of the networking and
         sample configurations, see
-        <http://user-mode-linux.sourceforge.net/networking.html>.
+        <http://user-mode-linux.sourceforge.net/old/networking.html>.
 
         If you'd like to be able to enable networking in the User-Mode
         linux environment, say Y; otherwise say N.  Note that you must
@@ -38,7 +38,7 @@ config UML_NET_ETHERTAP
         CONFIG_NETLINK_DEV configured as Y or M.
 
         For more information, see
-        <http://user-mode-linux.sourceforge.net/networking.html>  That site
+        <http://user-mode-linux.sourceforge.net/old/networking.html>  That site
         has examples of the UML command line to use to enable Ethertap
         networking.
 
@@ -72,7 +72,7 @@ config UML_NET_SLIP
         To use this, your host must support slip devices.
 
         For more information, see
-        <http://user-mode-linux.sourceforge.net/networking.html>.  That site
+        <http://user-mode-linux.sourceforge.net/old/networking.html>.
         has examples of the UML command line to use to enable slip
         networking, and details of a few quirks with it.
 
@@ -96,7 +96,7 @@ config UML_NET_DAEMON
         networking daemon on the host.
 
         For more information, see
-        <http://user-mode-linux.sourceforge.net/networking.html>  That site
+        <http://user-mode-linux.sourceforge.net/old/networking.html>  That site
         has examples of the UML command line to use to enable Daemon
         networking.
 
@@ -144,7 +144,7 @@ config UML_NET_MCAST
         To use this, your host kernel(s) must support IP Multicasting.
 
         For more information, see
-        <http://user-mode-linux.sourceforge.net/networking.html>  That site
+        <http://user-mode-linux.sourceforge.net/old/networking.html>  That site
         has examples of the UML command line to use to enable Multicast
         networking, and notes about the security of this approach.
 
@@ -165,7 +165,7 @@ config UML_NET_PCAP
 	installed in order to build the pcap transport into UML.
 
         For more information, see
-        <http://user-mode-linux.sourceforge.net/networking.html>  That site
+        <http://user-mode-linux.sourceforge.net/old/networking.html>  That site
         has examples of the UML command line to use to enable this option.
 
 	If you intend to use UML as a network monitor for the host, say
diff -puN arch/um/include/chan_user.h~uml-fix-urls-in-kconfig-and-help-strings arch/um/include/chan_user.h
--- a/arch/um/include/chan_user.h~uml-fix-urls-in-kconfig-and-help-strings
+++ a/arch/um/include/chan_user.h
@@ -48,7 +48,7 @@ extern void register_winch_irq(int fd, i
 #define __channel_help(fn, prefix) \
 __uml_help(fn, prefix "[0-9]*=<channel description>\n" \
 "    Attach a console or serial line to a host channel.  See\n" \
-"    http://user-mode-linux.sourceforge.net/input.html for a complete\n" \
+"    http://user-mode-linux.sourceforge.net/old/input.html for a complete\n" \
 "    description of this switch.\n\n" \
 );
 
_

Patches currently in -mm which might be from magotari@gmail.com are

uml-remove-xmm-checking-on-x86.patch
uml-fix-urls-in-kconfig-and-help-strings.patch
uml-improve-detection-of-host-cmov.patch
uml-remove-now-unused-code.patch
