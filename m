From: akpm@linux-foundation.org
Subject: - bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:30:34 -0800
Message-ID: <200802070030.m170UFod007367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758742AbYBGAoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@suse.de, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     BKL-removal: remove incorrect BKL comment in ext2
has been removed from the -mm tree.  Its filename was
     bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: BKL-removal: remove incorrect BKL comment in ext2
From: Andi Kleen <ak@suse.de>

No BKL used anywhere, so don't mention it.

Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/inode.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/ext2/inode.c~bkl-removal-remove-incorrect-bkl-comment-in-ext2 fs/ext2/inode.c
--- a/fs/ext2/inode.c~bkl-removal-remove-incorrect-bkl-comment-in-ext2
+++ a/fs/ext2/inode.c
@@ -569,7 +569,6 @@ static void ext2_splice_branch(struct in
  *
  * `handle' can be NULL if create == 0.
  *
- * The BKL may not be held on entry here.  Be sure to take it early.
  * return > 0, # of blocks mapped or allocated.
  * return = 0, if plain lookup failed.
  * return < 0, error case.
_

Patches currently in -mm which might be from ak@suse.de are

origin.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-jfs.patch
git-ocfs2.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
git-xfs.patch
modules-handle-symbols-that-have-a-zero-value.patch
modules-handle-symbols-that-have-a-zero-value-fix.patch
allow-executables-larger-than-2gb.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
remove-aout-interpreter-support-in-elf-loader.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
