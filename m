From: akpm@linux-foundation.org
Subject: + gcov-add-support-for-gcc-47-gcov-format-fix-3.patch added to
 -mm tree
Date: Thu, 19 Sep 2013 14:01:04 -0700
Message-ID: <523b6610.Al1zsdPkKOXs1lUr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57520 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3ISVBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 Sep 2013 17:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fhrbata@redhat.com, oberpar@linux.vnet.ibm.com

Subject: + gcov-add-support-for-gcc-47-gcov-format-fix-3.patch added to -mm tree
To: oberpar@linux.vnet.ibm.com,fhrbata@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 19 Sep 2013 14:01:04 -0700


The patch titled
     Subject: gcov-add-support-for-gcc-47-gcov-format-fix-3
has been added to the -mm tree.  Its filename is
     gcov-add-support-for-gcc-47-gcov-format-fix-3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-add-support-for-gcc-47-gcov-format-fix-3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-add-support-for-gcc-47-gcov-format-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Subject: gcov-add-support-for-gcc-47-gcov-format-fix-3

gcc_4_7.c needs vmalloc.h

Cc: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix-3 kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-fix-3
+++ a/kernel/gcov/gcc_4_7.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
+#include <linux/vmalloc.h>
 #include "gcov.h"
 
 #define GCOV_COUNTERS			8
_

Patches currently in -mm which might be from oberpar@linux.vnet.ibm.com are

gcov-add-support-for-gcc-47-gcov-format-fix-3.patch

