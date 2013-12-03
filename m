From: akpm@linux-foundation.org
Subject: +
 drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch added to
 -mm tree
Date: Mon, 02 Dec 2013 16:08:51 -0800
Message-ID: <529d2113.zmmRY/OCrXdv7SUD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43239 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3LCAIv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Dec 2013 19:08:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, olaf@aepfle.de

Subject: + drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch added to -mm tree
To: olaf@aepfle.de
From: akpm@linux-foundation.org
Date: Mon, 02 Dec 2013 16:08:51 -0800


The patch titled
     Subject: drivers/block/loop.c: fix comment typo in loop_config_discard
has been added to the -mm tree.  Its filename is
     drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

drivers-block-loopc-fix-comment-typo-in-loop_config_discard.patch

