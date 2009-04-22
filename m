From: akpm@linux-foundation.org
Subject: + ksm-add-ksm-kernel-shared-memory-driver-fix.patch added to -mm tree
Date: Tue, 21 Apr 2009 20:34:24 -0700
Message-ID: <200904220334.n3M3YOKQ003028@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752211AbZDVDgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 23:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ieidus@redhat.com


The patch titled
     ksm-add-ksm-kernel-shared-memory-driver fix
has been added to the -mm tree.  Its filename is
     ksm-add-ksm-kernel-shared-memory-driver-fix.patch

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
