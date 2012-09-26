From: akpm@linux-foundation.org
Subject: + maintainers-update-intel-c600-sas-driver-maintainers.patch added to -mm tree
Date: Wed, 26 Sep 2012 15:14:03 -0700
Message-ID: <20120926221404.2FEEB5C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:52018 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2IZWOH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Sep 2012 18:14:07 -0400
Received: by wgbdt11 with SMTP id dt11so80199wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 26 Sep 2012 15:14:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dave.jiang@intel.com, lukasz.dorau@intel.com, maciej.patelczyk@intel.com


The patch titled
     Subject: MAINTAINERS: update Intel C600 SAS driver maintainers
has been added to the -mm tree.  Its filename is
     maintainers-update-intel-c600-sas-driver-maintainers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
maintainers-update-intel-c600-sas-driver-maintainers.patch

