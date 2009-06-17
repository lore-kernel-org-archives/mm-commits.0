From: akpm@linux-foundation.org
Subject: [merged] maintainers-add-file-patterns-to-tty-layer.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:41 -0700
Message-ID: <200906171838.n5HIcfUY004776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37514 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756018AbZFQSqb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:46:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: add file patterns to TTY LAYER
has been removed from the -mm tree.  Its filename was
     maintainers-add-file-patterns-to-tty-layer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: add file patterns to TTY LAYER
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN MAINTAINERS~maintainers-add-file-patterns-to-tty-layer MAINTAINERS
--- a/MAINTAINERS~maintainers-add-file-patterns-to-tty-layer
+++ a/MAINTAINERS
@@ -5688,6 +5688,11 @@ P:	Jiri Kosina
 M:	trivial@kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
 S:	Maintained
+F:	drivers/char/tty_*
+F:	drivers/serial/serial_core.c
+F:	include/linux/serial_core.h
+F:	include/linux/serial.h
+F:	include/linux/tty.h
 
 TTY LAYER
 P:	Alan Cox
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

