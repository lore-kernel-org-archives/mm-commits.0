From: akpm@linux-foundation.org
Subject: - spin_lock_unlocked-cleanup-in-arch-mips.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:52:15 -0700
Message-ID: <200704281052.l3SAqFR5020033@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031115AbXD1KwW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:52:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     SPIN_LOCK_UNLOCKED cleanup in arch/mips
has been removed from the -mm tree.  Its filename was
     spin_lock_unlocked-cleanup-in-arch-mips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPIN_LOCK_UNLOCKED cleanup in arch/mips
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

SPIN_LOCK_UNLOCKED cleanup,use DEFINE_SPINLOCK instead

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/basler/excite/excite_setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/mips/basler/excite/excite_setup.c~spin_lock_unlocked-cleanup-in-arch-mips arch/mips/basler/excite/excite_setup.c
--- a/arch/mips/basler/excite/excite_setup.c~spin_lock_unlocked-cleanup-in-arch-mips
+++ a/arch/mips/basler/excite/excite_setup.c
@@ -63,7 +63,7 @@ volatile void __iomem * const ocd_base =
 volatile void __iomem * const titan_base = (void *) (EXCITE_ADDR_TITAN);
 
 /* Protect access to shared GPI registers */
-spinlock_t titan_lock = SPIN_LOCK_UNLOCKED;
+DEFINE_SPINLOCK(titan_lock);
 int titan_irqflags;
 
 
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

origin.patch
git-alsa.patch
git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
spin_lock_unlocked-macro-cleanup-in-arch-ia64.patch
git-ieee1394.patch
git-jfs.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
git-netdev-all.patch
nfs-use-__set_current_state.patch
git-ocfs2.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
spin_lock_unlocked-cleanup-in-arch-m68k.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
spin_lock_unlocked-cleanup-in-init_taskh.patch
spin_lock_unlocked-cleanup-in-drivers-char-keyboard.patch
spin_lock_unlocked-cleanup-in-drivers-serial.patch
reiserfs-use-__set_current_state.patch
drivers-char-use-__set_current_state.patch
