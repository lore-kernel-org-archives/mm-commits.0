From: akpm@osdl.org
Subject: - add-gitignore-file-for-relocs-in-arch-i386.patch removed from -mm tree
Date: Mon, 01 Jan 2007 23:23:59 -0800
Message-ID: <200701020723.l027NxUD012910@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:37301 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932740AbXABHY0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 02:24:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Add .gitignore file for relocs in arch/i386
has been removed from the -mm tree.  Its filename was
     add-gitignore-file-for-relocs-in-arch-i386.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add .gitignore file for relocs in arch/i386
From: Thomas Meyer <thomas@m3y3r.de>

Due to the changes to make the kernel relocateable a new file is created
during the build process.

[jirislaby@gmail.com: The .gitigonre was intended to be in arch/ subtree]
Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/boot/compressed/.gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN /dev/null arch/i386/boot/compressed/.gitignore
--- /dev/null
+++ a/arch/i386/boot/compressed/.gitignore
@@ -0,0 +1 @@
+relocs
_

Patches currently in -mm which might be from thomas@m3y3r.de are
