From: akpm@linux-foundation.org
Subject: - fs-select-remove-unused-macros.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:26 -0700
Message-ID: <200710192252.l9JMqQHL024270@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35775 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764474AbXJSXFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs/select, remove unused macros
has been removed from the -mm tree.  Its filename was
     fs-select-remove-unused-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fs/select, remove unused macros
From: Jiri Slaby <jirislaby@gmail.com>

fs/select, remove unused macros

this is due to preparation for global BIT macro

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN fs/select.c~fs-select-remove-unused-macros fs/select.c
--- a/fs/select.c~fs-select-remove-unused-macros
+++ a/fs/select.c
@@ -177,11 +177,6 @@ get_max:
 	return max;
 }
 
-#define BIT(i)		(1UL << ((i)&(__NFDBITS-1)))
-#define MEM(i,m)	((m)+(unsigned)(i)/__NFDBITS)
-#define ISSET(i,m)	(((i)&*(m)) != 0)
-#define SET(i,m)	(*(m) |= (i))
-
 #define POLLIN_SET (POLLRDNORM | POLLRDBAND | POLLIN | POLLHUP | POLLERR)
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
git-dvb.patch
v4l-stk11xx-add-a-new-webcam-driver.patch
v4l-stk11xx-use-array_size-in-another-2-cases.patch
v4l-stk11xx-use-retval-from-stk11xx_check_device.patch
v4l-stk11xx-add-static-to-tables.patch
git-wireless.patch
dzh-remove-useless-unused-module-junk.patch
dz-always-check-if-it-is-safe-to-console_putchar.patch
dz-dont-panic-when-request_irq-fails.patch
dz-add-and-reorder-inclusions-remove-unneeded-ones.patch
dz-update-kconfig-description.patch
dz-rename-the-serial-console-structure.patch
dz-fix-locking-issues.patch
dz-handle-special-conditions-on-reception-correctly.patch
maintainers-add-self-for-the-dz-serial-driver.patch
remove-asm-bitopsh-includes-reiser4.patch
shrink_slab-handle-bad-shrinkers.patch
