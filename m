From: akpm@linux-foundation.org
Subject: [folded] documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch removed from -mm tree
Date: Tue, 22 Mar 2011 16:08:51 -0700
Message-ID: <201103222308.p2MN8p4C000753@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754436Ab1CVXIy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Mar 2011 19:08:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix
has been removed from the -mm tree.  Its filename was
     documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch

This patch was dropped because it was folded into documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix
From: Andrew Morton <akpm@linux-foundation.org>

make functions static

Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/vm/page-types.c~documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix
+++ a/Documentation/vm/page-types.c
@@ -483,7 +483,7 @@ static uint64_t kpageflags_flags(uint64_
 }
 
 /* verify that a mountpoint is actually a debugfs instance */
-int debugfs_valid_mountpoint(const char *debugfs)
+static int debugfs_valid_mountpoint(const char *debugfs)
 {
 	struct statfs st_fs;
 
@@ -496,7 +496,7 @@ int debugfs_valid_mountpoint(const char 
 }
 
 /* find the path to the mounted debugfs */
-const char *debugfs_find_mountpoint(void)
+static const char *debugfs_find_mountpoint(void)
 {
 	const char **ptr;
 	char type[100];
@@ -533,7 +533,7 @@ const char *debugfs_find_mountpoint(void
 
 /* mount the debugfs somewhere if it's not mounted */
 
-void debugfs_mount()
+static void debugfs_mount()
 {
 	const char **ptr;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page.patch
mm-batch-free-pcp-list-if-possible.patch
pagewalk-only-split-huge-pages-when-necessary.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv.patch
kernel-cpuc-fix-many-errors-related-to-style.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

