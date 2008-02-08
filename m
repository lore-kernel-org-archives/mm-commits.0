From: akpm@linux-foundation.org
Subject: - tty_audit-fix-checkpatch-complaint.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:12:44 -0800
Message-ID: <200802082012.m18KCPxW010200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55636 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763414AbYBHUrc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:47:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty_audit: fix checkpatch complaint
has been removed from the -mm tree.  Its filename was
     tty_audit-fix-checkpatch-complaint.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tty_audit: fix checkpatch complaint
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/tty_audit.c~tty_audit-fix-checkpatch-complaint drivers/char/tty_audit.c
--- a/drivers/char/tty_audit.c~tty_audit-fix-checkpatch-complaint
+++ a/drivers/char/tty_audit.c
@@ -27,7 +27,7 @@ static struct tty_audit_buf *tty_audit_b
 {
 	struct tty_audit_buf *buf;
 
-	buf = kmalloc(sizeof (*buf), GFP_KERNEL);
+	buf = kmalloc(sizeof(*buf), GFP_KERNEL);
 	if (!buf)
 		goto err;
 	if (PAGE_SIZE != N_TTY_BUF_SIZE)
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
hci_ldisc-fix-null-pointer-deref.patch
parisc-new-termios-definitions.patch
git-sh.patch
git-watchdog.patch
