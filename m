From: akpm@linux-foundation.org
Subject: + documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch added to -mm tree
Date: Mon, 21 Mar 2011 16:25:59 -0700
Message-ID: <201103220001.p2M01Afi001974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157Ab1CVALR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 20:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, fengguang.wu@intel.com, gong.chen@linux.intel.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix
has been added to the -mm tree.  Its filename is
     documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

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
Subject: documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix
From: Andrew Morton <akpm@linux-foundation.org>

Fix debugfs_mount() signature.

Documentation/vm/page-types.c:537: warning: function declaration isn't a prototype

Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page-types.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/vm/page-types.c~documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix Documentation/vm/page-types.c
--- a/Documentation/vm/page-types.c~documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix
+++ a/Documentation/vm/page-types.c
@@ -533,7 +533,7 @@ static const char *debugfs_find_mountpoi
 
 /* mount the debugfs somewhere if it's not mounted */
 
-static void debugfs_mount()
+static void debugfs_mount(void)
 {
 	const char **ptr;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-asm-generic-unistdh-fix-syncfs-syscall-number.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
mm-vmap-area-cache.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag-checkpatch-fixes.patch
mm-use-__gfp_other_node-for-transparent-huge-pages-checkpatch-fixes.patch
drivers-misc-hmc6352c-fix-wrong-return-value-checking-for-i2c_master_recv-fix.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
calibrate-retry-with-wider-bounds-when-converge-seems-to-fail-fix.patch
kernel-watchdogc-allow-hardlockup-to-panic-by-default-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
fs-coda-fix-compile-warning-when-config_sysctl=n-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix.patch
documentation-vm-page-typesc-auto-debugfs-mount-for-hwpoison-operation-fix-fix.patch

