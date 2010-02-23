From: akpm@linux-foundation.org
Subject: + mm-document-sys-devices-system-node-nodex.patch added to -mm tree
Date: Mon, 22 Feb 2010 16:08:43 -0800
Message-ID: <201002230008.o1N08hFF032279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752433Ab0BWAKC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Feb 2010 19:10:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mel@csn.ul.ie, kosaki.motohiro@jp.fujitsu.com


The patch titled
     mm: document /sys/devices/system/node/nodeX
has been added to the -mm tree.  Its filename is
     mm-document-sys-devices-system-node-nodex.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
page-allocator-reduce-fragmentation-in-buddy-allocator-by-adding-buddies-that-are-merging-to-the-tail-of-the-free-lists.patch
vmscan-check-high-watermark-after-shrink-zone.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-page_allocc-remove-duplicate-call-to-trace_mm_page_free_direct.patch
mm-page_allocc-adjust-a-call-site-to-trace_mm_page_free_direct.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-fix-mbind-vma-merge-problem.patch
mm-fix-mbind-vma-merge-problem-fix.patch
mm-suppress-pfn-range-output-for-zones-without-pages.patch
mm-document-proc-pagetypeinfo.patch
mm-document-sys-devices-system-node-nodex.patch
nodemaskh-remove-macro-any_online_node.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
add-debugging-aid-for-memory-initialisation-problems.patch

