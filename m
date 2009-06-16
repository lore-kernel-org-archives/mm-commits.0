From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-fix.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:15 -0700
Message-ID: <200906162241.n5GMfFGI003196@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754249AbZFPWrW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:47:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm-add-ksm-kernel-shared-memory-driver fix
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm-add-ksm-kernel-shared-memory-driver fix
From: Izik Eidus <ieidus@redhat.com>

We surely dont need it, as we include linux\types.h above, that will
include that anyway.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ksm.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/ksm.h~ksm-add-ksm-kernel-shared-memory-driver-fix include/linux/ksm.h
--- a/include/linux/ksm.h~ksm-add-ksm-kernel-shared-memory-driver-fix
+++ a/include/linux/ksm.h
@@ -8,8 +8,6 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
-#include <asm/types.h>
