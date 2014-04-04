From: akpm@linux-foundation.org
Subject: [merged] mm-compactionc-mark-function-as-static.patch removed
 from -mm tree
Date: Fri, 04 Apr 2014 12:31:38 -0700
Message-ID: <533f089a.NXW8260ctsR40G8O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaDDTbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, riel@redhat.com, josh@joshtriplett.org, rashika.kheria@gmail.com

Subject: [merged] mm-compactionc-mark-function-as-static.patch removed from -mm tree
To: rashika.kheria@gmail.com,josh@joshtriplett.org,riel@redhat.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:31:38 -0700


The patch titled
     Subject: mm/compaction.c: mark function as static
has been removed from the -mm tree.  Its filename was
     mm-compactionc-mark-function-as-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rashika Kheria <rashika.kheria@gmail.com>
Subject: mm/compaction.c: mark function as static

Mark function as static in compaction.c because it is not used outside
this file.

This eliminates the following warning from mm/compaction.c:
mm/compaction.c:1190:9: warning: no previous prototype for `sysfs_compact_node' [-Wmissing-prototypes

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compactionc-mark-function-as-static mm/compaction.c
--- a/mm/compaction.c~mm-compactionc-mark-function-as-static
+++ a/mm/compaction.c
@@ -1235,7 +1235,7 @@ int sysctl_extfrag_handler(struct ctl_ta
 }
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_NUMA)
-ssize_t sysfs_compact_node(struct device *dev,
+static ssize_t sysfs_compact_node(struct device *dev,
 			struct device_attribute *attr,
 			const char *buf, size_t count)
 {
_

Patches currently in -mm which might be from rashika.kheria@gmail.com are

origin.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
linux-next.patch

