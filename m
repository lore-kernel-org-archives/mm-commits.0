From: akpm@linux-foundation.org
Subject: [folded-dropped] lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch removed from -mm tree
Date: Thu, 04 Oct 2012 16:58:12 -0700
Message-ID: <20121004235813.C72D55C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:58172 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab2JDX6Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Oct 2012 19:58:16 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so78159lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 04 Oct 2012 16:58:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, markivx@codeaurora.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix
has been removed from the -mm tree.  Its filename was
     lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch

This patch was dropped because it was folded into lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix

tweak comment

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vikram Mulukutla <markivx@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/spinlock_debug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN lib/spinlock_debug.c~lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix lib/spinlock_debug.c
--- a/lib/spinlock_debug.c~lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix
+++ a/lib/spinlock_debug.c
@@ -120,10 +120,10 @@ static void __spin_lock_debug(raw_spinlo
 #endif
 
 	/*
-	 * In case the trylock above was causing a livelock, give the lower
-	 * level arch specific lock code a chance to acquire the lock. We have
-	 * already printed a warning/backtrace at this point. The non-debug arch
-	 * specific code might actually succeed in acquiring the lock. If it is
+	 * The trylock above was causing a livelock.  Give the lower level arch
+	 * specific lock code a chance to acquire the lock. We have already
+	 * printed a warning/backtrace at this point. The non-debug arch
+	 * specific code might actually succeed in acquiring the lock.  If it is
 	 * not successful, the end-result is the same - there is no forward
 	 * progress.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
audith-replace-defines-with-c-stubs.patch
sections-fix-section-conflicts-in-arch-h8300.patch
sections-fix-section-conflicts-in-drivers-macintosh.patch
sectons-fix-const-sections-for-crc32-table.patch
backlight-add-backlight-driver-for-lm3630-chip.patch
backlight-add-new-lm3639-backlight-driver.patch
backlight-platform-lcd-add-support-for-device-tree-based-probe.patch
idr-rename-max_level-to-max_idr_level.patch
lib-parserc-avoid-overflow-in-match_number.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
rapidio-run-discovery-as-an-asynchronous-process-fix.patch

