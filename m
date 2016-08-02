From: akpm@linux-foundation.org
Subject: [folded-merged]
 treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch removed
 from -mm tree
Date: Tue, 02 Aug 2016 13:41:59 -0700
Message-ID: <57a10597.3rMFHkM+Ga1r0hNF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422AbcHBUmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 16:42:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fabf@skynet.be, mingo@redhat.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     treewide-replace-obsolete-_refok-by-__ref-checkpatch-fixes.patch

This patch was dropped because it was folded into treewide-replace-obsolete-_refok-by-__ref.patch

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

treewide-replace-obsolete-_refok-by-__ref.patch
printk-create-pr_level-functions-fix.patch
kexec-ensure-user-memory-sizes-do-not-wrap-fix.patch
kexec-allow-architectures-to-override-boot-mapping-fix.patch
allow-kdump-with-crash_kexec_post_notifiers-fix.patch
kexec-add-restriction-on-kexec_load-segment-sizes-fix.patch
powerpc-fsl_rio-apply-changes-for-rio-spec-rev-3-fix.patch

