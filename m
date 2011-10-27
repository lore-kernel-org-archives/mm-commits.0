From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-vt-d-entry-for-drivers-pci-drivers-iommu-move.patch removed from -mm tree
Date: Thu, 27 Oct 2011 16:08:58 -0700
Message-ID: <201110272308.p9RN8w0K026373@wpaz13.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:48947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab1J0XJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2011 19:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@purestorage.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: update VT-d entry for drivers/pci -> drivers/iommu move
has been removed from the -mm tree.  Its filename was
     maintainers-update-vt-d-entry-for-drivers-pci-drivers-iommu-move.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Roland Dreier <roland@purestorage.com>
Subject: MAINTAINERS: update VT-d entry for drivers/pci -> drivers/iommu move

Commit 166e9278a3f9 ("x86/ia64: intel-iommu: move to drivers/iommu/")
moved the VT-d driver to drivers/iommu, but left the "F:" line in
MAINTAINERS pointing to drivers/pci, which breaks
scripts/get_maintainer.pl.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-vt-d-entry-for-drivers-pci-drivers-iommu-move MAINTAINERS
--- a/MAINTAINERS~maintainers-update-vt-d-entry-for-drivers-pci-drivers-iommu-move
+++ a/MAINTAINERS
@@ -3384,7 +3384,7 @@ M:	David Woodhouse <dwmw2@infradead.org>
 L:	iommu@lists.linux-foundation.org
 T:	git git://git.infradead.org/iommu-2.6.git
 S:	Supported
-F:	drivers/pci/intel-iommu.c
+F:	drivers/iommu/intel-iommu.c
 F:	include/linux/intel-iommu.h
 
 INTEL IOP-ADMA DMA DRIVER
_

Patches currently in -mm which might be from roland@purestorage.com are

origin.patch
linux-next.patch

