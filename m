From: akpm@linux-foundation.org
Subject: [merged] cma-increase-cma_alignment-upper-limit-to-12.patch
 removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:09 -0700
Message-ID: <5390ca69.EGL6BxM/MuaqSe8W%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56308 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbaFETwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, m.szyprowski@samsung.com, marc.ceeeee@gmail.com

Subject: [merged] cma-increase-cma_alignment-upper-limit-to-12.patch removed from -mm tree
To: marc.ceeeee@gmail.com,m.szyprowski@samsung.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:09 -0700


The patch titled
     Subject: cma: increase CMA_ALIGNMENT upper limit to 12
has been removed from the -mm tree.  Its filename was
     cma-increase-cma_alignment-upper-limit-to-12.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Marc Carino <marc.ceeeee@gmail.com>
Subject: cma: increase CMA_ALIGNMENT upper limit to 12

Some systems require a larger maximum PAGE_SIZE order for CMA allocations.
 To accommodate such systems, increase the upper-bound of the
CMA_ALIGNMENT range to 12 (which ends up being 16MB on systems with 4K
pages).

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/Kconfig~cma-increase-cma_alignment-upper-limit-to-12 drivers/base/Kconfig
--- a/drivers/base/Kconfig~cma-increase-cma_alignment-upper-limit-to-12
+++ a/drivers/base/Kconfig
@@ -258,7 +258,7 @@ endchoice
 
 config CMA_ALIGNMENT
 	int "Maximum PAGE_SIZE order of alignment for contiguous buffers"
-	range 4 9
+	range 4 12
 	default 8
 	help
 	  DMA mapping framework by default aligns all buffers to the smallest
_

Patches currently in -mm which might be from marc.ceeeee@gmail.com are

origin.patch
linux-next.patch

