From: akpm@linux-foundation.org
Subject: + mm-swap-token-fix-dead-link.patch added to -mm tree
Date: Fri, 03 Jun 2011 14:05:42 -0700
Message-ID: <201106032105.p53L5gc4007577@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab1FCVGU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2011 17:06:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com


The patch titled
     mm: swap-token: fix dead link
has been added to the -mm tree.  Its filename is
     mm-swap-token-fix-dead-link.patch

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
Subject: mm: swap-token: fix dead link
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

http://www.cs.wm.edu/~sjiang/token.pdf is now dead.  Replace it with an
alive alternative.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/thrash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/thrash.c~mm-swap-token-fix-dead-link mm/thrash.c
--- a/mm/thrash.c~mm-swap-token-fix-dead-link
+++ a/mm/thrash.c
@@ -6,7 +6,7 @@
  * Released under the GPL, see the file COPYING for details.
  *
  * Simple token based thrashing protection, using the algorithm
- * described in:  http://www.cs.wm.edu/~sjiang/token.pdf
+ * described in: http://www.cse.ohio-state.edu/hpcs/WWW/HTML/publications/abs05-1.html
  *
  * Sep 2006, Ashwin Chaugule <ashwin.chaugule@celunite.com>
  * Improved algorithm to pass token:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
slab-use-numa_no_node.patch
mm-swap-token-fix-dead-link.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch
kexec-remove-kmsg_dump_kexec-fix.patch

