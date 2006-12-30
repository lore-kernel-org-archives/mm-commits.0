From: akpm@osdl.org
Subject: - add-gitignore-file-for-relocs-in-arch-i386-fix.patch removed from -mm tree
Date: Fri, 29 Dec 2006 16:39:47 -0800
Message-ID: <200612300040.kBU0e7ov007936@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36462 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbWL3AkY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Dec 2006 19:40:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, thomas@m3y3r.de, mm-commits@vger.kernel.org


The patch titled
     Arch: add gitignore file for relocs in arch i386 fix
has been removed from the -mm tree.  Its filename was
     add-gitignore-file-for-relocs-in-arch-i386-fix.patch

This patch was dropped because it was folded into add-gitignore-file-for-relocs-in-arch-i386.patch

------------------------------------------------------
Subject: Arch: add gitignore file for relocs in arch i386 fix
From: Jiri Slaby <jirislaby@gmail.com>

add gitignore file for relocs in arch i386 fix

The .gitigonre was intended to be in arch/ subtree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/boot/compressed/.gitignore |    1 +
 i386/boot/compressed/.gitignore      |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN /dev/null arch/i386/boot/compressed/.gitignore
--- /dev/null
+++ a/arch/i386/boot/compressed/.gitignore
@@ -0,0 +1 @@
+relocs
diff -puN i386/boot/compressed/.gitignore~add-gitignore-file-for-relocs-in-arch-i386-fix /dev/null
--- a/i386/boot/compressed/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-relocs
_

Patches currently in -mm which might be from jirislaby@gmail.com are

add-gitignore-file-for-relocs-in-arch-i386.patch
add-gitignore-file-for-relocs-in-arch-i386-fix.patch
char-mxser-fix-oops-when-removing-opened.patch
char-isicom-eliminate-spinlock-recursion.patch

