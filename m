From: akpm@linux-foundation.org
Subject: [merged]
 printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:07:13 -0700
Message-ID: <53e3dc71.k7aRzGv+Hk5OMjg9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:54703 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbaHGUHO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:07:14 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1176048pab.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:07:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mcgrof@suse.com, andrew@lunn.ch, arunks.linux@gmail.com, cmetcalf@tilera.com, davidlohr@hp.com, gregkh@linuxfoundation.org, jack@suse.cz, joe@perches.com, keescook@chromium.org, mhocko@suse.cz, pmladek@suse.cz, swarren@wwwdotorg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: printk: make dynamic units clear for the kernel ring buffer
has been removed from the -mm tree.  Its filename was
     printk-make-dynamic-units-clear-for-the-kernel-ring-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: printk: make dynamic units clear for the kernel ring buffer

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
Suggested-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Petr Mladek <pmladek@suse.cz>
Cc: Joe Perches <joe@perches.com>
Cc: Arun KS <arunks.linux@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/printk/printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/printk/printk.c~printk-make-dynamic-units-clear-for-the-kernel-ring-buffer kernel/printk/printk.c
--- a/kernel/printk/printk.c~printk-make-dynamic-units-clear-for-the-kernel-ring-buffer
+++ a/kernel/printk/printk.c
@@ -879,7 +879,7 @@ void __init setup_log_buf(int early)
 	memcpy(log_buf, __log_buf, __LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
-	pr_info("log_buf_len: %d\n", log_buf_len);
+	pr_info("log_buf_len: %d bytes\n", log_buf_len);
 	pr_info("early log buf free: %d(%d%%)\n",
 		free, (free * 100) / __LOG_BUF_LEN);
 }
_

Patches currently in -mm which might be from mcgrof@suse.com are

origin.patch

