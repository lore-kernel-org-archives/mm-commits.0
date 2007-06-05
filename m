From: akpm@linux-foundation.org
Subject: - git-ioat-vs-git-md-accel.patch removed from -mm tree
Date: Mon, 04 Jun 2007 23:56:10 -0700
Message-ID: <200706050656.l556u8cv031037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36919 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755205AbXFEG4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 02:56:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christopher.leech@intel.com, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     git-ioat vs git-md-accel
has been removed from the -mm tree.  Its filename was
     git-ioat-vs-git-md-accel.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-ioat vs git-md-accel
From: Andrew Morton <akpm@osdl.org>

Fix reject due to clash between these two git trees.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioatdma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/dma/ioatdma.c~git-ioat-vs-git-md-accel drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~git-ioat-vs-git-md-accel
+++ a/drivers/dma/ioatdma.c
@@ -309,7 +309,7 @@ static dma_cookie_t do_ioat_dma_memcpy(s
 	list_splice_init(&new_chain, ioat_chan->used_desc.prev);
 
 	ioat_chan->pending += desc_count;
-	if (ioat_chan->pending >= 20) {
+	if (ioat_chan->pending >= 4) {
 		append = 1;
 		ioat_chan->pending = 0;
 	}
_

Patches currently in -mm which might be from akpm@osdl.org are

update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
git-qla3xxx.patch
git-ipwireless_cs.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
