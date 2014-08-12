From: akpm@linux-foundation.org
Subject: [merged] drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:40:52 -0700
Message-ID: <53ea6dc4.dmhx0H0wFKJg8Q08%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:40906 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaHLTkx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:53 -0400
Received: by mail-qa0-f74.google.com with SMTP id j15so1309836qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, linus.walleij@linaro.org, wsa@the-dreams.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/parport/parport_ip32.c: use PTR_ERR_OR_ZERO
has been removed from the -mm tree.  Its filename was
     drivers-parport-parport_ip32c-use-ptr_err_or_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: drivers/parport/parport_ip32.c: use PTR_ERR_OR_ZERO

replace IS_ERR/PTR_ERR

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/parport/parport_ip32.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/parport/parport_ip32.c~drivers-parport-parport_ip32c-use-ptr_err_or_zero drivers/parport/parport_ip32.c
--- a/drivers/parport/parport_ip32.c~drivers-parport-parport_ip32c-use-ptr_err_or_zero
+++ a/drivers/parport/parport_ip32.c
@@ -2204,7 +2204,7 @@ static int __init parport_ip32_init(void
 {
 	pr_info(PPIP32 "SGI IP32 built-in parallel port driver v0.6\n");
 	this_port = parport_ip32_probe_port();
-	return IS_ERR(this_port) ? PTR_ERR(this_port) : 0;
+	return PTR_ERR_OR_ZERO(this_port);
 }
 
 /**
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

