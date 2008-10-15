From: akpm@linux-foundation.org
Subject: - gru-driver-minor-updates-fix.patch removed from -mm tree
Date: Wed, 15 Oct 2008 16:59:55 -0700
Message-ID: <200810152359.m9FNxtjQ024793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbYJOX77 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 19:59:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru-driver-minor-updates-fix
has been removed from the -mm tree.  Its filename was
     gru-driver-minor-updates-fix.patch

This patch was dropped because it was folded into gru-driver-minor-updates.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru-driver-minor-updates-fix
From: Andrew Morton <akpm@linux-foundation.org>

Jcak cnat tpye.

Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufault.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/misc/sgi-gru/grufault.c~gru-driver-minor-updates-fix drivers/misc/sgi-gru/grufault.c
--- a/drivers/misc/sgi-gru/grufault.c~gru-driver-minor-updates-fix
+++ a/drivers/misc/sgi-gru/grufault.c
@@ -214,16 +214,14 @@ static int non_atomic_pte_lookup(struct 
 }
 
 /*
- *
  * atomic_pte_lookup
  *
  * Convert a user virtual address to a physical address
  * Only supports Intel large pages (2MB only) on x86_64.
  *	ZZZ - hugepage support is incomplete
  *
- * NOTE; mmap_sem is already held on entry to this function. This
- * guarantees existence of the apge tables.
- *
+ * NOTE: mmap_sem is already held on entry to this function. This
+ * guarantees existence of the page tables.
  */
 static int atomic_pte_lookup(struct vm_area_struct *vma, unsigned long vaddr,
 	int write, unsigned long *paddr, int *pageshift)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation.patch
make-taint-bit-reliable-v3.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday.patch
allow-recursion-in-binfmt_script-and-binfmt_misc.patch
autofs4-track-uid-and-gid-of-last-mount-requester.patch
autofs4-add-miscellaneous-device-for-ioctls.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip.patch
viafb-accelc-accelh.patch
viafb-dvic-dvih-globalc-and-globalh.patch
viafb-hwc-hwh.patch
viafb-viafbdevc-viafbdevh.patch
fbdev-kconfig-update.patch
fbdev-allow-more-chip-revisions-in-epson-s1d13-video-driver.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-new-driver-ds2431-chip.patch
gru-driver-minor-updates.patch
gru-driver-minor-updates-fix.patch

