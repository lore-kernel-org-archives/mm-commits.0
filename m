From: akpm@linux-foundation.org
Subject: [merged] mm-exclude-duplicate-header.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:59 -0700
Message-ID: <5390ca9b.tgwmzNn6Lsw87VD8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56519 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaFETw7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, andriy.shevchenko@linux.intel.com

Subject: [merged] mm-exclude-duplicate-header.patch removed from -mm tree
To: andriy.shevchenko@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:59 -0700


The patch titled
     Subject: include/linux/gfp.h: exclude duplicate header
has been removed from the -mm tree.  Its filename was
     mm-exclude-duplicate-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: include/linux/gfp.h: exclude duplicate header

mmdebug.h is included twice.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/gfp.h~mm-exclude-duplicate-header include/linux/gfp.h
--- a/include/linux/gfp.h~mm-exclude-duplicate-header
+++ a/include/linux/gfp.h
@@ -6,7 +6,6 @@
 #include <linux/stddef.h>
 #include <linux/linkage.h>
 #include <linux/topology.h>
-#include <linux/mmdebug.h>
 
 struct vm_area_struct;
 
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch

