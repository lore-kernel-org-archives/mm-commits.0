From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-uart_ops-to-normally-const-structs.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:09 -0700
Message-ID: <553550b5.JFxNTHbQrMPlp+2b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbbDTTKs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:10:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, gregkh@linuxfoundation.org, jslaby@suse.cz, mcoquelin.stm32@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add uart_ops to normally const structs
has been removed from the -mm tree.  Its filename was
     checkpatch-add-uart_ops-to-normally-const-structs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add uart_ops to normally const structs

Add another struct to the list of normally const struct types

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-uart_ops-to-normally-const-structs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-uart_ops-to-normally-const-structs
+++ a/scripts/checkpatch.pl
@@ -5339,6 +5339,7 @@ sub process {
 				stacktrace_ops|
 				sysfs_ops|
 				tty_operations|
+				uart_ops|
 				usb_mon_operations|
 				wd_ops}x;
 		if ($line !~ /\bconst\b/ &&
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
ocfs2-neaten-do_error-ocfs2_error-and-ocfs2_abort.patch
mm-utilc-add-kstrimdup.patch
linux-next.patch

