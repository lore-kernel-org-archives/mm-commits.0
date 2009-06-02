From: akpm@linux-foundation.org
Subject: + rapidio-fix-kerneldoc-for-rio_mem_ops.patch added to -mm tree
Date: Mon, 01 Jun 2009 20:34:22 -0700
Message-ID: <200906020334.n523YM5N029890@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbZFBDe1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 23:34:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, randy.dunlap@oracle.com


The patch titled
     rapidio: fix kerneldoc for rio_mem_ops
has been added to the -mm tree.  Its filename is
     rapidio-fix-kerneldoc-for-rio_mem_ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: fix kerneldoc for rio_mem_ops
From: Jiri Slaby <jirislaby@gmail.com>

Add structure name to the kerneldoc comment, so that we won't get a kdoc
error:

Error(include/linux/rio.h:336): cannot understand prototype: 'struct rio_mem_ops'

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rio.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/rio.h~rapidio-fix-kerneldoc-for-rio_mem_ops include/linux/rio.h
--- a/include/linux/rio.h~rapidio-fix-kerneldoc-for-rio_mem_ops
+++ a/include/linux/rio.h
@@ -327,7 +327,7 @@ extern struct resource rio_resource;
 #define release_rio_region(start, n) __release_region(&rio_resource, (start), (n))
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem_ops - struct for RIO memory definition.
  * @map_inb: The function for mapping inbound memory window.
  * @map_outb: The function for mapping outbound memory window.
  * @unmap_inb: The function for unmapping inbound memory window.
_

Patches currently in -mm which might be from jirislaby@gmail.com are

char-mxser-fix-isa-board-lookup.patch
linux-next.patch
fs-fix-lock-imbalance-in-do_remount_sb.patch
icom-converting-space-to-tabs.patch
icom-fix-compile-errors-when-defining-icom_trace.patch
char-isicom-fix-build-warning.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

