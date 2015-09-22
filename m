From: akpm@linux-foundation.org
Subject: [folded-merged]
 x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix.patch removed from
 -mm tree
Date: Tue, 22 Sep 2015 14:55:42 -0700
Message-ID: <5601ce5e.ajaAm9lW8sd2aFeX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbbIVVzn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Sep 2015 17:55:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix
has been removed from the -mm tree.  Its filename was
     x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix.patch

This patch was dropped because it was folded into x86-efi-kasan-undef-memset-memcpy-memmove-per-arch.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix

use 80 cols in comment

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/efi.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN arch/x86/include/asm/efi.h~x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix arch/x86/include/asm/efi.h
--- a/arch/x86/include/asm/efi.h~x86-efi-kasan-undef-memset-memcpy-memmove-per-arch-fix
+++ a/arch/x86/include/asm/efi.h
@@ -87,12 +87,10 @@ extern void __iomem *__init efi_ioremap(
 					u32 type, u64 attribute);
 
 /*
- * CONFIG_KASAN may redefine memset to __memset.
- * __memset function is present only in kernel binary.
- * Since the EFI stub linked into a separate binary it
- * doesn't have __memset(). So we should use standard
- * memset from arch/x86/boot/compressed/string.c
- * The same applies to memcpy and memmove.
+ * CONFIG_KASAN may redefine memset to __memset.  __memset function is present
+ * only in kernel binary.  Since the EFI stub linked into a separate binary it
+ * doesn't have __memset().  So we should use standard memset from
+ * arch/x86/boot/compressed/string.c.  The same applies to memcpy and memmove.
  */
 #undef memcpy
 #undef memset
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
x86-efi-kasan-undef-memset-memcpy-memmove-per-arch.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

