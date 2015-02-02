From: akpm@linux-foundation.org
Subject: + lib-kconfig-use-bool-instead-of-boolean.patch added to -mm tree
Date: Mon, 02 Feb 2015 15:24:16 -0800
Message-ID: <54d00720.WmveZs3LRn1kLEV7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35420 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbbBBXYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2015 18:24:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cj@linux.com, linux@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig: use bool instead of boolean
has been added to the -mm tree.  Its filename is
     lib-kconfig-use-bool-instead-of-boolean.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-kconfig-use-bool-instead-of-boolean.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-kconfig-use-bool-instead-of-boolean.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-add-check-for-keyword-boolean-in-kconfig-definitions.patch
checkpatch-add-likely-unlikely-comparison-misuse-test.patch
linux-next.patch
lib-kconfig-use-bool-instead-of-boolean.patch

