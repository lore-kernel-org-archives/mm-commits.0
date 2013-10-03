From: akpm@linux-foundation.org
Subject: + gcov-maintainers-add-an-entry-for-gcov.patch added to -mm tree
Date: Thu, 03 Oct 2013 16:19:09 -0700
Message-ID: <524dfb6d.u+lPf0+akUYk3OnR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3JCXTJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Oct 2013 19:19:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oberpar@linux.vnet.ibm.com

Subject: + gcov-maintainers-add-an-entry-for-gcov.patch added to -mm tree
To: oberpar@linux.vnet.ibm.com
From: akpm@linux-foundation.org
Date: Thu, 03 Oct 2013 16:19:09 -0700


The patch titled
     Subject: gcov: MAINTAINERS: Add an entry for gcov
has been added to the -mm tree.  Its filename is
     gcov-maintainers-add-an-entry-for-gcov.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-maintainers-add-an-entry-for-gcov.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-maintainers-add-an-entry-for-gcov.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: gcov: MAINTAINERS: Add an entry for gcov

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~gcov-maintainers-add-an-entry-for-gcov MAINTAINERS
--- a/MAINTAINERS~gcov-maintainers-add-an-entry-for-gcov
+++ a/MAINTAINERS
@@ -3624,6 +3624,12 @@ L:	linux-scsi@vger.kernel.org
 S:	Odd Fixes (e.g., new signatures)
 F:	drivers/scsi/fdomain.*
 
+GCOV BASED KERNEL PROFILING
+M:	Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
+S:	Maintained
+F:	kernel/gcov/
+F:	Documentation/gcov.txt
+
 GDT SCSI DISK ARRAY CONTROLLER DRIVER
 M:	Achim Leubner <achim_leubner@adaptec.com>
 L:	linux-scsi@vger.kernel.org
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

gcov-maintainers-add-an-entry-for-gcov.patch
gcov-add-support-for-gcc-47-gcov-format-fix-3.patch

