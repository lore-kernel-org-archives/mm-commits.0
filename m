From: akpm@linux-foundation.org
Subject: [merged] viafb-remove-unused-structure-member.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:02:25 -0700
Message-ID: <200909232002.n8NK2PEB017169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39705 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753567AbZIWUC5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:02:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laforge@gnumonks.org, FlorianSchandinat@gmx.de, HaraldWelte@viatech.com, JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net, mm-commits@vger.kernel.org


The patch titled
     viafb: remove unused structure member
has been removed from the -mm tree.  Its filename was
     viafb-remove-unused-structure-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: viafb: remove unused structure member
From: Harald Welte <laforge@gnumonks.org>

Remove a structure member 'on_slot' in the chip_info structure which is
completely unused.

Signed-off-by: Harald Welte <HaraldWelte@viatech.com>
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Scott Fang <ScottFang@viatech.com.cn>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/chip.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/video/via/chip.h~viafb-remove-unused-structure-member drivers/video/via/chip.h
--- a/drivers/video/via/chip.h~viafb-remove-unused-structure-member
+++ a/drivers/video/via/chip.h
@@ -122,7 +122,6 @@ struct lvds_chip_information {
 struct chip_information {
 	int gfx_chip_name;
 	int gfx_chip_revision;
-	int chip_on_slot;
 	struct tmds_chip_information tmds_chip_info;
 	struct lvds_chip_information lvds_chip_info;
 	struct lvds_chip_information lvds_chip_info2;
_

Patches currently in -mm which might be from laforge@gnumonks.org are

origin.patch

