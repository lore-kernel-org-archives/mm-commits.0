From: akpm@linux-foundation.org
Subject: +
 powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch added to -mm tree
Date: Thu, 25 Aug 2016 14:28:58 -0700
Message-ID: <57bf631a.UX3A9FrHDQhltTai%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58812 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753453AbcHYVhv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Aug 2016 17:37:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bauerman@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch

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
Subject: powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes

WARNING: please, no space before tabs
#57: FILE: arch/powerpc/kernel/machine_kexec_64.c:692:
+ * ^I^I^Ibe none.$

WARNING: line over 80 characters
#151: FILE: arch/powerpc/kernel/machine_kexec_64.c:786:
+			ret = fdt_delprop(fdt, chosen_node, "linux,initrd-start");

WARNING: line over 80 characters
#232: FILE: arch/powerpc/kernel/machine_kexec_64.c:867:
+			prop = fdt_getprop(fdt, chosen_node, "linux,stdout-path",

total: 0 errors, 3 warnings, 233 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/powerpc-add-code-to-work-with-device-trees-in-kexec_file_load.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Thiago Jung Bauermann <bauerman@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/machine_kexec_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes arch/powerpc/kernel/machine_kexec_64.c
--- a/arch/powerpc/kernel/machine_kexec_64.c~powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes
+++ a/arch/powerpc/kernel/machine_kexec_64.c
@@ -689,7 +689,7 @@ int setup_purgatory(struct kimage *image
  * @initrd_load_addr:	Address where the next initrd will be loaded.
  * @initrd_len:		Size of the next initrd, or 0 if there will be none.
  * @cmdline:		Command line for the next kernel, or NULL if there will
- * 			be none.
+ *			be none.
  *
  * Return: 0 on success, or negative errno on error.
  */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes.patch
sysctl-handle-error-writing-uint_max-to-u32-fields-checkpatch-fixes-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-vmalloc-fix-align-value-calculation-error-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix.patch
mm-vmalloc-fix-align-value-calculation-error-v2-fix-fix.patch
mm-compaction-make-whole_zone-flag-ignore-cached-scanner-positions-checkpatch-fixes.patch
mm-swap-add-swap_cluster_list-checkpatch-fixes.patch
seq-proc-modify-seq_put_decimal_ll-to-take-a-const-char-not-char-fix.patch
powerpc-adapt-elf64_apply_relocate_add-for-kexec_file_load-checkpatch-fixes.patch
powerpc-add-code-to-work-with-device-trees-in-kexec_file_load-checkpatch-fixes.patch
ima-demonstration-code-for-kexec-buffer-passing-checkpatch-fixes.patch
ipc-msg-avoid-waking-sender-upon-full-queue-checkpatch-fixes.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
include-linux-mlx5-deviceh-kill-build_bug_ons.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
powerpc-factor-out-relocation-code-from-module_64c-to-elf_util_64c-checkpatch-fixes.patch

