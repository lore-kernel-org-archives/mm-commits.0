From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:35 -0800
Message-ID: <58b5e2d7.jdDGxkbLl05F+4rb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52766 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdB1Uvh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "initialiazation" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "initialiazation" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  initialiazation||initialization

While we are here, fix the "overriden" in the touched line in
drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c.

Link: http://lkml.kernel.org/r/1481573103-11329-17-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sonypi.c                            |    2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c |    2 +-
 scripts/spelling.txt                             |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/char/sonypi.c~scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances drivers/char/sonypi.c
--- a/drivers/char/sonypi.c~scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances
+++ a/drivers/char/sonypi.c
@@ -603,7 +603,7 @@ static void sonypi_type3_srs(void)
 	u16 v16;
 	u8  v8;
 
-	/* This model type uses the same initialiazation of
+	/* This model type uses the same initialization of
 	 * the embedded controller as the type2 models. */
 	sonypi_type2_srs();
 
diff -puN drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c~scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c~scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -6957,7 +6957,7 @@ int bnx2x_link_update(struct link_params
 			 * hence its link is expected to be down
 			 * - SECOND_PHY means that first phy should not be able
 			 * to link up by itself (using configuration)
-			 * - DEFAULT should be overriden during initialiazation
+			 * - DEFAULT should be overridden during initialization
 			 */
 				DP(NETIF_MSG_LINK, "Invalid link indication"
 					   "mpc=0x%x. DISABLING LINK !!!\n",
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -546,6 +546,7 @@ initalise||initialize
 initalize||initialize
 initation||initiation
 initators||initiators
+initialiazation||initialization
 initializiation||initialization
 initialzed||initialized
 initilization||initialization
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

