From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-myself-as-zsmalloc-reviewer.patch
 removed from -mm tree
Date: Fri, 30 Oct 2015 12:44:36 -0700
Message-ID: <5633c8a4.QFHalX8kTCbSIERv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758403AbbJ3Tog (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 30 Oct 2015 15:44:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: add Sergey as zsmalloc reviewer
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-zsmalloc-reviewer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: MAINTAINERS: add Sergey as zsmalloc reviewer

Nominate myself as a zsmalloc reviewer.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff -puN MAINTAINERS~maintainers-add-myself-as-zsmalloc-reviewer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-myself-as-zsmalloc-reviewer
+++ a/MAINTAINERS
@@ -11674,6 +11674,7 @@ F:	drivers/tty/serial/zs.*
 ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
 M:	Minchan Kim <minchan@kernel.org>
 M:	Nitin Gupta <ngupta@vflare.org>
+R:	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zsmalloc.c
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

tools-vm-slabinfo-use-getopt-no_argument-optional_argument.patch
tools-vm-slabinfo-limit-the-number-of-reported-slabs.patch
tools-vm-slabinfo-sort-slabs-by-loss.patch
tools-vm-slabinfo-fix-alternate-opts-names.patch
tools-vm-slabinfo-introduce-extended-totals-mode.patch
tools-vm-slabinfo-output-sizes-in-bytes.patch
tools-vm-slabinfo-cosmetic-globals-cleanup.patch
tools-vm-slabinfo-gnuplot-slabifo-extended-stat.patch
doc-slub-document-slabinfo-gnuplotsh-script.patch
zram-keep-the-exact-overcommited-value-in-mem_used_max.patch
mm-zsmalloc-constify-struct-zs_pool-name.patch
zsmalloc-use-preempth-for-in_interrupt.patch

