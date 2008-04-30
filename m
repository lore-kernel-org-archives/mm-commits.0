From: akpm@linux-foundation.org
Subject: - fuse-fix-race-in-llseek-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 23:23:37 -0700
Message-ID: <200804300623.m3U6NbV9031634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60546 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757229AbYD3GYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 02:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mszeredi@suse.cz, mm-commits@vger.kernel.org


The patch titled
     fuse-fix-race-in-llseek-fix
has been removed from the -mm tree.  Its filename was
     fuse-fix-race-in-llseek-fix.patch

This patch was dropped because it was folded into fuse-fix-race-in-llseek.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fuse-fix-race-in-llseek-fix
From: Andrew Morton <akpm@linux-foundation.org>

make `retval' loff_t

Cc: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fuse/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/fuse/file.c~fuse-fix-race-in-llseek-fix fs/fuse/file.c
--- a/fs/fuse/file.c~fuse-fix-race-in-llseek-fix
+++ a/fs/fuse/file.c
@@ -1433,7 +1433,7 @@ static sector_t fuse_bmap(struct address
 
 static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 {
-	long long retval;
+	loff_t retval;
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	mutex_lock(&inode->i_mutex);
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
fuse-fix-race-in-llseek.patch
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

