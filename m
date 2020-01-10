From: akpm@linux-foundation.org
Subject: [failures]
 ocfs2-remove-unneeded-header-include-path-in-fs-ocfs2-makefile.patch
 removed from -mm tree
Date: Thu, 09 Jan 2020 16:37:38 -0800
Message-ID: <20200110003738.-ihTwzxaZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730339AbgAJAhj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jan 2020 19:37:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gechangwei@live.cn, ghe@suse.com, jiangqi903@gmail.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mark@fasheh.com, masahiroy@kernel.org, mm-commits@vger.kernel.org, piaojun@huawei.com


The patch titled
     Subject: ocfs2: remove unneeded header include path in fs/ocfs2/Makefile
has been removed from the -mm tree.  Its filename was
     ocfs2-remove-unneeded-header-include-path-in-fs-ocfs2-makefile.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Masahiro Yamada <masahiroy@kernel.org>
Subject: ocfs2: remove unneeded header include path in fs/ocfs2/Makefile

You can build fs/ocfs2 without this.

Link: http://lkml.kernel.org/r/20200105070023.27806-1-masahiroy@kernel.org
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/Makefile |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/ocfs2/Makefile~ocfs2-remove-unneeded-header-include-path-in-fs-ocfs2-makefile
+++ a/fs/ocfs2/Makefile
@@ -1,5 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-ccflags-y := -I$(src)
 
 obj-$(CONFIG_OCFS2_FS) += 	\
 	ocfs2.o			\
_

Patches currently in -mm which might be from masahiroy@kernel.org are

ocfs2-make-local-header-paths-relative-to-c-files.patch
treewide-remove-redundent-is_err-before-error-code-check.patch
