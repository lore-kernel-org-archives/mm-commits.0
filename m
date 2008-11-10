From: akpm@linux-foundation.org
Subject: - documentation-kernel-parameterstxt-update-isolcpus-kernel-option.patch removed from -mm tree
Date: Mon, 10 Nov 2008 12:32:53 -0800
Message-ID: <200811102032.mAAKWr9G024181@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285AbYKJUd1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Nov 2008 15:33:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/kernel-parameters.txt: update 'isolcpus' kernel option
has been removed from the -mm tree.  Its filename was
     documentation-kernel-parameterstxt-update-isolcpus-kernel-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/kernel-parameters.txt: update 'isolcpus' kernel option
From: Li Zefan <lizf@cn.fujitsu.com>

cpuset can be used to move a process onto or off an isolated CPU.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-update-isolcpus-kernel-option Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~documentation-kernel-parameterstxt-update-isolcpus-kernel-option
+++ a/Documentation/kernel-parameters.txt
@@ -995,13 +995,15 @@ and is between 256 and 4096 characters. 
 			Format:
 			<cpu number>,...,<cpu number>
 			or
-			<cpu number>-<cpu number>  (must be a positive range in ascending order)
+			<cpu number>-<cpu number>
+			(must be a positive range in ascending order)
 			or a mixture
 			<cpu number>,...,<cpu number>-<cpu number>
+
 			This option can be used to specify one or more CPUs
 			to isolate from the general SMP balancing and scheduling
-			algorithms. The only way to move a process onto or off
-			an "isolated" CPU is via the CPU affinity syscalls.
+			algorithms. You can move a process onto or off an
+			"isolated" CPU via the CPU affinity syscalls or cpuset.
 			<cpu number> begins at 0 and the maximum value is
 			"number of CPUs in system - 1".
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
freezer_cg-remove-task_lock-from-freezer_fork.patch
freezer_cg-disable-writing-freezerstate-of-root-cgroup.patch

