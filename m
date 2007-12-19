From: akpm@linux-foundation.org
Subject: + maintainers-mailing-list-archives-are-web-links.patch added to -mm tree
Date: Wed, 19 Dec 2007 15:50:02 -0800
Message-ID: <200712192350.lBJNo2KT025601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40597 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbXLSXvG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Dec 2007 18:51:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     MAINTAINERS:  mailing list archives are web links
has been added to the -mm tree.  Its filename is
     maintainers-mailing-list-archives-are-web-links.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 
@@ -2591,7 +2591,7 @@ S:	Maintained
 MSI LAPTOP SUPPORT
 P:	Lennart Poettering
 M:	mzxreary@0pointer.de
-L:	https://tango.0pointer.de/mailman/listinfo/s270-linux
+W:	https://tango.0pointer.de/mailman/listinfo/s270-linux
 W:	http://0pointer.de/lennart/tchibo.html
 S:	Maintained
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
maintainers-mailing-list-archives-are-web-links.patch
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
uml-add-missing-space.patch
