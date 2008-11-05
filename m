From: akpm@linux-foundation.org
Subject: + documentation-kernel-parameterstxt-update-isolcpus-kernel-option.patch added to -mm tree
Date: Wed, 05 Nov 2008 12:04:43 -0800
Message-ID: <200811052004.mA5K4hcn027573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbYKEUEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Nov 2008 15:04:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com


The patch titled
     Documentation/kernel-parameters.txt: update 'isolcpus' kernel option
has been added to the -mm tree.  Its filename is
     documentation-kernel-parameterstxt-update-isolcpus-kernel-option.patch

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

cgroups-fix-invalid-cgrp-dentry-before-cgroup-has-been-completely-removed.patch
documentation-kernel-parameterstxt-update-isolcpus-kernel-option.patch

