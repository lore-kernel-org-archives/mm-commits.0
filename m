From: akpm@linux-foundation.org
Subject: +
 drivers-firmware-efi-libstub-efi-stub-helperc-needs-stringh.patch added to
 -mm tree
Date: Thu, 17 Sep 2015 12:37:55 -0700
Message-ID: <55fb1693.+EO4X5lugSHaOWzN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbbIQThz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Sep 2015 15:37:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/firmware/efi/libstub/efi-stub-helper.c needs string.h
has been added to the -mm tree.  Its filename is
     drivers-firmware-efi-libstub-efi-stub-helperc-needs-stringh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-firmware-efi-libstub-efi-stub-helperc-needs-stringh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-firmware-efi-libstub-efi-stub-helperc-needs-stringh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/firmware/efi/libstub/efi-stub-helper.c needs string.h

drivers/firmware/efi/libstub/efi-stub-helper.c: In function 'efi_relocate_kernel':
drivers/firmware/efi/libstub/efi-stub-helper.c:599:2: warning: implicit declaration of function 'memcpy' [-Wimplicit-function-declaration]

Cc: Fengguang Wu <fengguang.wu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/efi/libstub/efi-stub-helper.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/firmware/efi/libstub/efi-stub-helper.c~drivers-firmware-efi-libstub-efi-stub-helperc-needs-stringh drivers/firmware/efi/libstub/efi-stub-helper.c
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c~drivers-firmware-efi-libstub-efi-stub-helperc-needs-stringh
+++ a/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/efi.h>
+#include <linux/string.h>
 #include <asm/efi.h>
 
 #include "efistub.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
maintainers-update-ltp-mailing-list-fix.patch
drivers-firmware-efi-libstub-efi-stub-helperc-needs-stringh.patch
mm-dax-vma-with-vm_ops-pfn_mkwrite-wants-to-be-write-notified-fix.patch
revert-mm-make-sure-all-file-vmas-have-vm_ops-set.patch
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
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

