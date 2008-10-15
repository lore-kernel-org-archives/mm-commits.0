From: akpm@linux-foundation.org
Subject: - proc-proc_sys_root-tweak.patch removed from -mm tree
Date: Wed, 15 Oct 2008 14:14:12 -0700
Message-ID: <200810152114.m9FLECxC005720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457AbYJOVOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Oct 2008 17:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     proc: proc_sys_root tweak
has been removed from the -mm tree.  Its filename was
     proc-proc_sys_root-tweak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: proc_sys_root tweak
From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/proc/proc_sysctl.c~proc-proc_sys_root-tweak fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~proc-proc_sys_root-tweak
+++ a/fs/proc/proc_sysctl.c
@@ -395,10 +395,10 @@ static struct dentry_operations proc_sys
 	.d_compare	= proc_sys_compare,
 };
 
-static struct proc_dir_entry *proc_sys_root;
