From: akpm@linux-foundation.org
Subject: [merged] zsmalloc-add-maintainers.patch removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:19 -0800
Message-ID: <52ebf683.AM+5Rp1i+L+sUZGj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org

Subject: [merged] zsmalloc-add-maintainers.patch removed from -mm tree
To: minchan@kernel.org,ngupta@vflare.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:19 -0800


The patch titled
     Subject: zsmalloc: add maintainers
has been removed from the -mm tree.  Its filename was
     zsmalloc-add-maintainers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: add maintainers

tAdd adds maintainer information for zsmalloc into the MAINTAINERS file.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN MAINTAINERS~zsmalloc-add-maintainers MAINTAINERS
--- a/MAINTAINERS~zsmalloc-add-maintainers
+++ a/MAINTAINERS
@@ -9753,6 +9753,14 @@ M:	"Maciej W. Rozycki" <macro@linux-mips
 S:	Maintained
 F:	drivers/tty/serial/zs.*
 
+ZSMALLOC COMPRESSED SLAB MEMORY ALLOCATOR
+M:	Minchan Kim <minchan@kernel.org>
+M:	Nitin Gupta <ngupta@vflare.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/zsmalloc.c
+F:	include/linux/zsmalloc.h
+
 ZSWAP COMPRESSED SWAP CACHING
 M:	Seth Jennings <sjenning@linux.vnet.ibm.com>
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from minchan@kernel.org are

origin.patch
mm-remove-bug_on-from-mlock_vma_page.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
debugging-keep-track-of-page-owners.patch

