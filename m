From: akpm@linux-foundation.org
Subject: +
 x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch added to
 -mm tree
Date: Thu, 26 Sep 2013 15:15:04 -0700
Message-ID: <5244b1e8.j/H21H44bWciH0R7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34700 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab3IZWPF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Sep 2013 18:15:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, tangchen@cn.fujitsu.com, akpm@linux-foundation.org

Subject: + x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch added to -mm tree
To: akpm@linux-foundation.org,tangchen@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Thu, 26 Sep 2013 15:15:04 -0700


The patch titled
     Subject: x86-mm-factor-out-of-top-down-direct-mapping-setup: fix for linux-next
has been added to the -mm tree.  Its filename is
     x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch

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
Subject: x86-mm-factor-out-of-top-down-direct-mapping-setup: fix for linux-next

Resolve x86-mm-factor-out-of-top-down-direct-mapping-setup versus next's

commit 6979287a7df66a92d6f308338e972a406f9ef842
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Fri Sep 6 19:07:09 2013 -0700

    x86/mm: Add 'step_size' comments to init_mem_mapping()

Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/init.c~x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix
+++ a/arch/x86/mm/init.c
@@ -509,7 +509,7 @@ static void __init memory_map_bottom_up(
 		start = next;
 
 		if (new_mapped_ram_size > mapped_ram_size)
-			step_size <<= STEP_SIZE_SHIFT;
+			step_size = get_new_step_size(step_size);
 		mapped_ram_size += new_mapped_ram_size;
 	}
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix-fix.patch
include-asm-generic-vtimeh-avoid-zero-length-file.patch
mm-avoid-reinserting-isolated-balloon-pages-into-lru-lists-fix.patch
ipc-semc-update-sem_otime-for-all-operations-checkpatch-fixes.patch
sound-soc-atmel-atmel-pcmc-fix-warning.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate.patch
fat-additions-to-support-fat_fallocate-v6-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
linux-next.patch
linux-next-rejects.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup-next-fix.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

