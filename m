From: akpm@linux-foundation.org
Subject: [merged] maintainers-changed-ltp-maintainership-responsibilities.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:17 -0800
Message-ID: <201002121903.o1CJ3Hl7021110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab0BLTDv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:03:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: risrajak@linux.vnet.ibm.com, subrata@linux.vnet.ibm.com, vapier@gentoo.org, yanegomi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: changed LTP maintainership responsibilities
has been removed from the -mm tree.  Its filename was
     maintainers-changed-ltp-maintainership-responsibilities.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: changed LTP maintainership responsibilities
From: Rishikesh <risrajak@linux.vnet.ibm.com>

Change the LTP maintainer responsibities from 2010.

Ref: http://marc.info/?l=ltp-list&m=126502242912536&w=2

Signed-off-by : Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Garrett Cooper <yanegomi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN MAINTAINERS~maintainers-changed-ltp-maintainership-responsibilities MAINTAINERS
--- a/MAINTAINERS~maintainers-changed-ltp-maintainership-responsibilities
+++ a/MAINTAINERS
@@ -3411,8 +3411,10 @@ S:	Maintained
 F:	drivers/scsi/sym53c8xx_2/
 
 LTP (Linux Test Project)
-M:	Subrata Modak <subrata@linux.vnet.ibm.com>
-M:	Mike Frysinger <vapier@gentoo.org>
+M:	Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>
+M:	Garrett Cooper <yanegomi@gmail.com>
+M:     Mike Frysinger <vapier@gentoo.org>
+M:     Subrata Modak <subrata@linux.vnet.ibm.com>
 L:	ltp-list@lists.sourceforge.net (subscribers-only)
 W:	http://ltp.sourceforge.net/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/galak/ltp.git
_

Patches currently in -mm which might be from risrajak@linux.vnet.ibm.com are

origin.patch

