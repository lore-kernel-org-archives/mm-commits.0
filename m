From: akpm@linux-foundation.org
Subject: [merged] lib-kconfig-use-bool-instead-of-boolean.patch removed
 from -mm tree
Date: Tue, 17 Feb 2015 12:06:37 -0800
Message-ID: <54e39f4d.BQOFixAF0UWBZVqK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35375 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbbBQUGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cj@linux.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig: use bool instead of boolean
has been removed from the -mm tree.  Its filename was
     lib-kconfig-use-bool-instead-of-boolean.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Jaeger <cj@linux.com>
Subject: lib/Kconfig: use bool instead of boolean

Keyword 'boolean' for type definition attributes is considered
deprecated and, therefore, should not be used anymore.

See http://lkml.kernel.org/r/cover.1418003065.git.cj@linux.com
See http://lkml.kernel.org/r/1419108071-11607-1-git-send-email-cj@linux.com

Signed-off-by: Christoph Jaeger <cj@linux.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig~lib-kconfig-use-bool-instead-of-boolean lib/Kconfig
--- a/lib/Kconfig~lib-kconfig-use-bool-instead-of-boolean
+++ a/lib/Kconfig
@@ -14,7 +14,7 @@ config BITREVERSE
 	tristate
 
 config HAVE_ARCH_BITREVERSE
-	boolean
+	bool
 	default n
 	depends on BITREVERSE
 	help
_

Patches currently in -mm which might be from cj@linux.com are

origin.patch
linux-next.patch

