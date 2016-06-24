From: akpm@linux-foundation.org
Subject: +
 treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch added to
 -mm tree
Date: Fri, 24 Jun 2016 12:57:11 -0700
Message-ID: <576d9097.tdk5QKau0fVwnz4J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39090 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbcFXT5M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 15:57:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabf@skynet.be, mingo@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch

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
Subject: treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes

ERROR: inline keyword should sit between storage class and type
#590: FILE: mm/sparse.c:62:
+static struct mem_section noinline __ref *sparse_index_alloc(int nid)

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes mm/sparse.c
--- a/mm/sparse.c~treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes
+++ a/mm/sparse.c
@@ -59,7 +59,7 @@ static inline void set_section_nid(unsig
 #endif
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
-static struct mem_section noinline __ref *sparse_index_alloc(int nid)
+static noinline struct mem_section __ref *sparse_index_alloc(int nid)
 {
 	struct mem_section *section = NULL;
 	unsigned long array_size = SECTIONS_PER_ROOT *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
mm.patch
mm-reorganize-slab-freelist-randomization-fix.patch
mm-balloon-use-general-non-lru-movable-page-feature-fix.patch
mm-compaction-split-freepages-without-holding-the-zone-lock-fix-2.patch
mm-frontswap-convert-frontswap_enabled-to-static-key-checkpatch-fixes.patch
mm-add-nr_zsmalloc-to-vmstat-fix.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-checkpatch-fixes.patch
mm-thp-make-swapin-readahead-under-down_read-of-mmap_sem-fix-2-fix.patch
mm-fix-build-warnings-in-linux-compactionh-fix.patch
mm-update-the-comment-in-__isolate_free_page-checkpatch-fixes.patch
nvme-dont-allocate-unused-nvme_major-fix.patch
treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
bitmap-bitmap_equal-memcmp-optimization-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

