From: akpm@linux-foundation.org
Subject: + bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch added to -mm tree
Date: Sat, 02 Feb 2008 11:27:31 -0800
Message-ID: <200802021927.m12JRCoi013130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48883 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757223AbYBBT1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 2 Feb 2008 14:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@suse.de, tytso@mit.edu


The patch titled
     BKL-removal: remove incorrect BKL comment in ext2
has been added to the -mm tree.  Its filename is
     bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
serial-keep-the-dtr-setting-for-serial-console.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
pci-disable-decoding-during-sizing-of-bars.patch
x86-validate-against-acpi-motherboard-resources.patch
git-x86.patch
x86-amd-thermal-interrupt-support.patch
x86-clear-pci_mmcfg_virt-when-mmcfg-get-rejected.patch
x86-mmconf-enable-mcfg-early.patch
x86-mmconf-enable-mcfg-early-cleanup.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-check-msr-to-get-mmconfig-for-amd-family-10h-opteron-v3.patch
x86_64-set-cfg_size-for-amd-family-10h-in-case-mmconfig-is-used.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
iommu-sg-x86-convert-calgary-iommu-to-use-the-iommu-helper.patch
iommu-sg-x86-convert-gart-iommu-to-use-the-iommu-helper.patch
iommu-sg-kill-__clear_bit_string-and-find_next_zero_string.patch
git-xfs.patch
swapin_readahead-excise-numa-bogosity.patch
remove-unused-arguments-in-zone_init_free_lists.patch
read_current_time-cleanups.patch
add-hpet-rtc-emulation-to-rtc_drv_cmos.patch
bkl-removal-convert-ext2-over-to-use-unlocked_ioctl.patch
bkl-removal-remove-incorrect-bkl-comment-in-ext2.patch
bkl-removal-remove-incorrect-comment-refering-to-lock_kernel-from-jbd-jbd2.patch
modules-handle-symbols-that-have-a-zero-value.patch
allow-executables-larger-than-2gb.patch
bkl-removal-convert-pipe-to-use-unlocked_ioctl-too.patch
remove-aout-interpreter-support-in-elf-loader.patch
convert-loglevel-related-kernel-boot-parameters-to-early_param.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
