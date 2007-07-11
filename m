From: akpm@linux-foundation.org
Subject: + sky-cpu-and-nexus-get-rid-of-useless-null-init.patch added to -mm tree
Date: Wed, 11 Jul 2007 16:58:59 -0700
Message-ID: <200707112358.l6BNwxPg027688@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34271 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935663AbXGKX7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 19:59:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com


The patch titled
     Sky Cpu and Nexus: get rid of useless NULL init
has been added to the -mm tree.  Its filename is
     sky-cpu-and-nexus-get-rid-of-useless-null-init.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Sky Cpu and Nexus: get rid of useless NULL init
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch removes useless structure items init accroding to C99.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-get-rid-of-useless-null-init drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~sky-cpu-and-nexus-get-rid-of-useless-null-init
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -175,9 +175,6 @@ static const struct file_operations cpus
       .release	= cpustate_release,
       .read	= cpustate_read,
       .write	= cpustate_write,
-      .fasync	= NULL,
-      .poll	= NULL,
-      .ioctl	= NULL,
       .llseek	= no_llseek,
 };
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
sky-cpu-and-nexus-get-rid-of-useless-null-init.patch
sky-cpu-and-nexus-use-seq_file-single_open-on-proc.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
