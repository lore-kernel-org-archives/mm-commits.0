From: akpm@linux-foundation.org
Subject: [merged] mm-swap-token-fix-dead-link.patch removed from -mm tree
Date: Tue, 26 Jul 2011 00:52:31 -0700
Message-ID: <201107260751.p6Q7pY1A002960@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752431Ab1GZHwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jul 2011 03:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: swap-token: fix dead link
has been removed from the -mm tree.  Its filename was
     mm-swap-token-fix-dead-link.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch
slab-use-numa_no_node.patch
memcg-export-memory-cgroups-swappiness-with-mem_cgroup_swappiness.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
proc-pid-fdinfo-add-cloexec-information.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
cpumask-convert-for_each_cpumask-with-for_each_cpu.patch
cpumask-alloc_cpumask_var-use-numa_no_node.patch
cpumask-add-cpumask_var_t-documentation.patch
kexec-remove-kmsg_dump_kexec.patch

