From: akpm@linux-foundation.org
Subject: - mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:19:03 -0700
Message-ID: <200804300619.m3U6J3Yj031431@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755164AbYD3GTN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:19:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, greg@kroah.com, kay.sievers@vrfy.org, mszeredi@suse.cz, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix
has been removed from the -mm tree.  Its filename was
     mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch

This patch was dropped because it was folded into mm-bdi-export-bdi-attributes-in-sysfs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix
From: Andrew Morton <akpm@linux-foundation.org>

In file included from arch/ia64/ia32/sys_ia32.c:59:
arch/ia64/ia32/ia32priv.h:342:1: warning: "SET_PERSONALITY" redefined
In file included from include/linux/elf.h:7,
                 from include/linux/module.h:14,
                 from include/linux/device.h:21,
                 from include/linux/backing-dev.h:15,
                 from include/linux/nfs_fs_sb.h:5,
                 from include/linux/nfs_fs.h:50,
                 from arch/ia64/ia32/sys_ia32.c:35:
include/asm/elf.h:180:1: warning: this is the location of the previous definition

Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    2 +-
 readahead.c                 |    0 
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/ABI/testing/sysfs-class-bdi~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix Documentation/ABI/testing/sysfs-class-bdi
diff -puN block/genhd.c~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix block/genhd.c
diff -puN include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix include/linux/backing-dev.h
--- a/include/linux/backing-dev.h~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix
+++ a/include/linux/backing-dev.h
@@ -12,10 +12,10 @@
 #include <linux/log2.h>
 #include <linux/proportions.h>
 #include <linux/kernel.h>
-#include <linux/device.h>
 #include <asm/atomic.h>
 
 struct page;
+struct device;
 
 /*
  * Bits in backing_dev_info.state
diff -puN include/linux/writeback.h~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix include/linux/writeback.h
diff -puN lib/percpu_counter.c~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix lib/percpu_counter.c
diff -puN mm/backing-dev.c~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix mm/backing-dev.c
diff -puN mm/page-writeback.c~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix mm/page-writeback.c
diff -puN mm/readahead.c~mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix mm/readahead.c
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
isicom-bring-into-coding-style.patch
tty-the-big-operations-rework.patch
devpts-factor-out-pty-index-allocation.patch
mm-bdi-export-bdi-attributes-in-sysfs.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

