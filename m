From: akpm@linux-foundation.org
Subject: + checkpatch-add-__pmem-to-sparse-annotations.patch added to -mm
 tree
Date: Fri, 07 Aug 2015 16:22:48 -0700
Message-ID: <55c53dc8.iTcBPIj0e58WYidF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49080 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946334AbbHGXWt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Aug 2015 19:22:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add __pmem to $Sparse annotations
has been added to the -mm tree.  Its filename is
     checkpatch-add-__pmem-to-sparse-annotations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-__pmem-to-sparse-annotations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-__pmem-to-sparse-annotations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add __pmem to $Sparse annotations

commit 61031952f4c8 ("arch, x86: pmem api for ensuring durability of
persistent memory updates") added a new __pmem annotation for sparse
verification.  Add __pmem to the $Sparse variable so checkpatch can
appropriately ignore uses of this attribute too.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-__pmem-to-sparse-annotations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-__pmem-to-sparse-annotations
+++ a/scripts/checkpatch.pl
@@ -264,6 +264,7 @@ our $Sparse	= qr{
 			__kernel|
 			__force|
 			__iomem|
+			__pmem|
 			__must_check|
 			__init_refok|
 			__kprobes|
_

Patches currently in -mm which might be from joe@perches.com are

lindent-handle-missing-indent-gracefully.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-slab_common-allow-null-cache-pointer-in-kmem_cache_destroy.patch
mm-mempool-allow-null-pool-pointer-in-mempool_destroy.patch
mm-dmapool-allow-null-pool-pointer-in-dma_pool_destroy.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
maintainers-credits-mark-maxraid-as-orphan-move-anil-ravindranath-to-credits.patch
parse_integer-add-checkpatchpl-notice.patch
mm-utilc-add-kstrimdup.patch
checkpatch-warn-on-bare-sha-1-commit-ids-in-commit-logs.patch
checkpatch-add-warning-on-bug-bug_on-use.patch
checkpatch-improve-suspect_code_indent-test.patch
checkpatch-allow-longer-declaration-macros.patch
checkpatch-add-some-foo_destroy-functions-to-needless_if-tests.patch
checkpatch-report-the-right-line-when-using-emacs-and-file.patch
checkpatch-always-check-block-comment-styles.patch
checkpatch-make-strict-the-default-for-drivers-staging-files-and-patches.patch
checkpatch-emit-an-error-on-formats-with-0x%decimal.patch
checkpatch-avoid-some-commit-message-long-line-warnings.patch
checkpatch-fix-left-brace-warning.patch
checkpatch-add-__pmem-to-sparse-annotations.patch
hfs-fix-b-tree-corruption-after-insertion-at-position-0.patch
seq_file-provide-an-analogue-of-print_hex_dump.patch
crypto-qat-use-seq_hex_dump-to-dump-buffers.patch
parisc-use-seq_hex_dump-to-dump-buffers.patch
zcrypt-use-seq_hex_dump-to-dump-buffers.patch
kmemleak-use-seq_hex_dump-to-dump-buffers.patch
wil6210-use-seq_hex_dump-to-dump-buffers.patch
linux-next.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix-fix.patch

