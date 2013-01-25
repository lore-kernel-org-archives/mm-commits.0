From: akpm@linux-foundation.org
Subject: [to-be-updated] config_panic_on_oops-should-be-shown-if-debug_kernel.patch removed from -mm tree
Date: Thu, 24 Jan 2013 16:30:32 -0800
Message-ID: <20130125003033.454AF31C1F8@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:46031 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3AYAae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 19:30:34 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so1146534yen.2
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 16:30:33 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kyle@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/Kconfig.debug: CONFIG_PANIC_ON_OOPS should be shown if DEBUG_KERNEL
has been removed from the -mm tree.  Its filename was
     config_panic_on_oops-should-be-shown-if-debug_kernel.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Kyle McMartin <kyle@redhat.com>
Subject: lib/Kconfig.debug: CONFIG_PANIC_ON_OOPS should be shown if DEBUG_KERNEL

CONFIG_EXPERT is a bit silly a place for this, and hides it unnecessarily.
CONFIG_DEBUG_KERNEL makes much more sense.

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~config_panic_on_oops-should-be-shown-if-debug_kernel lib/Kconfig.debug
--- a/lib/Kconfig.debug~config_panic_on_oops-should-be-shown-if-debug_kernel
+++ a/lib/Kconfig.debug
@@ -243,7 +243,7 @@ config BOOTPARAM_SOFTLOCKUP_PANIC_VALUE
 	default 1 if BOOTPARAM_SOFTLOCKUP_PANIC
 
 config PANIC_ON_OOPS
-	bool "Panic on Oops" if EXPERT
+	bool "Panic on Oops" if DEBUG_KERNEL
 	default n
 	help
 	  Say Y here to enable the kernel to panic when it oopses. This
_

Patches currently in -mm which might be from kyle@redhat.com are


