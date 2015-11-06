From: akpm@linux-foundation.org
Subject: [merged] tools-vm-slabinfo-fix-alternate-opts-names.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:06:48 -0800
Message-ID: <563d0858.Y47wNG2aU0MuVP/b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161169AbbKFUGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:06:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/slabinfo: fix alternate opts names
has been removed from the -mm tree.  Its filename was
     tools-vm-slabinfo-fix-alternate-opts-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: tools/vm/slabinfo: fix alternate opts names

Fix mismatches between usage() output and real opts[] options.  Add
missing alternative opt names, e.g., '-S' had no '--Size' opts[] entry,
etc.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/slabinfo.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN tools/vm/slabinfo.c~tools-vm-slabinfo-fix-alternate-opts-names tools/vm/slabinfo.c
--- a/tools/vm/slabinfo.c~tools-vm-slabinfo-fix-alternate-opts-names
+++ a/tools/vm/slabinfo.c
@@ -1294,12 +1294,14 @@ struct option opts[] = {
 	{ "first-alias", no_argument, NULL, 'f' },
 	{ "help", no_argument, NULL, 'h' },
 	{ "inverted", no_argument, NULL, 'i'},
+	{ "slabs", no_argument, NULL, 'l' },
 	{ "numa", no_argument, NULL, 'n' },
 	{ "ops", no_argument, NULL, 'o' },
-	{ "report", no_argument, NULL, 'r' },
 	{ "shrink", no_argument, NULL, 's' },
-	{ "slabs", no_argument, NULL, 'l' },
-	{ "track", no_argument, NULL, 't'},
+	{ "report", no_argument, NULL, 'r' },
+	{ "Size", no_argument, NULL, 'S'},
+	{ "tracking", no_argument, NULL, 't'},
+	{ "Totals", no_argument, NULL, 'T'},
 	{ "validate", no_argument, NULL, 'v' },
 	{ "zero", no_argument, NULL, 'z' },
 	{ "1ref", no_argument, NULL, '1'},
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

