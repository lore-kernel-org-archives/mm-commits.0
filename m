From: akpm@linux-foundation.org
Subject: [merged] tools-vm-add-gitignore-to-ignore-built-binaries.patch removed from -mm tree
Date: Tue, 05 Feb 2013 12:20:15 -0800
Message-ID: <20130205202015.822D831C1CE@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:57530 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756368Ab3BEUUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2013 15:20:16 -0500
Received: by mail-yh0-f73.google.com with SMTP id 28so27141yhr.2
        for <mm-commits@vger.kernel.org>; Tue, 05 Feb 2013 12:20:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm: add .gitignore to ignore built binaries
has been removed from the -mm tree.  Its filename was
     tools-vm-add-gitignore-to-ignore-built-binaries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: tools/vm: add .gitignore to ignore built binaries

There is no .gitignore in tools/vm, so 'git status' always show built
binaries.  To ignore this, add .gitignore.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/.gitignore |    2 ++
 1 file changed, 2 insertions(+)

diff -puN /dev/null tools/vm/.gitignore
--- /dev/null
+++ a/tools/vm/.gitignore
@@ -0,0 +1,2 @@
+slabinfo
+page-types
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

