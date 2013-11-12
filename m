From: akpm@linux-foundation.org
Subject: [folded-merged]
 gcov-add-support-for-gcc-47-gcov-format-fix-3.patch removed from -mm tree
Date: Tue, 12 Nov 2013 14:45:23 -0800
Message-ID: <5282af83.3wyF+H9eK+l6IHVJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60990 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab3KLWpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:45:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fhrbata@redhat.com, oberpar@linux.vnet.ibm.com

Subject: [folded-merged] gcov-add-support-for-gcc-47-gcov-format-fix-3.patch removed from -mm tree
To: oberpar@linux.vnet.ibm.com,fhrbata@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:45:23 -0800


The patch titled
     Subject: gcov-add-support-for-gcc-47-gcov-format-fix-3
has been removed from the -mm tree.  Its filename was
     gcov-add-support-for-gcc-47-gcov-format-fix-3.patch

This patch was dropped because it was folded into gcov-add-support-for-gcc-47-gcov-format.patch

------------------------------------------------------
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: gcov-add-support-for-gcc-47-gcov-format-fix-3

gcc_4_7.c needs vmalloc.h

Cc: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix-3 kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix-3
+++ a/kernel/gcov/gcc_4_7.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include "gcov.h"
 
 #define GCOV_COUNTERS			8
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

gcov-add-support-for-gcc-47-gcov-format.patch

