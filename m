From: akpm@linux-foundation.org
Subject: - char-mxser_new-fix-sparse-warning.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:54:54 -0700
Message-ID: <200707162054.l6GKssVk001860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38868 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757196AbXGPVGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Char: mxser_new, fix sparse warning
has been removed from the -mm tree.  Its filename was
     char-mxser_new-fix-sparse-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Char: mxser_new, fix sparse warning
From: Jiri Slaby <jirislaby@gmail.com>

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser_new.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/mxser_new.c~char-mxser_new-fix-sparse-warning drivers/char/mxser_new.c
--- a/drivers/char/mxser_new.c~char-mxser_new-fix-sparse-warning
+++ a/drivers/char/mxser_new.c
@@ -1560,7 +1560,7 @@ static int mxser_ioctl_special(unsigned 
 			return -EFAULT;
 		return 0;
 	case MOXA_ASPP_MON_EXT: {
-		int status, p, shiftbit;
+		int p, shiftbit;
 		unsigned long opmode;
 		unsigned cflag, iflag;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-cyclades-add-firmware-loading.patch
char-cyclades-fix-sparse-warning.patch
char-isicom-cleanup-locking.patch
char-isicom-del_timer-at-exit.patch
char-isicom-proper-variables-types.patch
char-moxa-eliminate-busy-waiting.patch
char-specialix-remove-busy-waiting.patch
char-riscom8-eliminate-busy-loop.patch
char-vt-use-kzalloc.patch
char-vt-use-array_size.patch
char-kconfig-mxser_new-remove-experimental-comment.patch
char-stallion-remove-user-class-report-request.patch
char-istallion-initlocking-fixes-try-2.patch
stallion-remove-unneeded-lock_kernel.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
shrink_slab-handle-bad-shrinkers.patch
