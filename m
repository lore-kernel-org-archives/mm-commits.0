From: akpm@linux-foundation.org
Subject: + mm-remove-unused-max_nodes_shift.patch added to -mm tree
Date: Fri, 21 Mar 2008 14:54:17 -0700
Message-ID: <200803212154.m2LLsHJ7012279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37364 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678AbYCUVyx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 17:54:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, clameter@sgi.com


The patch titled
     mm: remove unused MAX_NODES_SHIFT
has been added to the -mm tree.  Its filename is
     mm-remove-unused-max_nodes_shift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -692,7 +692,6 @@ extern char numa_zonelist_order[];
 extern struct pglist_data contig_page_data;
 #define NODE_DATA(nid)		(&contig_page_data)
 #define NODE_MEM_MAP(nid)	mem_map
-#define MAX_NODES_SHIFT		1
 
 #else /* CONFIG_NEED_MULTIPLE_NODES */
 
_

Patches currently in -mm which might be from hannes@saeurebad.de are

x86-remove-redundant-display-of-free-swap-space-in-show_mem.patch
arm-remove-redundant-display-of-free-swap-space-in-show_mem.patch
powerpc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ppc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
ia64-remove-redundant-display-of-free-swap-space-in-show_mem.patch
mips-remove-redundant-display-of-free-swap-space-in-show_mem.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
s390-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
mm-remove-unused-max_nodes_shift.patch
m68k-remove-redundant-display-of-free-swap-space-in-show_mem.patch
cris-remove-redundant-display-of-free-swap-space-in-show_mem.patch
add-warn_on_secs-macro-simplification.patch
add-warn_on_secs-macro-simplification-fix.patch

