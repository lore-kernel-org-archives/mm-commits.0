From: akpm@linux-foundation.org
Subject: [folded-merged]
 kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 08 Apr 2014 13:55:58 -0700
Message-ID: <5344625e.W5YSJZoUgrOpZaFI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHUz7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 16:55:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cl@linux.com, akpm@linux-foundation.org

Subject: [folded-merged] kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,cl@linux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 13:55:58 -0700


The patch titled
     Subject: kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch

This patch was dropped because it was folded into kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes

WARNING: line over 80 characters
#67: FILE: kernel/kmod.c:214:
+	 * Kthreadd can be restricted to a set of processors if the user wants to

WARNING: line over 80 characters
#69: FILE: kernel/kmod.c:216:
+	 * we do not want to disturb the other processors here either so we start

WARNING: line over 80 characters
#70: FILE: kernel/kmod.c:217:
+	 * the usermode helper threads only on the processors allowed for kthreadd.

total: 0 errors, 3 warnings, 44 lines checked

./patches/kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/kmod.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes kernel/kmod.c
--- a/kernel/kmod.c~kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes
+++ a/kernel/kmod.c
@@ -211,10 +211,11 @@ static int ____call_usermodehelper(void
 	spin_unlock_irq(&current->sighand->siglock);
 
 	/*
-	 * Kthreadd can be restricted to a set of processors if the user wants to
-	 * protect other processors from OS latencies. If that has happened then
-	 * we do not want to disturb the other processors here either so we start
-	 * the usermode helper threads only on the processors allowed for kthreadd.
+	 * Kthreadd can be restricted to a set of processors if the user wants
+	 * to protect other processors from OS latencies. If that has happened
+	 * then we do not want to disturb the other processors here either so we
+	 * start the usermode helper threads only on the processors allowed for
+	 * kthreadd.
 	 */
 	set_kthreadd_affinity();
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

