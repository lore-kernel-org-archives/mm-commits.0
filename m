From: akpm@linux-foundation.org
Subject: [merged] gcov-maintainers-add-an-entry-for-gcov.patch removed
 from -mm tree
Date: Thu, 17 Oct 2013 11:13:03 -0700
Message-ID: <526028af.XUgnvJUn9nf4oH7g%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3JQSND (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, oberpar@linux.vnet.ibm.com

Subject: [merged] gcov-maintainers-add-an-entry-for-gcov.patch removed from -mm tree
To: oberpar@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:03 -0700


The patch titled
     Subject: gcov: MAINTAINERS: Add an entry for gcov
has been removed from the -mm tree.  Its filename was
     gcov-maintainers-add-an-entry-for-gcov.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
gcov-add-support-for-gcc-47-gcov-format-fix-3.patch

