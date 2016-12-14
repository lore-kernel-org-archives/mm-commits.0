From: akpm@linux-foundation.org
Subject: [merged] scripts-checkpatchpl-fix-spelling.patch removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:50 -0800
Message-ID: <58519d36.VS9TldMcx6RfGM1V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45858 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756316AbcLNT3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/checkpatch.pl: fix spelling
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-fix-spelling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: scripts/checkpatch.pl: fix spelling

s/preceeded/preceded/

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-fix-spelling scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-fix-spelling
+++ a/scripts/checkpatch.pl
@@ -5925,7 +5925,7 @@ sub process {
 			}
 			if (!$has_break && $has_statement) {
 				WARN("MISSING_BREAK",
-				     "Possible switch case/default not preceeded by break or fallthrough comment\n" . $herecurr);
+				     "Possible switch case/default not preceded by break or fallthrough comment\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
ipc-sem-simplify-wait-wake-loop-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

