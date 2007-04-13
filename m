From: akpm@linux-foundation.org
Subject: - unused-round_up-name_offset-macro-in-arch-powerpc.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:41 -0700
Message-ID: <200704132328.l3DNSfEX012541@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60367 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161024AbXDMX2m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:28:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: milindchoudhary@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Unused ROUND_UP, NAME_OFFSET macro in arch/powerpc
has been removed from the -mm tree.  Its filename was
     unused-round_up-name_offset-macro-in-arch-powerpc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Unused ROUND_UP, NAME_OFFSET macro in arch/powerpc
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

Unused ROUND_UP, NAME_OFFSET  macro cleanup

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/sys_ppc32.c |    4 ----
 1 file changed, 4 deletions(-)

diff -puN arch/powerpc/kernel/sys_ppc32.c~unused-round_up-name_offset-macro-in-arch-powerpc arch/powerpc/kernel/sys_ppc32.c
--- a/arch/powerpc/kernel/sys_ppc32.c~unused-round_up-name_offset-macro-in-arch-powerpc
+++ a/arch/powerpc/kernel/sys_ppc32.c
@@ -53,10 +53,6 @@
 #include <asm/ppc-pci.h>
 #include <asm/syscalls.h>
 
-/* readdir & getdents */
-#define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
-#define ROUND_UP(x) (((x)+sizeof(u32)-1) & ~(sizeof(u32)-1))
-
 struct old_linux_dirent32 {
 	u32		d_ino;
 	u32		d_offset;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

git-powerpc.patch
spin_lock_unlocked-cleanup-in-arch-powerpc.patch
git-ieee1394.patch
spin_lock_unlocked-cleanup-in-drivers-ata-pata_winbondc.patch
round_up-macro-cleanup-in-drivers-net-ppp_genericc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
pcie-remove-spin_lock_unlocked.patch
round_up-macro-cleanup-in-arch-sh64-kernel-pci_sh5c.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
round_up-macro-cleanup-in-fs-selectcompatreaddirc.patch
round_up-macro-cleanup-in-fs-smbfs-requestc.patch
