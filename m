From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix.patch removed from -mm tree
Date: Wed, 20 Jan 2016 13:11:11 -0800
Message-ID: <569ff7ef.oLRjaMRaJxStdQnh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754445AbcATVLM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:11:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pmladek@suse.com, arnd@arndb.de, geert+renesas@glider.be, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix
has been removed from the -mm tree.  Its filename was
     printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix.patch

This patch was dropped because it was folded into printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable.patch

------------------------------------------------------
From: Petr Mladek <pmladek@suse.com>
Subject: printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix

Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix init/Kconfig
--- a/init/Kconfig~printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix
+++ a/init/Kconfig
@@ -870,7 +870,7 @@ config NMI_LOG_BUF_SHIFT
 	int "Temporary per-CPU NMI log buffer size (12 => 4KB, 13 => 8KB)"
 	range 10 21
 	default 13
-	depends on PRINTK && HAVE_NMI
+	depends on PRINTK_NMI
 	help
 	  Select the size of a per-CPU buffer where NMI messages are temporary
 	  stored. They are copied to the main log buffer in a safe context
_

Patches currently in -mm which might be from pmladek@suse.com are

printk-nmi-generic-solution-for-safe-printk-in-nmi.patch
printk-nmi-use-irq-work-only-when-ready.patch
printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context.patch
printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable.patch
printk-nmi-increase-the-size-of-nmi-buffer-and-make-it-configurable-fix-2.patch

