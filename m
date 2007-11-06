From: akpm@linux-foundation.org
Subject: + arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:02:18 -0800
Message-ID: <200711060002.lA602Itu026588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39132 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbXKFAC1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:02:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca


The patch titled
     ARM: remove reference to non-existent MTD_OBSOLETE_CHIPS
has been added to the -mm tree.  Its filename is
     arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ARM: remove reference to non-existent MTD_OBSOLETE_CHIPS
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

The CONFIG variable MTD_OBSOLETE_CHIPS was deleted in commit
ba7cc09c9c9e29a57045dc5bbf843ac1cfad3283.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/collie_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/arm/configs/collie_defconfig~arm-remove-reference-to-non-existent-mtd_obsolete_chips arch/arm/configs/collie_defconfig
--- a/arch/arm/configs/collie_defconfig~arm-remove-reference-to-non-existent-mtd_obsolete_chips
+++ a/arch/arm/configs/collie_defconfig
@@ -367,7 +367,6 @@ CONFIG_MTD_CFI_UTIL=y
 # CONFIG_MTD_RAM is not set
 # CONFIG_MTD_ROM is not set
 # CONFIG_MTD_ABSENT is not set
-CONFIG_MTD_OBSOLETE_CHIPS=y
 CONFIG_MTD_SHARP=y
 # CONFIG_MTD_XIP is not set
 
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

origin.patch
arm-remove-reference-to-non-existent-mtd_obsolete_chips.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
