From: akpm@linux-foundation.org
Subject: [merged] vlynq-correct-typo-of-missing-config_-prefix-in-ifdef.patch removed from -mm tree
Date: Tue, 14 Jul 2009 13:32:31 -0700
Message-ID: <200907142032.n6EKWVoB012103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756454AbZGNUdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 16:33:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, florian@openwrt.org, mm-commits@vger.kernel.org


The patch titled
     vlynq: correct typo of missing "CONFIG_" prefix in ifdef
has been removed from the -mm tree.  Its filename was
     vlynq-correct-typo-of-missing-config_-prefix-in-ifdef.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

