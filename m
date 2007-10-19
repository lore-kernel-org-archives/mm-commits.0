From: akpm@linux-foundation.org
Subject: - make-kernel-power-maincsuspend_enter-static.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:40:38 -0700
Message-ID: <200710190340.l9J3ec65012724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34045 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763967AbXJSD4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, pavel@ucw.cz, rjw@sisk.pl, mm-commits@vger.kernel.org


The patch titled
     make kernel/power/main.c:suspend_enter() static
has been removed from the -mm tree.  Its filename was
     make-kernel-power-maincsuspend_enter-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: make kernel/power/main.c:suspend_enter() static
From: Adrian Bunk <bunk@kernel.org>

suspend_enter() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/power/main.c~make-kernel-power-maincsuspend_enter-static kernel/power/main.c
--- a/kernel/power/main.c~make-kernel-power-maincsuspend_enter-static
+++ a/kernel/power/main.c
@@ -128,7 +128,7 @@ void __attribute__ ((weak)) arch_suspend
  *
  *	This function should be called after devices have been suspended.
  */
-int suspend_enter(suspend_state_t state)
+static int suspend_enter(suspend_state_t state)
 {
 	int error = 0;
 
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
git-dvb.patch
git-hwmon.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-scsi-misc.patch
drivers-net-wireless-b43-mainc-fix-an-uninitialized.patch
memory-controller-add-per-container-lru-and-reclaim-v7-cleanup.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-cleanup.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
