From: akpm@linux-foundation.org
Subject: - sky-cpu-and-nexus-get-rid-of-useless-null-init.patch removed from -mm tree
Date: Fri, 05 Oct 2007 12:56:40 -0700
Message-ID: <200710051956.l95JueCG022375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761143AbXJET4o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 15:56:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Sky Cpu and Nexus: get rid of useless NULL init
has been removed from the -mm tree.  Its filename was
     sky-cpu-and-nexus-get-rid-of-useless-null-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Sky Cpu and Nexus: get rid of useless NULL init
From: Cyrill Gorcunov <gorcunov@gmail.com>

This patch removes useless structure items init accroding to C99.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    3 ---
 1 file changed, 3 deletions(-)

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

git-cifs.patch
git-powerpc.patch
udf-code-style-fixup-v3.patch
