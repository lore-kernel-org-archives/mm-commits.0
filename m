From: akpm@linux-foundation.org
Subject: [merged] mm-document-sys-devices-system-node-nodex.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:04:33 -0800
Message-ID: <201003091904.o29J4XIi031049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50640 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755639Ab0CITFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:05:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: document /sys/devices/system/node/nodeX
has been removed from the -mm tree.  Its filename was
     mm-document-sys-devices-system-node-nodex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: document /sys/devices/system/node/nodeX
From: Mel Gorman <mel@csn.ul.ie>

Add a bare description of what /sys/devices/system/node/nodeX is.  Others
will follow in time but right now, none of that tree is documented.  The
existence of this file might at least encourage people to document new
entries.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-devices-node |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN /dev/null Documentation/ABI/stable/sysfs-devices-node
--- /dev/null
+++ a/Documentation/ABI/stable/sysfs-devices-node
@@ -0,0 +1,7 @@
+What:		/sys/devices/system/node/nodeX
+Date:		October 2002
+Contact:	Linux Memory Management list <linux-mm@kvack.org>
+Description:
+		When CONFIG_NUMA is enabled, this is a directory containing
+		information on node X such as what CPUs are local to the
+		node.
_

Patches currently in -mm which might be from mel@csn.ul.ie are

page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

