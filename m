From: akpm@linux-foundation.org
Subject: - stallion-removed-unused-variable.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:28:21 -0700
Message-ID: <200807242328.m6ONSLjV011253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756666AbYGXX3V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     stallion: removed unused variable
has been removed from the -mm tree.  Its filename was
     stallion-removed-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: stallion: removed unused variable
From: Andre Haupt <andre@bitwigglers.org>

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/stallion.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/stallion.c~stallion-removed-unused-variable drivers/char/stallion.c
--- a/drivers/char/stallion.c~stallion-removed-unused-variable
+++ a/drivers/char/stallion.c
@@ -1256,7 +1256,6 @@ static int stl_tiocmset(struct tty_struc
 static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct stlport	*portp;
-	unsigned int	ival;
 	int		rc;
 	void __user *argp = (void __user *)arg;
 
_

Patches currently in -mm which might be from andre@bitwigglers.org are

origin.patch
parport-remove-superfluous-local-variable.patch

