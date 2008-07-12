From: akpm@linux-foundation.org
Subject: + drivers-mtd-chips-jedec_probec-fix-am29dl800bb-device-id.patch added to -mm tree
Date: Fri, 11 Jul 2008 18:01:00 -0700
Message-ID: <200807120101.m6C110qJ013526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42303 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754065AbYGLBBg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 21:01:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hickswgjr@gmail.com, dwmw2@infradead.org


The patch titled
     drivers/mtd/chips/jedec_probe.c: fix Am29DL800BB device ID
has been added to the -mm tree.  Its filename is
     drivers-mtd-chips-jedec_probec-fix-am29dl800bb-device-id.patch

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
Subject: drivers/mtd/chips/jedec_probe.c: fix Am29DL800BB device ID
From: Jerry Hicks <hickswgjr@gmail.com>

The device id for Am29DL800BB in jedec_probe.c is wrong.

Reference: http://www.spansion.com/datasheets/21519c4.pdf

I discovered this while working with u-boot.

The u-boot folks mentioned Linux as an upstream reference, thought I'd
post a heads-up here too.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/jedec_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mtd/chips/jedec_probe.c~drivers-mtd-chips-jedec_probec-fix-am29dl800bb-device-id drivers/mtd/chips/jedec_probe.c
--- a/drivers/mtd/chips/jedec_probe.c~drivers-mtd-chips-jedec_probec-fix-am29dl800bb-device-id
+++ a/drivers/mtd/chips/jedec_probe.c
@@ -41,7 +41,7 @@
 
 
 /* AMD */
-#define AM29DL800BB	0x22C8
+#define AM29DL800BB	0x22CB
 #define AM29DL800BT	0x224A
 
 #define AM29F800BB	0x2258
_

Patches currently in -mm which might be from hickswgjr@gmail.com are

drivers-mtd-chips-jedec_probec-fix-am29dl800bb-device-id.patch

