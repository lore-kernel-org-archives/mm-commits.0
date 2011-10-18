From: akpm@linux-foundation.org
Subject: + maintainers-update-vt-d-entry-for-drivers-pci-drivers-iommu-move.patch added to -mm tree
Date: Tue, 18 Oct 2011 13:49:07 -0700
Message-ID: <201110182049.p9IKn8O9009392@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:8824 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab1JRUt1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 16:49:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roland@purestorage.com, dwmw2@infradead.org


The patch titled
     Subject: MAINTAINERS: update VT-d entry for drivers/pci -> drivers/iommu move
has been added to the -mm tree.  Its filename is
     maintainers-update-vt-d-entry-for-drivers-pci-drivers-iommu-move.patch

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
Subject: Subject: MAINTAINERS: update VT-d entry for drivers/pci -> drivers/iommu move

Patches currently in -mm which might be from roland@purestorage.com are

origin.patch
linux-next.patch
maintainers-update-vt-d-entry-for-drivers-pci-drivers-iommu-move.patch

