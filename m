From: akpm@osdl.org
Subject: + add-gitignore-file-for-relocs-in-arch-i386.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:29:23 -0800
Message-ID: <200612270729.kBR7TNeK004370@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36351 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940AbWL0H3j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: thomas@m3y3r.de


The patch titled
     Add .gitignore file for relocs in arch/i386
has been added to the -mm tree.  Its filename is
     add-gitignore-file-for-relocs-in-arch-i386.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add .gitignore file for relocs in arch/i386
From: Thomas Meyer <thomas@m3y3r.de>

Due to the changes to make the kernel relocateable a new file is created
during the build process.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 i386/boot/compressed/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null i386/boot/compressed/.gitignore
--- /dev/null
+++ a/i386/boot/compressed/.gitignore
@@ -0,0 +1 @@
+relocs
_

Patches currently in -mm which might be from thomas@m3y3r.de are

add-gitignore-file-for-relocs-in-arch-i386.patch

