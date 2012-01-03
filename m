From: akpm@linux-foundation.org
Subject: [folded] procfs-remove-superfluous-debug-output.patch removed from -mm tree
Date: Tue, 03 Jan 2012 13:57:18 -0800
Message-ID: <20120103215719.1C1E25C00A9@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:64231 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2ACV5V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 16:57:21 -0500
Received: by eaak10 with SMTP id k10so310883eaa.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 13:57:19 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: procfs: remove superfluous debug output
has been removed from the -mm tree.  Its filename was
     procfs-remove-superfluous-debug-output.patch

This patch was dropped because it was folded into procfs-add-hidepid=-and-gid=-mount-options.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasiliy Kulikov <segoon@openwall.com>
Subject: procfs: remove superfluous debug output

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/root.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/proc/root.c~procfs-remove-superfluous-debug-output fs/proc/root.c
--- a/fs/proc/root.c~procfs-remove-superfluous-debug-output
+++ a/fs/proc/root.c
@@ -53,8 +53,6 @@ static int proc_parse_options(char *opti
 	substring_t args[MAX_OPT_ARGS];
 	int option;
 
-	pr_debug("proc: options = %s\n", options);
