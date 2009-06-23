From: akpm@linux-foundation.org
Subject: [obsolete] rapidio-fix-kerneldoc-for-rio_mem_ops.patch removed from -mm tree
Date: Mon, 22 Jun 2009 22:27:26 -0700
Message-ID: <200906230527.n5N5RQtk019449@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44281 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080AbZFWF1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 01:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: fix kerneldoc for rio_mem_ops
has been removed from the -mm tree.  Its filename was
     rapidio-fix-kerneldoc-for-rio_mem_ops.patch

This patch was dropped because it is obsolete

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

origin.patch
linux-next.patch
icom-converting-space-to-tabs.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

