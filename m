From: akpm@linux-foundation.org
Subject: + stallion-removed-unused-variable.patch added to -mm tree
Date: Mon, 30 Jun 2008 22:45:09 -0700
Message-ID: <200807010545.m615j9S8011338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360AbYGAFqD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 01:46:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org, alan@redhat.com


The patch titled
     stallion: removed unused variable
has been added to the -mm tree.  Its filename is
     stallion-removed-unused-variable.patch

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
@@ -1255,7 +1255,6 @@ static int stl_tiocmset(struct tty_struc
 static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct stlport	*portp;
-	unsigned int	ival;
 	int		rc;
 	void __user *argp = (void __user *)arg;
 
_

Patches currently in -mm which might be from andre@bitwigglers.org are

istallion-remove-unused-variable.patch
stallion-removed-unused-variable.patch
parport-remove-superfluous-local-variable.patch

