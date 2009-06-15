From: akpm@linux-foundation.org
Subject: [merged] maintainers-update-8250-section-give-alan-cox-a-name.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:51 -0700
Message-ID: <200906151901.n5FJ1pUN023168@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276AbZFOTC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: update 8250 section, give Alan Cox a name
has been removed from the -mm tree.  Its filename was
     maintainers-update-8250-section-give-alan-cox-a-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: update 8250 section, give Alan Cox a name
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~maintainers-update-8250-section-give-alan-cox-a-name MAINTAINERS
--- a/MAINTAINERS~maintainers-update-8250-section-give-alan-cox-a-name
+++ a/MAINTAINERS
@@ -163,9 +163,10 @@ S:	Maintained
 F:	drivers/net/r8169.c
 
 8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
+P:	Alan Cox
+M:	alan@lxorguk.ukuu.org.uk
 L:	linux-serial@vger.kernel.org
 W:	http://serial.sourceforge.net
-M:	alan@lxorguk.ukuu.org.uk
 S:	Odd Fixes
 F:	drivers/serial/8250*
 F:	include/linux/serial_8250.h
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
scripts-get_maintainerpl-output-first-field-only-in-mailing-lists-and-after-maintainers.patch
scripts-get_maintainerpl-better-fix-for-subscriber-only-mailing-lists.patch
scripts-get_maintainerpl-improve-git-chief-penquins-linus-torvalds-filtering.patch
scripts-get_maintainerpl-warn-on-missing-git-or-git-repository.patch
scripts-get_maintainerpl-support-m-lines-with-names-and-multiple-entries-per-m-line.patch
scripts-get_maintainerpl-better-email-name-quoting.patch
scripts-get_maintainerpl-support-both-p-m-and-integrated-m-lines.patch
scripts-get_maintainerpl-dont-print-maintainers-when-not-requested.patch
scripts-get_maintainerpl-allow-8-bit-characters-in-email-addresses.patch
scripts-get_maintainerpl-change-die-to-warn-when-command-line-file-is-not-a-patch.patch
maintainers-swap-mismarked-ecrypt-fs-m-and-p-entries.patch
maintainers-add-file-patterns-to-the-rest.patch
maintainers-update-m32r-file-patterns-after-rename.patch
maintainers-mark-alsa-lists-as-moderated.patch
maintainers-remove-l-linux-kernel-vgerkernelorg-from-all-but-the-rest.patch
maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch
maintainers-add-file-pattern-to-cisco-fcoe-hba-driver.patch
maintainers-add-paul-mckenney-to-rcu-and-rcutorture.patch
maintainers-add-file-patterns-to-tty-layer.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

