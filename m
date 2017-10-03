From: akpm@linux-foundation.org
Subject: [folded-merged]
 scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch
 removed from -mm tree
Date: Tue, 03 Oct 2017 16:08:21 -0700
Message-ID: <59d41865.vG0XHju0nr5E0+8M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58232 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751090AbdJCXIX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 19:08:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, colin.king@canonical.com, joe@perches.com, keescook@chromium.org, ross.zwisler@linux.intel.com, sboyd@codeaurora.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix.patch

This patch was dropped because it was folded into scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix

s/|/||/, per Joe

Cc: Colin Ian King <colin.king@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/spelling.txt~scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt-fix
+++ a/scripts/spelling.txt
@@ -492,7 +492,7 @@ failied||failed
 faillure||failure
 failue||failure
 failuer||failure
-failng|failing
+failng||failing
 faireness||fairness
 falied||failed
 faliure||failure
@@ -1118,7 +1118,7 @@ swithced||switched
 swithcing||switching
 swithed||switched
 swithing||switching
-swtich|switch
+swtich||switch
 symetric||symmetric
 synax||syntax
 synchonized||synchronized
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
scripts-spellingtxt-add-more-spelling-mistakes-to-spellingtxt.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
of-provide-of_n_addrsize_cells-wrappers-for-config_of-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
include-linux-sched-mmh-uninline-mmdrop_async-etc.patch
mm-sysctl-make-numa-stats-configurable-fix.patch
mm-sysctl-make-numa-stats-configurable-fix-fix.patch
mm-mmu_notifier-avoid-double-notification-when-it-is-useless-checkpatch-fixes.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix.patch
mm-swap-fix-race-conditions-in-swap_slots-cache-init-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

