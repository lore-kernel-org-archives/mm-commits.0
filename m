From: akpm@linux-foundation.org
Subject: [merged] um-tell-git-to-ignore-generated-files.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:05:25 -0800
Message-ID: <201003091905.o29J5Pu2031121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755871Ab0CITGW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:06:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jdike@addtoit.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     um: tell git to ignore generated files
has been removed from the -mm tree.  Its filename was
     um-tell-git-to-ignore-generated-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: tell git to ignore generated files
From: WANG Cong <xiyou.wangcong@gmail.com>

Tell git to ignore the generated files under um, except:

 include/shared/kern_constants.h
 include/shared/user_constants.h

which will be moved to include/generated.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore         |    1 +
 arch/um/.gitignore |    3 +++
 2 files changed, 4 insertions(+)

diff -puN .gitignore~um-tell-git-to-ignore-generated-files .gitignore
--- a/.gitignore~um-tell-git-to-ignore-generated-files
+++ a/.gitignore
@@ -36,6 +36,7 @@ modules.builtin
 #
 tags
 TAGS
+linux
 vmlinux
 vmlinuz
 System.map
diff -puN /dev/null arch/um/.gitignore
--- /dev/null
+++ a/arch/um/.gitignore
@@ -0,0 +1,3 @@
+kernel/config.c
+kernel/config.tmp
+kernel/vmlinux.lds
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

linux-next.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch

