From: akpm@linux-foundation.org
Subject: [merged]
 drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch removed
 from -mm tree
Date: Thu, 23 Jan 2014 12:42:46 -0800
Message-ID: <52e17ec6.ukLy5iABl2hkNiu+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbaAWUmq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 15:42:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, olaf@aepfle.de

Subject: [merged] drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch removed from -mm tree
To: olaf@aepfle.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 12:42:46 -0800


The patch titled
     Subject: drivers/block/loop.c: fix comment typo in loop_config_discard
has been removed from the -mm tree.  Its filename was
     drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Olaf Hering <olaf@aepfle.de>
Subject: drivers/block/loop.c: fix comment typo in loop_config_discard

Discard requests are ignored if the encryption is enabled for the given
loop device.  Update comment to match the code, and similar comments
elsewhere in the file.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/loop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/block/loop.c~drivers-block-loopc-fix-comment-typo-in-loop_config_discard drivers/block/loop.c
--- a/drivers/block/loop.c~drivers-block-loopc-fix-comment-typo-in-loop_config_discard
+++ a/drivers/block/loop.c
@@ -798,7 +798,7 @@ static void loop_config_discard(struct l
 
 	/*
 	 * We use punch hole to reclaim the free space used by the
-	 * image a.k.a. discard. However we do support discard if
+	 * image a.k.a. discard. However we do not support discard if
 	 * encryption is enabled, because it may give an attacker
 	 * useful information.
 	 */
_

Patches currently in -mm which might be from olaf@aepfle.de are

origin.patch
linux-next.patch

