From: akpm@linux-foundation.org
Subject: - char-riscom8-change-rc_init_drivers-prototype.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:38 -0800
Message-ID: <200802080809.m1889JYg014818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812AbYBHIS7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:18:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: riscom8, change rc_init_drivers prototype
has been removed from the -mm tree.  Its filename was
     char-riscom8-change-rc_init_drivers-prototype.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: riscom8, change rc_init_drivers prototype
From: Jiri Slaby <jirislaby@gmail.com>

Let compiler decide if the rc_init_drivers function will be inlined and
mark it as __init, because it's called only from __init function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/riscom8.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/riscom8.c~char-riscom8-change-rc_init_drivers-prototype drivers/char/riscom8.c
--- a/drivers/char/riscom8.c~char-riscom8-change-rc_init_drivers-prototype
+++ a/drivers/char/riscom8.c
@@ -1618,7 +1618,7 @@ static const struct tty_operations risco
 	.tiocmset = rc_tiocmset,
 };
 
-static inline int rc_init_drivers(void)
+static int __init rc_init_drivers(void)
 {
 	int error;
 	int i;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-drm.patch
drm-i915-fix-oops-after-killing-x.patch
git-watchdog.patch
moxa-first-pass-at-termios-reporting.patch
char-applicom-use-pci_resource_start.patch
char-applicom-use-pci_match_id.patch
char-applicom-use-pci_match_id-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
