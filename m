From: akpm@linux-foundation.org
Subject: [merged]
 documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch
 removed from -mm tree
Date: Tue, 08 Jul 2014 12:26:19 -0700
Message-ID: <53bc45db.Q0cge33mtf9WCsv5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:65385 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaGHT0U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Jul 2014 15:26:20 -0400
Received: by mail-qc0-f201.google.com with SMTP id i17so226564qcy.4
        for <mm-commits@vger.kernel.org>; Tue, 08 Jul 2014 12:26:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, standby24x7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     documentation-fix-typo-in-docbook-mtdnandtmpl-checkpatch-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

