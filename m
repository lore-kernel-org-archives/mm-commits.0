From: akpm@linux-foundation.org
Subject: - maintainers-mailing-list-archives-are-web-links.patch removed from -mm tree
Date: Mon, 07 Jan 2008 13:39:14 -0800
Message-ID: <200801072138.m07LcsWa013511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48787 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbYAGVja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2008 16:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS:  mailing list archives are web links
has been removed from the -mm tree.  Its filename was
     maintainers-mailing-list-archives-are-web-links.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS:  mailing list archives are web links
From: Joe Perches <joe@perches.com>

L: entries should be email addresses
Change L:http entries to W:http

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-mailing-list-archives-are-web-links MAINTAINERS
--- a/MAINTAINERS~maintainers-mailing-list-archives-are-web-links
+++ a/MAINTAINERS
@@ -2029,7 +2029,7 @@ P:	James Ketrenos
 M:	jketreno@linux.intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
-L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
+W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2100.sourceforge.net
 S:	Supported
 
@@ -2040,7 +2040,7 @@ P:	James Ketrenos
 M:	jketreno@linux.intel.com
 L:	linux-wireless@vger.kernel.org
 L:	ipw2100-devel@lists.sourceforge.net
-L:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
+W:	http://lists.sourceforge.net/mailman/listinfo/ipw2100-devel
 W:	http://ipw2200.sourceforge.net
 S:	Supported
 
@@ -2597,7 +2597,7 @@ S:	Maintained
 MSI LAPTOP SUPPORT
 P:	Lennart Poettering
 M:	mzxreary@0pointer.de
-L:	https://tango.0pointer.de/mailman/listinfo/s270-linux
+W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 
_

Patches currently in -mm which might be from joe@perches.com are

git-alsa.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-hwmon.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
git-net.patch
git-netdev-all.patch
git-selinux.patch
git-s390.patch
git-sh.patch
git-x86.patch
uml-add-missing-space.patch
printk_ratelimit-functions-should-use-config_printk.patch
maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources.patch
