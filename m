From: akpm@linux-foundation.org
Subject: [folded-merged]
 printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch
 removed from -mm tree
Date: Wed, 20 Jan 2016 13:10:24 -0800
Message-ID: <569ff7c0.RB41BMp/BoXW/QBI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcATVKZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 20 Jan 2016 16:10:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, pmladek@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix
has been removed from the -mm tree.  Its filename was
     printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix.patch

This patch was dropped because it was folded into printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix

whitespace fixlet

Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/nmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/nmi.c~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix kernel/printk/nmi.c
--- a/kernel/printk/nmi.c~printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context-fix
+++ a/kernel/printk/nmi.c
@@ -65,7 +65,7 @@ static int vprintk_nmi(const char *fmt,
 again:
 	len = atomic_read(&s->len);
 
-	if (len >=  sizeof(s->buffer)) {
+	if (len >= sizeof(s->buffer)) {
 		atomic_inc(&nmi_message_lost);
 		return 0;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

printk-nmi-warn-when-some-message-has-been-lost-in-nmi-context.patch

