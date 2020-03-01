From: akpm@linux-foundation.org
Subject: [merged]
 init-mainc-mark-boot_config_checksum-static.patch removed from -mm tree
Date: Sat, 29 Feb 2020 17:51:58 -0800
Message-ID: <20200301015158.j_CdsVAIq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726786AbgCABv7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 29 Feb 2020 20:51:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hqjagain@gmail.com, mhiramat@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: init/main.c: mark boot_config_checksum static
has been removed from the -mm tree.  Its filename was
     init-mainc-mark-boot_config_checksum-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qiujun Huang <hqjagain@gmail.com>
Subject: init/main.c: mark boot_config_checksum static

In fact, this function is only used in this file, so mark it with 'static'.

Link: http://lkml.kernel.org/r/1581852511-14163-1-git-send-email-hqjagain@gmail.com
Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/init/main.c~init-mainc-mark-boot_config_checksum-static
+++ a/init/main.c
@@ -336,7 +336,7 @@ static char * __init xbc_make_cmdline(co
 	return new_cmdline;
 }
 
-u32 boot_config_checksum(unsigned char *p, u32 size)
+static u32 boot_config_checksum(unsigned char *p, u32 size)
 {
 	u32 ret = 0;
 
_

Patches currently in -mm which might be from hqjagain@gmail.com are
