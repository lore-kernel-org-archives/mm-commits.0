From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-sysctl-make-numa-stats-configurable-fix-fix.patch removed from -mm tree
Date: Tue, 17 Oct 2017 15:45:46 -0700
Message-ID: <59e6881a.VZ17jU6Z2zFpvX4j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58372 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755416AbdJQWpr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2017 18:45:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kemi.wang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-sysctl-make-numa-stats-configurable-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-sysctl-make-numa-stats-configurable-fix-fix.patch

This patch was dropped because it was folded into mm-sysctl-make-numa-stats-configurable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-sysctl-make-numa-stats-configurable-fix-fix

fix typo

Cc: Kemi Wang <kemi.wang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/vm.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-fix-fix Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~mm-sysctl-make-numa-stats-configurable-fix-fix
+++ a/Documentation/sysctl/vm.txt
@@ -853,7 +853,7 @@ ten times more freeable objects than the
 
 numa_stats_mode
 
-This interface allows runtime configuration or numa statistics.
+This interface allows runtime configuration of numa statistics.
 
 When page allocation performance becomes a bottleneck and you can tolerate
 some possible tool breakage and decreased numa counter precision, you can
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-swap-skip-swapcache-only-if-swapped-page-has-no-other-reference-checkpatch-fixes.patch
mm-sysctl-make-numa-stats-configurable.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
support-resetting-warn_once-checkpatch-fixes.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

