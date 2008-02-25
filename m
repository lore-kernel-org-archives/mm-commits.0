From: akpm@linux-foundation.org
Subject: - cpuset-trivial-documentation-fix-s-n_memory-n_high_memory.patch removed from -mm tree
Date: Sun, 24 Feb 2008 16:44:49 -0800
Message-ID: <200802250044.m1P0ineS006138@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36489 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754336AbYBYAsr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 24 Feb 2008 19:48:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, clameter@sgi.com, menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
has been removed from the -mm tree.  Its filename was
     cpuset-trivial-documentation-fix-s-n_memory-n_high_memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: trivial documentation fix s/N_MEMORY/N_HIGH_MEMORY/
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Current implementation of cpuset track N_HIGH_MEMORY instead N_MEMORY. 
(N_MEMORY doesn't exist in current implementation)

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/cpusets.txt~cpuset-trivial-documentation-fix-s-n_memory-n_high_memory Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpuset-trivial-documentation-fix-s-n_memory-n_high_memory
+++ a/Documentation/cpusets.txt
@@ -209,7 +209,7 @@ and name space for cpusets, with a minim
 The cpus and mems files in the root (top_cpuset) cpuset are
 read-only.  The cpus file automatically tracks the value of
 cpu_online_map using a CPU hotplug notifier, and the mems file
-automatically tracks the value of node_states[N_MEMORY]--i.e.,
+automatically tracks the value of node_states[N_HIGH_MEMORY]--i.e.,
 nodes with memory--using the cpuset_track_online_nodes() hook.
 
 
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are
