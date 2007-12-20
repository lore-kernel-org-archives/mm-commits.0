From: akpm@linux-foundation.org
Subject: - fs-kconfig-grammar-fix.patch removed from -mm tree
Date: Thu, 20 Dec 2007 15:36:01 -0800
Message-ID: <200712202336.lBKNa1uR018768@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753083AbXLTXgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Dec 2007 18:36:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Uwe.Kleine-Koenig@digi.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     fs/Kconfig: grammar fix
has been removed from the -mm tree.  Its filename was
     fs-kconfig-grammar-fix.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: fs/Kconfig: grammar fix
=46rom: Uwe Kleine-K=C3=B6nig <Uwe.Kleine-Koenig@digi.com>

This was introduced in 4af8e944c22d8af92a7548354a9567250cc1a782

Signed-off-by: Uwe Kleine-K=C3=B6nig <Uwe.Kleine-Koenig@digi.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~fs-kconfig-grammar-fix fs/Kconfig
--- a/fs/Kconfig~fs-kconfig-grammar-fix
+++ a/fs/Kconfig
@@ -1305,7 +1305,7 @@ config JFFS2_COMPRESSION_OPTIONS
 	help
 	  Enabling this option allows you to explicitly choose which
 	  compression modules, if any, are enabled in JFFS2. Removing
-	  compressors and mean you cannot read existing file systems,
+	  compressors can mean you cannot read existing file systems,
 	  and enabling experimental compressors can mean that you
 	  write a file system which cannot be read by a standard kernel.
=20
_

Patches currently in -mm which might be from Uwe.Kleine-Koenig@digi.com=
 are

origin.patch
