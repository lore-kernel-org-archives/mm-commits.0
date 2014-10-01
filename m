From: akpm@linux-foundation.org
Subject: + mm-bootmem-added-headers.patch added to -mm tree
Date: Wed, 01 Oct 2014 13:31:27 -0700
Message-ID: <542c649f.bTtqYDam6P1YEgXA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaJAUb1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2014 16:31:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulmcquad@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/bootmem.c: use include/linux/ headers
has been added to the -mm tree.  Its filename is
     mm-bootmem-added-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-bootmem-added-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-bootmem-added-headers.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Paul McQuade <paulmcquad@gmail.com>
Subject: mm/bootmem.c: use include/linux/ headers

Replace asm. headers with linux/headers:

<linux/bug.h>
<linux/io.h>

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/bootmem.c~mm-bootmem-added-headers mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-added-headers
+++ a/mm/bootmem.c
@@ -16,9 +16,9 @@
 #include <linux/kmemleak.h>
 #include <linux/range.h>
 #include <linux/memblock.h>
+#include <linux/bug.h>
+#include <linux/io.h>
 
-#include <asm/bug.h>
-#include <asm/io.h>
 #include <asm/processor.h>
 
 #include "internal.h"
_

Patches currently in -mm which might be from paulmcquad@gmail.com are

mm-mremap-use-linux-headers.patch
mm-filemap-remove-trailing-whitespace.patch
mm-bootmem-added-headers.patch

