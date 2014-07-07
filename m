From: akpm@linux-foundation.org
Subject: +
 documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch added
 to -mm tree
Date: Mon, 07 Jul 2014 16:08:26 -0700
Message-ID: <53bb286a.s/vcwRU+2mCU3ICP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:56213 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaGGXI1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jul 2014 19:08:27 -0400
Received: by mail-vc0-f202.google.com with SMTP id id10so719677vcb.3
        for <mm-commits@vger.kernel.org>; Mon, 07 Jul 2014 16:08:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch

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
Subject: documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes

ERROR: trailing whitespace
#48: FILE: Documentation/DocBook/mtdnand.tmpl:267:
+^I^I^IThe structure(s) have to be zeroed out first and then filled with the necessary $

ERROR: trailing whitespace
#84: FILE: Documentation/DocBook/mtdnand.tmpl:557:
+^I^I^I^IIt may be desired or necessary to keep a bad block table in FLASH. $

total: 2 errors, 0 warnings, 113 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/documentation-fix-typo-in-docbook-mtdnandtmpl.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/mtdnand.tmpl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/mtdnand.tmpl~documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes Documentation/DocBook/mtdnand.tmpl
--- a/Documentation/DocBook/mtdnand.tmpl~documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes
+++ a/Documentation/DocBook/mtdnand.tmpl
@@ -264,7 +264,7 @@ static void board_hwcontrol(struct mtd_i
 			is set up nand_scan() is called. This function tries to
 			detect and identify then chip. If a chip is found all the
 			internal data fields are initialized accordingly.
-			The structure(s) have to be zeroed out first and then filled with the necessary 
+			The structure(s) have to be zeroed out first and then filled with the necessary
 			information about the device.
 		</para>
 		<programlisting>
@@ -554,7 +554,7 @@ static void board_select_chip (struct mt
 		<sect2 id="Flash_based_tables">
 			<title>Flash based tables</title>
 			<para>
-				It may be desired or necessary to keep a bad block table in FLASH. 
+				It may be desired or necessary to keep a bad block table in FLASH.
 				For AG-AND chips this is mandatory, as they have no factory marked
 				bad blocks. They have factory marked good blocks. The marker pattern
 				is erased when the block is erased to be reused. So in case of
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
fs-isofs-logging-clean-up-fix.patch
documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

