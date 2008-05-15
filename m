From: akpm@linux-foundation.org
Subject: + pcmcia-ti113x-fix-ene_test_c9_pfenable-definition.patch added to -mm tree
Date: Thu, 15 May 2008 14:30:28 -0700
Message-ID: <200805152130.m4FLUStA011477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbYEOVay (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 17:30:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, daniel.ritz@gmx.ch, linux@dominikbrodowski.net


The patch titled
     ] pcmcia: ti113x: fix ENE_TEST_C9_PFENABLE definition
has been added to the -mm tree.  Its filename is
     pcmcia-ti113x-fix-ene_test_c9_pfenable-definition.patch

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
Subject: ] pcmcia: ti113x: fix ENE_TEST_C9_PFENABLE definition
From: Roel Kluin <roel.kluin@gmail.com>

This code was added in commit 8c3520d4eb3b1bbf2e45fbae8dcfb8db06d5e775

Is the replacement below correct, or should the second ENE_TEST_C9_PFENABLE_F0
be removed? The patch below assumes the former is correct.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/ti113x.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pcmcia/ti113x.h~pcmcia-ti113x-fix-ene_test_c9_pfenable-definition drivers/pcmcia/ti113x.h
--- a/drivers/pcmcia/ti113x.h~pcmcia-ti113x-fix-ene_test_c9_pfenable-definition
+++ a/drivers/pcmcia/ti113x.h
@@ -155,7 +155,7 @@
 #define ENE_TEST_C9_TLTENABLE		0x02
 #define ENE_TEST_C9_PFENABLE_F0		0x04
 #define ENE_TEST_C9_PFENABLE_F1		0x08
-#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F0)
+#define ENE_TEST_C9_PFENABLE		(ENE_TEST_C9_PFENABLE_F0 | ENE_TEST_C9_PFENABLE_F1)
 #define ENE_TEST_C9_WPDISALBLE_F0	0x40
 #define ENE_TEST_C9_WPDISALBLE_F1	0x80
 #define ENE_TEST_C9_WPDISALBLE		(ENE_TEST_C9_WPDISALBLE_F0 | ENE_TEST_C9_WPDISALBLE_F1)
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

ipg-fix-receivemode-ipg_rm_receivemulticasthash-in-ipg_nic_set_multicast_list.patch
wireless-airo-waitbusy-wont-delay.patch
wireless-airo-waitbusy-wont-delay-checkpatch-fixes.patch
pcmcia-ti113x-fix-ene_test_c9_pfenable-definition.patch

