From: akpm@linux-foundation.org
Subject: [merged] unhide-config_panic_on_oops.patch removed from -mm tree
Date: Fri, 22 Feb 2013 12:39:44 -0800
Message-ID: <20130222203944.ACA8331C1C1@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:62421 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757011Ab3BVUjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 15:39:45 -0500
Received: by mail-ve0-f201.google.com with SMTP id 14so103475vea.2
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 12:39:45 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: unhide CONFIG_PANIC_ON_OOPS
has been removed from the -mm tree.  Its filename was
     unhide-config_panic_on_oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kyle McMartin <kyle@redhat.com>
Subject: lib/Kconfig.debug: unhide CONFIG_PANIC_ON_OOPS

CONFIG_EXPERT doesn't really make sense, and hides it unintentionally. 
Remove superfluous "default n" pointed out by Ingo as well.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN lib/Kconfig.debug~unhide-config_panic_on_oops lib/Kconfig.debug
--- a/lib/Kconfig.debug~unhide-config_panic_on_oops
+++ a/lib/Kconfig.debug
@@ -243,8 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
 config PANIC_ON_OOPS
-	bool "Panic on Oops" if EXPERT
-	default n
+	bool "Panic on Oops"
 	help
 	  Say Y here to enable the kernel to panic when it oopses. This
 	  has the same effect as setting oops=panic on the kernel command
_

Patches currently in -mm which might be from kyle@redhat.com are

origin.patch

