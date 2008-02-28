From: akpm@linux-foundation.org
Subject: + alpha-remove-unused-debug_forcedac-define-in-iommu.patch added to -mm tree
Date: Wed, 27 Feb 2008 16:43:32 -0800
Message-ID: <200802280043.m1S0hWOV007332@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53702 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320AbYB1Ann (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 19:43:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, rth@twiddle.net


The patch titled
     alpha: remove unused DEBUG_FORCEDAC define in IOMMU
has been added to the -mm tree.  Its filename is
     alpha-remove-unused-debug_forcedac-define-in-iommu.patch

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
Subject: alpha: remove unused DEBUG_FORCEDAC define in IOMMU
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

This just removes unused DEBUG_FORCEDAC define in the IOMMU code.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/pci_iommu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/alpha/kernel/pci_iommu.c~alpha-remove-unused-debug_forcedac-define-in-iommu arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-remove-unused-debug_forcedac-define-in-iommu
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -31,7 +31,6 @@
 #endif
 
 #define DEBUG_NODIRECT 0
-#define DEBUG_FORCEDAC 0
 
 #define ISA_DMA_MASK		0x00ffffff
 
_

Patches currently in -mm which might be from fujita.tomonori@lab.ntt.co.jp are

git-scsi-misc.patch
alpha-convert-iommu-to-use-align.patch
alpha-iommu-had-better-access-to-the-free-space-bitmap-at-only-one-place.patch
alpha-make-iommu-respect-the-segment-boundary-limits.patch
alpha-remove-unused-debug_forcedac-define-in-iommu.patch
mpt-fusion-dont-oops-if-numphys==0.patch
