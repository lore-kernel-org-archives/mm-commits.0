From: akpm@linux-foundation.org
Subject: + printk-fix-typo-in-console_loglevel_default-help-text.patch
 added to -mm tree
Date: Mon, 19 Dec 2016 15:45:24 -0800
Message-ID: <58587114.Np3zsN8R8ecbOLZC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48992 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753762AbcLSXoY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 18:44:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bp@suse.de, olof@lixom.net, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix typo in CONSOLE_LOGLEVEL_DEFAULT help text
has been added to the -mm tree.  Its filename is
     printk-fix-typo-in-console_loglevel_default-help-text.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-fix-typo-in-console_loglevel_default-help-text.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-fix-typo-in-console_loglevel_default-help-text.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from bp@suse.de are

printk-fix-typo-in-console_loglevel_default-help-text.patch

