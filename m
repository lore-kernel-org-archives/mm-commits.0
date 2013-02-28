From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-use-vm_unmapped_area-on-parisc-architecture-fix.patch removed from -mm tree
Date: Wed, 27 Feb 2013 16:37:28 -0800
Message-ID: <20130228003728.7907431C071@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:51884 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab3B1Ah3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 19:37:29 -0500
Received: by mail-qe0-f74.google.com with SMTP id 9so139006qea.3
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 16:37:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, deller@gmx.de, jejb@parisc-linux.org, riel@redhat.com, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-use-vm_unmapped_area-on-parisc-architecture-fix
has been removed from the -mm tree.  Its filename was
     mm-use-vm_unmapped_area-on-parisc-architecture-fix.patch

This patch was dropped because it was folded into mm-use-vm_unmapped_area-on-parisc-architecture.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-use-vm_unmapped_area-on-parisc-architecture-fix

remove now-unused DCACHE_ALIGN(), per James

Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Michel Lespinasse <walken@google.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/kernel/sys_parisc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/parisc/kernel/sys_parisc.c~mm-use-vm_unmapped_area-on-parisc-architecture-fix arch/parisc/kernel/sys_parisc.c
--- a/arch/parisc/kernel/sys_parisc.c~mm-use-vm_unmapped_area-on-parisc-architecture-fix
+++ a/arch/parisc/kernel/sys_parisc.c
@@ -46,8 +46,6 @@ static unsigned long get_unshared_area(u
 	return vm_unmapped_area(&info);
 }
 
-#define DCACHE_ALIGN(addr) (((addr) + (SHMLBA - 1)) &~ (SHMLBA - 1))
-
 /*
  * We need to know the offset to use.  Old scheme was to look for
  * existing mapping and use the same offset.  New scheme is to use the
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
backlight-add-new-lp8788-backlight-driver-checkpatch-fixes.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
signal-allow-to-send-any-siginfo-to-itself-fix.patch
fs-proc-clean-up-printks.patch
fs-proc-clean-up-printks-fix.patch
fs-proc-clean-up-printks-fix-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix.patch
fs-proc-vmcorec-put-if-tests-in-the-top-of-the-while-loop-to-reduce-duplication-fix-fix.patch
lockdep-check-that-no-locks-held-at-freeze-time-fix.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting.patch
fs-seq_filec-seq_lseek-fix-switch-statement-indenting-checkpatch-fixes.patch
idr-remove-length-restriction-from-idr_layer-bitmap-checkpatch-fixes.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
ensure-that-the-gpt-header-is-at-least-the-size-of-the-structure-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
selftests-add-tests-for-efivarfs-fix.patch
selftests-add-tests-for-efivarfs-fix-fix.patch
tools-testing-selftests-makefile-rearrange-targets.patch
selftests-add-a-simple-doc-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-checkpatch-fixes.patch
hlist-drop-the-node-parameter-from-iterators-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-fix-fix-fix-fix-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix.patch
hlist-drop-the-node-parameter-from-iterators-mlx4-fix-fix-fix.patch

