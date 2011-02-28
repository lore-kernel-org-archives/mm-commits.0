From: akpm@linux-foundation.org
Subject: [folded] cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch removed from -mm tree
Date: Mon, 28 Feb 2011 15:24:26 -0800
Message-ID: <201102282324.p1SNORiX003723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41452 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753635Ab1B1XZC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Feb 2011 18:25:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lizf@cn.fujitsu.com, menage@google.com, miaox@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpuset-fix-unchecked-calls-to-nodemask_alloc-fix
has been removed from the -mm tree.  Its filename was
     cpuset-fix-unchecked-calls-to-nodemask_alloc-fix.patch

This patch was dropped because it was folded into cpuset-fix-unchecked-calls-to-nodemask_alloc.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset-fix-unchecked-calls-to-nodemask_alloc-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix comment spelling, strengthen cgroup_lock comment

Cc: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpuset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc-fix kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-fix-unchecked-calls-to-nodemask_alloc-fix
+++ a/kernel/cpuset.c
@@ -80,11 +80,11 @@ struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
 /*
- * In functions that can't propogate errno to users, to avoid declaring a
+ * In functions that can't propagate errno to users, to avoid declaring a
  * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
  * -ENOMEM, we use this global cpuset_mems.
  *
- * It should be used with cgroup_lock held.
+ * It must called under cgroup_lock().
  */
 static nodemask_t cpuset_mems;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-vmap-area-cache.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-convert-bd2802-driver-to-dev_pm_ops-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
backlight-add-backlight-type-fix.patch
backlight-add-backlight-type-fix-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
drbd-fix-warning.patch
mm.patch
mm-allow-gup-to-fail-instead-of-waiting-on-a-page-fix.patch
mm-batch-free-pcp-list-if-possible-fix.patch
pagewalk-only-split-huge-pages-when-necessary-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
arch-alpha-include-asm-ioh-s-extern-inline-static-inline.patch
kernel-cpuc-fix-many-errors-related-to-style-fix.patch
lib-vsprintf-optimised-put_dec-function-fix.patch
epoll-fix-compiler-warning-and-optimize-the-non-blocking-path.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
cpuset-fix-unchecked-calls-to-nodemask_alloc.patch
scatterlist-new-helper-functions.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix.patch
crash_dump-export-is_kdump_kernel-to-modules-consolidate-elfcorehdr_addr-setup_elfcorehdr-and-saved_max_pfn-fix-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

