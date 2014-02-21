From: akpm@linux-foundation.org
Subject: [alternative-merged]
 asm-systemh-sparc-sparc_cpu_model-isnt-in-asm-systemh-any-more.patch
 removed from -mm tree
Date: Fri, 21 Feb 2014 11:22:54 -0800
Message-ID: <5307a78e.+7W2CSS1CdpB6FlQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaBUTWz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 14:22:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, davem@davemloft.net, arnd@arndb.de, dhowells@redhat.com

Subject: [alternative-merged] asm-systemh-sparc-sparc_cpu_model-isnt-in-asm-systemh-any-more.patch removed from -mm tree
To: dhowells@redhat.com,arnd@arndb.de,davem@davemloft.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 11:22:54 -0800


The patch titled
     Subject: asm/system.h: sparc: sparc_cpu_model isn't in asm/system.h any more
has been removed from the -mm tree.  Its filename was
     asm-systemh-sparc-sparc_cpu_model-isnt-in-asm-systemh-any-more.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: asm/system.h: sparc: sparc_cpu_model isn't in asm/system.h any more

sparc_cpu_model isn't in asm/system.h any more, so remove a comment about it.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sbus/char/jsflash.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/sbus/char/jsflash.c~asm-systemh-sparc-sparc_cpu_model-isnt-in-asm-systemh-any-more drivers/sbus/char/jsflash.c
--- a/drivers/sbus/char/jsflash.c~asm-systemh-sparc-sparc_cpu_model-isnt-in-asm-systemh-any-more
+++ a/drivers/sbus/char/jsflash.c
@@ -507,11 +507,9 @@ static int jsflash_init(void)
 	}
 
 	/* Let us be really paranoid for modifications to probing code. */
-	/* extern enum sparc_cpu sparc_cpu_model; */ /* in <asm/system.h> */
-	if (sparc_cpu_model != sun4m) {
+	if (sparc_cpu_model != sun4m)
 		/* We must be on sun4m because we use MMU Bypass ASI. */
 		return -ENXIO;
-	}
 
 	if (jsf0.base == 0) {
 		jsf = &jsf0;
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
asm-systemh-clean-asm-systemh-from-docs.patch
asm-systemh-um-arch_align_stack-moved-to-asm-exech.patch
asm-systemh-arm-delete-asm-systemh.patch
linux-next.patch
mutex-subsystem-synchro-test-module.patch

