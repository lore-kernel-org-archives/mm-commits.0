From: akpm@linux-foundation.org
Subject: - istallion-remove-unused-variable.patch removed from -mm tree
Date: Mon, 21 Jul 2008 14:34:19 -0700
Message-ID: <200807212134.m6LLYJCD025657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754258AbYGUVfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 17:35:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     istallion: remove unused variable
has been removed from the -mm tree.  Its filename was
     istallion-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: istallion: remove unused variable
From: Andre Haupt <andre@bitwigglers.org>

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/istallion.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/istallion.c~istallion-remove-unused-variable drivers/char/istallion.c
--- a/drivers/char/istallion.c~istallion-remove-unused-variable
+++ a/drivers/char/istallion.c
@@ -1660,7 +1660,6 @@ static int stli_ioctl(struct tty_struct 
 {
 	struct stliport *portp;
 	struct stlibrd *brdp;
-	unsigned int ival;
 	int rc;
 	void __user *argp = (void __user *)arg;
 
_

Patches currently in -mm which might be from andre@bitwigglers.org are

linux-next.patch
stallion-removed-unused-variable.patch
parport-remove-superfluous-local-variable.patch

