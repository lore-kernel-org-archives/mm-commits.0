From: akpm@linux-foundation.org
Subject: - make-mm-sparsec-make-a-function-static.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:18:12 -0700
Message-ID: <200807262118.m6QLICOU020069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758032AbYGZVSV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:18:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make mm/sparse.c: make a function static
has been removed from the -mm tree.  Its filename was
     make-mm-sparsec-make-a-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make mm/sparse.c: make a function static
From: Adrian Bunk <bunk@kernel.org>

This patch makes the needlessly global sparse_early_mem_map_alloc()
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~make-mm-sparsec-make-a-function-static mm/sparse.c
--- a/mm/sparse.c~make-mm-sparsec-make-a-function-static
+++ a/mm/sparse.c
@@ -377,7 +377,7 @@ struct page __init *sparse_mem_map_popul
 }
 #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
-struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
+static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
 	struct mem_section *ms = __nr_to_section(pnum);
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
linux-next.patch
m32r-remove-the-unused-nohighmem-option.patch
if-0-ses_match_host.patch
git-xtensa.patch
include-linux-kernelh-userspace-header-cleanup.patch
make-mm-rmapc-anon_vma_cachep-static.patch
reiser4.patch

