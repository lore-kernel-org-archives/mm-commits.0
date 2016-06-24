From: akpm@linux-foundation.org
Subject: [patch 21/41] MAINTAINERS: update Calgary IOMMU
Date: Fri, 24 Jun 2016 14:49:31 -0700
Message-ID: <576daaeb.rl4b8m68U7Yp8Ysp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbcFXVtc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:49:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, jdmason@kudzu.us, b.zolnierkie@samsung.com, gregkh@linuxfoundation.org, hpa@zytor.com, k.kozlowski@samsung.com, mingo@redhat.com, mulix@mulix.org, tglx@linutronix.de

From: Jon Mason <jdmason@kudzu.us>
Subject: MAINTAINERS: update Calgary IOMMU

Update the contact info for Muli, clean-up my name, and update the
mailing list to the IOMMU mailing list.

Link: http://lkml.kernel.org/r/1465493059-11840-2-git-send-email-jdmason@kudzu.us
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Cc: Muli Ben-Yehuda <mulix@mulix.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN MAINTAINERS~maintainers-update-calgary-iommu MAINTAINERS
--- a/MAINTAINERS~maintainers-update-calgary-iommu
+++ a/MAINTAINERS
@@ -2776,9 +2776,9 @@ F:	include/net/caif/
 F:	net/caif/
 
 CALGARY x86-64 IOMMU
-M:	Muli Ben-Yehuda <muli@il.ibm.com>
-M:	"Jon D. Mason" <jdmason@kudzu.us>
-L:	discuss@x86-64.org
+M:	Muli Ben-Yehuda <mulix@mulix.org>
+M:	Jon Mason <jdmason@kudzu.us>
+L:	iommu@lists.linux-foundation.org
 S:	Maintained
 F:	arch/x86/kernel/pci-calgary_64.c
 F:	arch/x86/kernel/tce_64.c
_
