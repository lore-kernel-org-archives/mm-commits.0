From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-typo-in-memcg-documentation.patch removed from -mm tree
Date: Fri, 26 Mar 2010 12:36:06 -0400
Message-ID: <201003261937.o2QJb58d016576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32815 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab0CZThK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 15:37:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, balbir@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: fix typo in memcg documentation
has been removed from the -mm tree.  Its filename was
     memcg-fix-typo-in-memcg-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix typo in memcg documentation
From: Greg Thelen <gthelen@google.com>

Update memory.txt to be more consistent: s/swapiness/swappiness/

Signed-off-by: Greg Thelen <gthelen@google.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cgroups/memory.txt~memcg-fix-typo-in-memcg-documentation Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~memcg-fix-typo-in-memcg-documentation
+++ a/Documentation/cgroups/memory.txt
@@ -340,7 +340,7 @@ Note:
 5.3 swappiness
   Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
 
-  Following cgroups' swapiness can't be changed.
+  Following cgroups' swappiness can't be changed.
   - root cgroup (uses /proc/sys/vm/swappiness).
   - a cgroup which uses hierarchy and it has child cgroup.
   - a cgroup which uses hierarchy and not the root of hierarchy.
_

Patches currently in -mm which might be from gthelen@google.com are

origin.patch
linux-next.patch
sparsemem-on-no-vmemmap-path-put-mem_map-on-node-high-too.patch

