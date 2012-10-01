From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-intel-c600-sas-driver-maintainers.patch removed from -mm tree
Date: Mon, 01 Oct 2012 12:28:39 -0700
Message-ID: <20121001192840.1FDFE5C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:63667 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab2JAT2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:28:42 -0400
Received: by faet1 with SMTP id t1so384206fae.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:28:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.jiang@intel.com, lukasz.dorau@intel.com, maciej.patelczyk@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update Intel C600 SAS driver maintainers
has been removed from the -mm tree.  Its filename was
     maintainers-update-intel-c600-sas-driver-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jiang <dave.jiang@intel.com>
Subject: MAINTAINERS: update Intel C600 SAS driver maintainers

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-intel-c600-sas-driver-maintainers MAINTAINERS
--- a/MAINTAINERS~maintainers-update-intel-c600-sas-driver-maintainers
+++ a/MAINTAINERS
@@ -3581,11 +3581,12 @@ K:	\b(ABS|SYN)_MT_
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
+M:	Lukasz Dorau <lukasz.dorau@intel.com>
+M:	Maciej Patelczyk <maciej.patelczyk@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
-M:	Ed Nadolski <edmund.nadolski@intel.com>
 L:	linux-scsi@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git
-S:	Maintained
+T:	git git://git.code.sf.net/p/intel-sas/isci
+S:	Supported
 F:	drivers/scsi/isci/
 F:	firmware/isci/
 
_

Patches currently in -mm which might be from dave.jiang@intel.com are

linux-next.patch

