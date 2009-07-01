From: akpm@linux-foundation.org
Subject: + vlynq-correct-typo-of-missing-config_-prefix-in-ifdef.patch added to -mm tree
Date: Wed, 01 Jul 2009 10:56:19 -0700
Message-ID: <200907011756.n61HuJsi001807@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35621 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753859AbZGAR4d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 13:56:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, florian@openwrt.org


The patch titled
     vlynq: correct typo of missing "CONFIG_" prefix in ifdef
has been added to the -mm tree.  Its filename is
     vlynq-correct-typo-of-missing-config_-prefix-in-ifdef.patch

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
Subject: vlynq: correct typo of missing "CONFIG_" prefix in ifdef
From: Robert P. J. Day <rpjday@crashcourse.ca>

Fix a typo in the vlynq bus driver which was missing the CONFIG_ prefix to
turn on debugging code.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/vlynq/vlynq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/vlynq/vlynq.c~vlynq-correct-typo-of-missing-config_-prefix-in-ifdef drivers/vlynq/vlynq.c
--- a/drivers/vlynq/vlynq.c~vlynq-correct-typo-of-missing-config_-prefix-in-ifdef
+++ a/drivers/vlynq/vlynq.c
@@ -76,7 +76,7 @@ struct vlynq_regs {
 	u32 int_device[8];
 };
 
-#ifdef VLYNQ_DEBUG
+#ifdef CONFIG_VLYNQ_DEBUG
 static void vlynq_dump_regs(struct vlynq_device *dev)
 {
 	int i;
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
vlynq-correct-typo-of-missing-config_-prefix-in-ifdef.patch
linux-next.patch

