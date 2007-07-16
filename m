From: akpm@linux-foundation.org
Subject: - add-entries-to-maintainers-for-i-oat-and-dmaengine.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:10 -0700
Message-ID: <200707162048.l6GKmAqF001015@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXGPUsU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 16:48:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shannon.nelson@intel.com, christopher.leech@intel.com, mm-commits@vger.kernel.org


The patch titled
     Add entries to MAINTAINERS for I/OAT and DMAENGINE
has been removed from the -mm tree.  Its filename was
     add-entries-to-maintainers-for-i-oat-and-dmaengine.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add entries to MAINTAINERS for I/OAT and DMAENGINE
From: "Nelson, Shannon" <shannon.nelson@intel.com>

Add entries to MAINTAINERS for I/OAT and DMAENGINE

Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN MAINTAINERS~add-entries-to-maintainers-for-i-oat-and-dmaengine MAINTAINERS
--- a/MAINTAINERS~add-entries-to-maintainers-for-i-oat-and-dmaengine
+++ a/MAINTAINERS
@@ -1276,6 +1276,12 @@ M:	tori@unhappy.mine.nu
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
@@ -1900,6 +1906,12 @@ P:	Tigran Aivazian
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

origin.patch
