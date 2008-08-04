From: akpm@linux-foundation.org
Subject: + drivers-misc-sgi-gru-grutlbpurgec-removed-duplicated-include.patch added to -mm tree
Date: Mon, 04 Aug 2008 16:36:17 -0700
Message-ID: <200808042336.m74NaHPK005639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753273AbYHDXgT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 19:36:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyi.huang@gmail.com, steiner@sgi.com


The patch titled
     drivers/misc/sgi-gru/grutlbpurge.c: removed duplicated #include
has been added to the -mm tree.  Its filename is
     drivers-misc-sgi-gru-grutlbpurgec-removed-duplicated-include.patch

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
Subject: drivers/misc/sgi-gru/grutlbpurge.c: removed duplicated #include
From: Huang Weiyi <weiyi.huang@gmail.com>

Removed duplicated include <linux/delay.h> in
drivers/misc/sgi-gru/grutlbpurge.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
Cc: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grutlbpurge.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/misc/sgi-gru/grutlbpurge.c~drivers-misc-sgi-gru-grutlbpurgec-removed-duplicated-include drivers/misc/sgi-gru/grutlbpurge.c
--- a/drivers/misc/sgi-gru/grutlbpurge.c~drivers-misc-sgi-gru-grutlbpurgec-removed-duplicated-include
+++ a/drivers/misc/sgi-gru/grutlbpurge.c
@@ -34,7 +34,6 @@
 #include <linux/hugetlb.h>
 #include <linux/delay.h>
 #include <linux/timex.h>
-#include <linux/delay.h>
 #include <linux/srcu.h>
 #include <asm/processor.h>
 #include "gru.h"
_

Patches currently in -mm which might be from weiyi.huang@gmail.com are

origin.patch
drivers-misc-sgi-gru-grutlbpurgec-removed-duplicated-include.patch
linux-next.patch
arch-m68k-bvme6000-rtcc-remove-duplicated-include.patch

