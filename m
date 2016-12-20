From: akpm@linux-foundation.org
Subject: [patch 15/15] printk: fix typo in CONSOLE_LOGLEVEL_DEFAULT help
 text
Date: Mon, 19 Dec 2016 16:23:15 -0800
Message-ID: <585879f3.mzEaOQCRwengeMud%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50688 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752993AbcLTAWP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 19:22:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, bp@suse.de, olof@lixom.net

From: Borislav Petkov <bp@suse.de>
Subject: printk: fix typo in CONSOLE_LOGLEVEL_DEFAULT help text

s/prink/printk/

Link: http://lkml.kernel.org/r/20161215170111.19075-1-bp@alien8.de
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~printk-fix-typo-in-console_loglevel_default-help-text lib/Kconfig.debug
--- a/lib/Kconfig.debug~printk-fix-typo-in-console_loglevel_default-help-text
+++ a/lib/Kconfig.debug
@@ -26,7 +26,7 @@ config CONSOLE_LOGLEVEL_DEFAULT
 	  the kernel bootargs. loglevel=<x> continues to override whatever
 	  value is specified here as well.
 
-	  Note: This does not affect the log level of un-prefixed prink()
+	  Note: This does not affect the log level of un-prefixed printk()
 	  usage in the kernel. That is controlled by the MESSAGE_LOGLEVEL_DEFAULT
 	  option.
 
_
