From: akpm@linux-foundation.org
Subject: - mm-remove-unused-max_nodes_shift.patch removed from -mm tree
Date: Sat, 26 Apr 2008 09:42:36 -0700
Message-ID: <200804261642.m3QGgaNM031208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757705AbYDZQmk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Apr 2008 12:42:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     mm: remove unused MAX_NODES_SHIFT
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-max_nodes_shift.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: remove unused MAX_NODES_SHIFT
From: Johannes Weiner <hannes@saeurebad.de>

MAX_NODES_SHIFT is not referenced anywhere in the tree, so dump it.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/mmzone.h~mm-remove-unused-max_nodes_shift include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-unused-max_nodes_shift
+++ a/include/linux/mmzone.h
@@ -691,7 +691,6 @@ extern char numa_zonelist_order[];
 extern struct pglist_data contig_page_data;
 #define NODE_DATA(nid)		(&contig_page_data)
 #define NODE_MEM_MAP(nid)	mem_map
-#define MAX_NODES_SHIFT		1
 
 #else /* CONFIG_NEED_MULTIPLE_NODES */
 
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
mm-fix-possible-off-by-one-in-walk_pte_range.patch
dz-test-after-postfix-decrement-fails-in-dz_console_putchar.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch

