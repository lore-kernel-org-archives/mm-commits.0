From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 25 Jan 2011 15:00:49 -0800
Message-ID: <201101252300.p0PN0nCq013164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752905Ab1AYXBW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Jan 2011 18:01:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-fix-race-at-move_parent-around-compound_order.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#39: FILE: mm/memcontrol.c:2241:
+ ^I * will not handle this page. But page splitting can happen.$

WARNING: please, no space before tabs
#39: FILE: mm/memcontrol.c:2241:
+ ^I * will not handle this page. But page splitting can happen.$

ERROR: code indent should use tabs where possible
#40: FILE: mm/memcontrol.c:2242:
+ ^I * Do this check under compound_page_lock(). The caller should$

WARNING: please, no space before tabs
#40: FILE: mm/memcontrol.c:2242:
+ ^I * Do this check under compound_page_lock(). The caller should$

ERROR: code indent should use tabs where possible
#41: FILE: mm/memcontrol.c:2243:
+ ^I * hold it.$

WARNING: please, no space before tabs
#41: FILE: mm/memcontrol.c:2243:
+ ^I * hold it.$

ERROR: code indent should use tabs where possible
#42: FILE: mm/memcontrol.c:2244:
+ ^I */$

WARNING: please, no space before tabs
#42: FILE: mm/memcontrol.c:2244:
+ ^I */$

total: 4 errors, 4 warnings, 52 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/memcg-fix-race-at-move_parent-around-compound_order.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-race-at-move_parent-around-compound_order-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -2238,10 +2238,10 @@ static int mem_cgroup_move_account(struc
 	unsigned long flags;
 	/*
 	 * The page is isolated from LRU. So, collapse function
- 	 * will not handle this page. But page splitting can happen.
- 	 * Do this check under compound_page_lock(). The caller should
- 	 * hold it.
- 	 */
+	 * will not handle this page. But page splitting can happen.
+	 * Do this check under compound_page_lock(). The caller should
+	 * hold it.
+	 */
 	if ((charge_size > PAGE_SIZE) && !PageTransHuge(pc->page))
 		return -EBUSY;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-pgtable-genericc-fix-config_swap=n-build.patch
memcg-fix-race-at-move_parent-around-compound_order.patch
change-acquire-release_console_sem-to-console_lock-unlock.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
exec_domain-establish-a-linux32-domain-on-config_compat-systems.patch
scatterlist-new-helper-functions.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

