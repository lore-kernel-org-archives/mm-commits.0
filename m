From: akpm@linux-foundation.org
Subject: + sync_inode_metadata-fix-comment.patch added to -mm tree
Date: Thu, 04 Nov 2010 15:39:17 -0700
Message-ID: <201011042240.oA4Meqk3010159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753289Ab0KDWlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Nov 2010 18:41:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hch@lst.de


The patch titled
     sync_inode_metadata: fix comment
has been added to the -mm tree.  Its filename is
     sync_inode_metadata-fix-comment.patch

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
Subject: sync_inode_metadata: fix comment
From: Andrew Morton <akpm@linux-foundation.org>

Use correct function name, remove incorrect apostrophe

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/fs-writeback.c~sync_inode_metadata-fix-comment fs/fs-writeback.c
--- a/fs/fs-writeback.c~sync_inode_metadata-fix-comment
+++ a/fs/fs-writeback.c
@@ -1205,11 +1205,11 @@ int sync_inode(struct inode *inode, stru
 EXPORT_SYMBOL(sync_inode);
 
 /**
- * sync_inode - write an inode to disk
+ * sync_inode_metadata - write an inode to disk
  * @inode: the inode to sync
  * @wait: wait for I/O to complete.
  *
- * Write an inode to disk and adjust it's dirty state after completion.
+ * Write an inode to disk and adjust its dirty state after completion.
  *
  * Note: only writes the actual inode, no associated data or other metadata.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
hpet-factor-timer-allocate-from-open.patch
linux-next.patch
next-remove-localversion.patch
arch-x86-kernel-entry_64s-fix-build-with-gas-2161.patch
arch-x86-kernel-entry_32s-i386-too.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-misc-isl29020c-dont-ignore-the-i2c_smbus_read_byte_data-return-value.patch
drivers-misc-bh1770glcc-error-handling-in-bh1770_power_state_store.patch
mm-vmap-area-cache.patch
arch-x86-kernel-apic-io_apicc-fix-warning.patch
gcc-46-btrfs-clean-up-unused-variables-bugs.patch
drivers-gpu-drm-radeon-atomc-fix-warning.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-add-led-trigger-for-input-subsystem-led-events.patch
backlight-add-low-threshold-to-pwm-backlight.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode-fix.patch
drivers-message-fusion-mptsasc-fix-warning.patch
mm.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds-fix.patch
sync_inode_metadata-fix-comment.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch
pps-add-async-pps-event-handler-fix.patch
memstick-add-driver-for-ricoh-r5c592-card-reader-fix.patch
journal_add_journal_head-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

