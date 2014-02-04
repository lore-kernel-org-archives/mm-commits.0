From: akpm@linux-foundation.org
Subject: [obsolete]
 documentation-sysctl-kerneltxt-s-hung_task_warning-hung_task_warnings.patch removed from -mm tree
Date: Mon, 03 Feb 2014 16:55:22 -0800
Message-ID: <52f03a7a.mqNzkOQ6W8q6IFE3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBDAzX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 19:55:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@elte.hu, atomlin@redhat.com, akpm@linux-foundation.org

Subject: [obsolete] documentation-sysctl-kerneltxt-s-hung_task_warning-hung_task_warnings.patch removed from -mm tree
To: akpm@linux-foundation.org,atomlin@redhat.com,mingo@elte.hu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 16:55:22 -0800


The patch titled
     Subject: Documentation/sysctl/kernel.txt: s/hung_task_warning/hung_task_warnings/
has been removed from the -mm tree.  Its filename was
     documentation-sysctl-kerneltxt-s-hung_task_warning-hung_task_warnings.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Documentation/sysctl/kernel.txt: s/hung_task_warning/hung_task_warnings/

Fix a documentation slipup.

Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-s-hung_task_warning-hung_task_warnings Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-s-hung_task_warning-hung_task_warnings
+++ a/Documentation/sysctl/kernel.txt
@@ -320,7 +320,7 @@ This file shows up if CONFIG_DETECT_HUNG
 
 ==============================================================
 
-hung_task_warning:
+hung_task_warnings:
 
 The maximum number of warnings to report. During a check interval
 When this value is reached, no more the warnings will be reported.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly-fix.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

