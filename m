From: akpm@linux-foundation.org
Subject: + add-entries-to-maintainers-for-i-oat-and-dmaengine.patch added to -mm tree
Date: Wed, 11 Jul 2007 13:59:42 -0700
Message-ID: <200707112059.l6BKxghf016437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59978 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933525AbXGKU7u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 16:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shannon.nelson@intel.com, christopher.leech@intel.com


The patch titled
     Add entries to MAINTAINERS for I/OAT and DMAENGINE
has been added to the -mm tree.  Its filename is
     add-entries-to-maintainers-for-i-oat-and-dmaengine.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add entries to MAINTAINERS for I/OAT and DMAENGINE
From: "Nelson, Shannon" <shannon.nelson@intel.com>

Add entries to MAINTAINERS for I/OAT and DMAENGINE

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 files changed, 12 insertions(+)

diff -puN MAINTAINERS~add-entries-to-maintainers-for-i-oat-and-dmaengine MAINTAINERS
--- a/MAINTAINERS~add-entries-to-maintainers-for-i-oat-and-dmaengine
+++ a/MAINTAINERS
@@ -1277,6 +1277,12 @@ M:	tori@unhappy.mine.nu
 L:	netdev@vger.kernel.org
 S:	Maintained
 
+DMA GENERIC MEMCPY SUBSYSTEM
+P:	Shannon Nelson
+M:	shannon.nelson@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+
 DOCBOOK FOR DOCUMENTATION
 P:	Randy Dunlap
 M:	rdunlap@xenotime.net
@@ -1901,6 +1907,12 @@ P:	Tigran Aivazian
 M:	tigran@aivazian.fsnet.co.uk
 S:	Maintained
 
+INTEL I/OAT DMA DRIVER
+P:	Shannon Nelson
+M:	shannon.nelson@intel.com
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net
_

Patches currently in -mm which might be from shannon.nelson@intel.com are

add-entries-to-maintainers-for-i-oat-and-dmaengine.patch
git-md-accel.patch
ioat-warning-fix.patch
fix-i-oat-for-kexec.patch
